###*
  @fileoverview Hover simulation for touch devices, :hover does not work well
  on mobile devices. It flickers, hover state isn't removed etc. So this class
  provides alternative approach via este.events.TapHandler. It adds e-hover
  className for matched elements.

  Desiderated behaviour:
    'e-mobile-hover' class is applied immediately
    'e-mobile-hover-scroll' class is applied after 250ms, which is usefull for
      scrollable content, where we don't want to see 'hover' immediately.
      It mimics native iOS behaviour on scrollable lists.
    Hover state is removed after 750ms, because on anchors native context menu
      is shown and that prevents touchend event to be dispatched. Previous
      hover is removed too for sure.
###
goog.provide 'este.mobile.Hover'

goog.require 'este.Base'
goog.require 'este.events.TapHandler'
goog.require 'goog.dom'
goog.require 'goog.dom.classlist'

class este.mobile.Hover extends este.Base

  ###*
    @param {Element} element
    @constructor
    @extends {este.Base}
  ###
  constructor: (element) ->
    super()
    @tapHandler = new este.events.TapHandler element

  ###*
    Defines on which elements hover state is simulated.
    @type {function(Node) : boolean}
  ###
  matcher: (node) ->
    return false if !node.tagName
    `node = /** @type {Element} */(node)`
    node.tagName == 'A' || goog.dom.classlist.contains node, 'button'

  ###*
    @type {este.events.TapHandler}
    @protected
  ###
  tapHandler: null

  ###*
    @type {Node}
    @protected
  ###
  previous: null

  ###*
    @type {?number}
    @protected
  ###
  hoverScrollTimeout: null

  ###*
    @param {boolean} enabled
  ###
  setEnabled: (enabled) ->
    if enabled
      @on @tapHandler, 'start', @onTapHandlerStart
      @on @tapHandler, 'end', @onTapHandlerEnd
    else
      @off @tapHandler, 'start', @onTapHandlerStart
      @off @tapHandler, 'end', @onTapHandlerEnd

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onTapHandlerStart: (e) ->
    target = @getFilteredTarget e.target
    return if !target
    @handlePrevious target
    @addHoverNow target
    @addHoverScrollAfterWhile target
    @removeHoverStateAfterWhile target

  ###*
    @param {Node} target
    @protected
  ###
  handlePrevious: (target) ->
    @removeHoverState @previous
    @previous = target

  ###*
    @param {Node} target
    @protected
  ###
  addHoverNow: (target) ->
    `target = /** @type {Element} */(target)`
    goog.dom.classlist.add target, 'e-mobile-hover'

  ###*
    @param {Node} target
    @protected
  ###
  addHoverScrollAfterWhile: (target) ->
    @hoverScrollTimeout = setTimeout =>
      `target = /** @type {Element} */(target)`
      goog.dom.classlist.add target, 'e-mobile-hover-scroll'
    , 250

  ###*
    Remove hover state after 750ms, because native anchor context menu prevents
    touchend, which is supposed to remove hover classNames.
    @param {Node} target
    @protected
  ###
  removeHoverStateAfterWhile: (target) ->
    setTimeout =>
      @removeHoverState target
    , 750

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onTapHandlerEnd: (e) ->
    @removeHoverState @previous

  ###*
    @param {Node} target
    @protected
  ###
  removeHoverState: (target) ->
    clearTimeout @hoverScrollTimeout
    return if !target
    `target = /** @type {Element} */(target)`
    goog.dom.classlist.remove target, 'e-mobile-hover'
    goog.dom.classlist.remove target, 'e-mobile-hover-scroll'

  ###*
    @param {Node} node
    @return {Node}
    @protected
  ###
  getFilteredTarget: (node) ->
    goog.dom.getAncestor node, @matcher, true

  ###*
    @override
  ###
  disposeInternal: ->
    @tapHandler.dispose()
    super()
    return