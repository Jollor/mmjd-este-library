###*
  @fileoverview este.demos.app.layout.home.View.
###
goog.provide 'este.demos.app.layout.home.View'

goog.require 'este.app.View'

class este.demos.app.layout.home.View extends este.app.View

  ###*
    @constructor
    @extends {este.app.View}
  ###
  constructor: ->
    super()

  ###*
    @override
  ###
  update: ->
    @getElement().innerHTML = 'Home content.'
    return