###*
  @fileoverview Abstract base class for validators.

  @see ../demos/validators.html

  Example:
  <pre>

  class Person extends este.Model

    constructor: (json) ->
      super json

    (at)getMsg = ->
      (at)desc ...
      Person.MSG_PERSON_NAME_REQUIRED = goog.getMsg 'Person name is required.'

    defaults:
      'name': ''
      'age': 0
      'gender': ''

    schema:
      'name':
        validators: [
          este.validators.required Person.getMsg
          este.validators.range 3, 100
          este.validators.exclusion ['Admin']
        ]
      'age':
        validators: [
          este.validators.range 0, 150
        ]
      'gender':
        validators: [
          este.validators.inclusion ['Male', 'Female']
        ]

  </pre>
###
goog.provide 'este.validators.Base'

goog.require 'goog.asserts'

class este.validators.Base

  ###*
    @param {function(): string=} getMsg
    @constructor
  ###
  constructor: (getMsg) ->
    @getMsg = getMsg if getMsg

  ###*
    Model to be validated.
    @type {este.Model}
  ###
  model: null

  ###*
    Model's property.
    @type {string}
  ###
  key: ''

  ###*
    Model's property value.
    @type {*}
  ###
  value: undefined

  ###*
    Returns true for truthy values except empty string.
    @return {boolean}
  ###
  isValidable: ->
    @value? && @value != ''

  ###*
    @return {boolean} True, if value is valid.
  ###
  validate: goog.abstractMethod

  ###*
    @return {string}
  ###
  getMsg: goog.abstractMethod