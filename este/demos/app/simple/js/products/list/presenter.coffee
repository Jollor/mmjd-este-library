###*
  @fileoverview este.demos.app.simple.products.list.Presenter.
###
goog.provide 'este.demos.app.simple.products.list.Presenter'

goog.require 'este.app.Presenter'
goog.require 'este.demos.app.simple.products.Collection'
goog.require 'este.demos.app.simple.products.list.View'

class este.demos.app.simple.products.list.Presenter extends este.app.Presenter

  ###*
    @constructor
    @extends {este.app.Presenter}
  ###
  constructor: ->
    super()
    @view = new este.demos.app.simple.products.list.View

  ###*
    @override
  ###
  load: (params) ->
    window['console']['log'] 'loading products index'
    # async simulation
    result = new goog.result.SimpleResult
    setTimeout =>
      # fixtures
      products = new este.demos.app.simple.products.Collection [
        'id': 0
        'name': 'products/0'
        'description': 'slow loading, 6s'
      ,
        'id': 1
        'name': 'products/1'
        'description': '2s loading'
      ,
        'id': 2
        'name': 'products/2'
        'description': '2s loading'
      ]
      result.setValue products
    , 1000
    result

  ###*
    @override
  ###
  show: (result) ->
    @view.products = (`/** @type {este.demos.app.simple.products.Collection} */`) result.
      getValue()
    return