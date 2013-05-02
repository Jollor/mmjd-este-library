###*
  @fileoverview este.app.Presenter orchestrates model/collection, view,
  and storage. Presenter has load method, which is used for model/collection
  loading. You can use este.storage.Local, este.storage.Rest, or implement your
  own storage. Load method has to return goog.result.Result object. este.App
  calls presenter's show method, when presenter is loaded and if loading was
  not canceled. Show method will render este.app.View, and if view is yet
  rendered, then call just enterDocument method. If presenter is going to be
  hide, then este.App will call presenter's hide method. Hide method calls
  este.app.View's exitDocument method. Show method also call screen's show
  method, which is used for orchestrating DOM elements. Presenter's constructor
  should instance model/collection and view.

  Example
    Take a look at este.demos.app.todomvc.todos.Presenter demo.

  Steps for creating your own presenter
    - create model/collection
    - create view
    - instantiate them in constructor
    - override load method
###
goog.provide 'este.app.Presenter'

goog.require 'este.app.View'
goog.require 'este.Base'
goog.require 'este.result'

class este.app.Presenter extends este.Base

  ###*
    @constructor
    @extends {este.Base}
  ###
  constructor: ->
    super()

  ###*
    @type {este.app.View}
    @protected
  ###
  view: null

  ###*
    @type {este.storage.Base}
  ###
  storage: null

  ###*
    @type {este.app.screen.Base}
  ###
  screen: null

  ###*
    @type {Function}
  ###
  createUrl: null

  ###*
    @type {Function}
  ###
  redirect: null

  ###*
    Load method has to return object implementing goog.result.Result interface.
    This method should be overridden.
    @param {Object=} params
    @return {!goog.result.Result}
  ###
  load: (params) ->
    este.result.ok()

  ###*
    Called If load were successful and not canceled.
    @param {boolean} isNavigation
  ###
  beforeShow: (isNavigation) ->
    return if !@view
    @view.createUrl = @createUrl
    @view.redirect = @redirect
    @show()
    @screen.show @view, isNavigation

  ###*
    You can use this method to pass data into view or start watching view model
    events.
    @protected
  ###
  show: ->

  ###*
    Called by este.App when next presenter is going to be shown.
  ###
  beforeHide: ->
    @hide()
    @screen.hide @view

  ###*
    @protected
  ###
  hide: ->

  ###*
    @override
  ###
  disposeInternal: ->
    @view.dispose()
    super()
    return