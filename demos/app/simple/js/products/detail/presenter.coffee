###*
  @fileoverview este.demos.app.simple.products.detail.Presenter.
###
goog.provide 'este.demos.app.simple.products.detail.Presenter'

goog.require 'este.app.Presenter'
goog.require 'este.demos.app.simple.products.detail.View'

class este.demos.app.simple.products.detail.Presenter extends este.app.Presenter

  ###*
    @constructor
    @extends {este.app.Presenter}
  ###
  constructor: ->
    super()
    @view = new este.demos.app.simple.products.detail.View

  ###*
    @type {Object}
    @protected
  ###
  params: null

  ###*
    @override
  ###
  load: (@params = {}) ->
    # async simulation
    result = new goog.result.SimpleResult
    setTimeout ->
      result.setValue null
    , 2000
    result

  ###*
    @override
  ###
  show: ->
    @view.params = @params
    return