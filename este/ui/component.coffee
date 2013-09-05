###*
  @fileoverview este.ui.Component provides easy event delegation and synthetic
  events registration. For example, if you want to use bubbling focus/blur, you
  have to instantiate goog.events.FocusHandler in enterDocument method, and
  dispose it in exitDocument. With este.ui.Component, you don't have to write
  this boilerplate code. For easy event delegation, replace event src with
  matching string selector. Note how bindModel method is used for automatic
  element-model wiring via 'e-model-cid' attribute.

  Supported synthetic (with bubbling) events:

  - tap, swipeleft, swiperight, swipeup, swipedown
  - focusin, focusout
  - input
  - submit
  - key or number from goog.events.KeyCodes enumeration

  Examples:

  ```coffee
  this.enterDocument ->
    super()
    this.on this.getElement(), 'click', this.onClick
    this.on '.box', 'tap', this.onBoxTap
    this.on 'input', 'focusin', this.onInputFocus
    this.on this.boxElement, 'tap', this.onTap
    this.on '.button', 'swipeleft', this.onButtonSwipeleft
    this.on '#new-todo-form', 'submit', this.onNewTodoFormSubmit
    this.on '.toggle', 'dblclick', this.onToggleDblclick
    this.on '.new-post', goog.events.KeyCodes.ENTER, this.onNewCommentKeyEnter
    return
  ```

  ```coffee
  this.enterDocument ->
    super()
    # note how bindModel is used
    this.on '.box', 'tap', this.bindModel this.onBoxTap
    return
  ```

  @see /demos/ui/component.html
  @see /demos/app/todomvc/js/todos/list/view.coffee
###
goog.provide 'este.ui.Component'

goog.require 'este.Collection'
goog.require 'este.dom'
goog.require 'este.events.EventHandler'
goog.require 'este.Model'
goog.require 'goog.asserts'
goog.require 'goog.dom.classlist'
goog.require 'goog.ui.Component'

class este.ui.Component extends goog.ui.Component

  ###*
    @param {goog.dom.DomHelper=} domHelper Optional DOM helper.
    @constructor
    @extends {goog.ui.Component}
  ###
  constructor: (domHelper) ->
    super domHelper

  ###*
    @param {Function} fn
    @param {number} keyCode
    @param {*} handler
    @return {Function}
    @protected
  ###
  @wrapListenerForKeyHandlerKeyFilter: (fn, keyCode, handler) ->
    (e) ->
      return if e.keyCode != keyCode
      fn.call handler, e

  ###*
    @param {Function} fn
    @param {string} selector
    @return {Function}
    @protected
  ###
  @wrapListenerForEventDelegation: (fn, selector) ->
    matcher = (node) ->
      goog.dom.isElement(node) && este.dom.match node, selector
    (e) ->
      target = goog.dom.getAncestor e.target, matcher, true
      return if !target || este.dom.isMouseHoverEventWithinElement e, target
      e.originalTarget = e.target
      e.target = target
      fn.call @, e

  ###*
    @param {Element} el
    @return {Element}
    @protected
  ###
  @getParentElementWithClientId: (el) ->
    parent = goog.dom.getAncestor el, (node) ->
      goog.dom.isElement(node) && (
        node.hasAttribute('e-model-cid') ||
        node.hasAttribute('data-e-model-cid'))
    , true
    (`/** @type {Element} */`) parent

  ###*
    @type {este.events.EventHandler}
    @private
  ###
  esteHandler_: null

  ###*
    @type {Object}
    @private
  ###
  componentListenables_: null

  ###*
    @param {goog.events.ListenableType|string} src Event source.
    @param {string|number|Array.<string|number>} type Event type to listen for
      or array of event types.
    @param {Function} fn Optional callback function to be used as the listener.
    @param {boolean=} capture Optional whether to use capture phase.
    @param {Object=} handler Object in whose scope to call the listener.
    @param {boolean=} once
    @protected
  ###
  on: (src, type, fn, capture, handler, once) ->
    if goog.isArray type
      @on src, t, fn, capture, handler for t in type
      return

    id = @getComponentListenableId src, type, fn, capture, handler
    return if @componentListenables_?[id]

    if once
      fn = do (src, type, fn, capture, handler) ->
        (e) ->
          @off src, type, fn, capture, handler
          fn.call @, e

    useEventDelegation = goog.isString src
    if useEventDelegation
      selector = src
      src = @getElement()

    isKeyEventType = goog.dom.isElement(src) && goog.isNumber type
    if isKeyEventType
      keyCode = (`/** @type {number} */`) type
      fn = Component.wrapListenerForKeyHandlerKeyFilter fn, keyCode, @
      type = 'key'

    if useEventDelegation
      selector = (`/** @type {string} */`) selector
      fn = Component.wrapListenerForEventDelegation fn, selector

    @componentListenables_ ?= {}
    @componentListenables_[id] = [src, type, fn, capture, handler]

    type = (`/** @type {string} */`) type
    src = (`/** @type {goog.events.ListenableType} */`) src
    @getHandler().listen src, type, fn, capture, handler
    return

  ###*
    @param {goog.events.ListenableType|string} src Event source.
    @param {string|number|Array.<string|number>} type Event type to listen for
      or array of event types.
    @param {Function} fn Optional callback function to be used as the listener.
    @param {boolean=} capture Optional whether to use capture phase.
    @param {Object=} handler Object in whose scope to call the listener.
    @protected
  ###
  once: (src, type, fn, capture, handler) ->
    @on src, type, fn, capture, handler, true

  ###*
    @param {goog.events.ListenableType|string} src Event source.
    @param {string|number|Array.<string|number>} type Event type to listen for
      or array of event types.
    @param {Function} fn Optional callback function to be used as the listener.
    @param {boolean=} capture Optional whether to use capture phase.
    @param {Object=} handler Object in whose scope to call the listener.
    @protected
  ###
  off: (src, type, fn, capture, handler) ->
    if goog.isArray type
      @off src, t, fn, capture, handler for t in type
      return

    id = @getComponentListenableId src, type, fn, capture, handler
    listenable = @componentListenables_?[id]
    return if !listenable
    @getHandler().unlisten.apply @getHandler(), listenable
    delete @componentListenables_[id]
    return

  ###*
    @override
  ###
  getHandler: ->
    @esteHandler_ ?= new este.events.EventHandler @

  ###*
    @protected
  ###
  getComponentListenableId: (src, type, fn, capture, handler) ->
    [
      if goog.isString(src) then src else goog.getUid src
      type
      goog.getUid fn
      capture
      if handler then goog.getUid(handler) else handler
    ].join()

  ###*
    @override
  ###
  exitDocument: ->
    @esteHandler_?.removeAll()
    @componentListenables_ = null
    super()
    return

  ###*
    Use this method when target has e-model-cid attribute. It will pass model
    instead of element if such model exists on any collection on this instance.
    @param {Function} fn
    @return {Function}
  ###
  bindModel: (fn) ->
    (e) ->
      el = Component.getParentElementWithClientId e.target
      if el
        cid = el.getAttribute('e-model-cid') || el.getAttribute 'data-e-model-cid'
        model = @findModelOnInstanceByClientId cid
      fn.call @, model, el, e

  ###*
    @param {string} clientId
    @return {este.Model}
    @protected
  ###
  findModelOnInstanceByClientId: (clientId) ->
    for key, value of @
      if value instanceof este.Collection
        model = value.findByClientId clientId
        return model if model
      else if value instanceof este.Model
        return value if value.get('_cid') == clientId
    null