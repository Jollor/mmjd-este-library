###*
  @fileoverview Model with attributes and schema.

  Features
    setters, getters, validators
    model's change event with event bubbling
    JSON serialization

  Why not plain objects?
    - http://www.devthought.com/2012/01/18/an-object-is-not-a-hash
    - strings are better for uncompiled attributes from DOM or storage etc.

  _cid
    _cid is temporary session id. It's erased when you close your browser.
    It's used for HTML rendering, it starts with ':'.
    For local storage persistence is used este.storage.Local unique-enough ID.

  Notes
    - to modify complex attribute: joe.get('items').add 'foo'
    - how to define schema: see model_test.coffee

  @see ../demos/model.html
  @see ../demos/app/todomvc/index.html
  @see ../demos/app/todomvc/js/todos/model.coffee
###

goog.provide 'este.Model'
goog.provide 'este.Model.EventType'
goog.provide 'este.Model.Event'

goog.require 'este.Base'
goog.require 'este.json'
goog.require 'este.model.getters'
goog.require 'este.model.setters'
goog.require 'goog.events.Event'
goog.require 'goog.object'
goog.require 'goog.ui.IdGenerator'

goog.require 'este.validators.Base'
goog.require 'este.validators.digits'
goog.require 'este.validators.email'
goog.require 'este.validators.exclusion'
goog.require 'este.validators.format'
goog.require 'este.validators.inclusion'
goog.require 'este.validators.max'
goog.require 'este.validators.maxLength'
goog.require 'este.validators.min'
goog.require 'este.validators.minLength'
goog.require 'este.validators.number'
goog.require 'este.validators.range'
goog.require 'este.validators.rangeLength'
goog.require 'este.validators.required'
goog.require 'este.validators.url'

class este.Model extends este.Base

  ###*
    @param {Object=} json
    @param {function(): string=} idGenerator
    @constructor
    @extends {este.Base}
  ###
  constructor: (json, idGenerator) ->
    super()
    @attributes = {}
    @schema ?= {}
    defaults = @getResolvedDefaults()
    @setInternal defaults, true if defaults
    @setInternal json, true if json
    @ensureClientId idGenerator

  ###*
    @enum {string}
  ###
  @EventType:
    # dispatched on model change
    CHANGE: 'change'
    # dispatched on collection change
    ADD: 'add'
    REMOVE: 'remove'
    SORT: 'sort'
    # dispatched always on any change
    UPDATE: 'update'

  ###*
    @param {?} a
    @param {?} b
    @suppress {missingProperties} Because runtime detection.
  ###
  @equal: (a, b) ->
    # null, undefined, falsy
    return a == b if !a || !b
    # este.Model or este.Collection
    a = este.json.stringify a.toJson() if a?.toJson
    b = este.json.stringify b.toJson() if b?.toJson
    este.json.equal a, b

  ###*
    http://www.restapitutorial.com/lessons/restfulresourcenaming.html
    Url has to start with '/'. Function type is usefull for inheritance.
    @type {string|function(): string}
    @protected
  ###
  url: '/models'

  ###*
    @type {Object}
    @protected
  ###
  defaults: null

  ###*
    @type {Object}
    @protected
  ###
  schema: null

  ###*
    Custom ID attribute, ex. 'userId' or '_id'.
    Nested keys are supported, ex. '_id.$oid'.
    @type {string}
    @protected
  ###
  idAttribute: 'id'

  ###*
    @type {string}
    @protected
  ###
  id: ''

  ###*
    @type {Object}
    @protected
  ###
  attributes: null

  ###*
    @param {string|number} id
  ###
  setId: (id) ->
    json = {}
    nested = json
    idAttributes = @idAttribute.split '.'
    for idAttribute, i in idAttributes
      if i == idAttributes.length - 1
        nested[idAttribute] = id
      else
        nested = nested[idAttribute] = {}
    @setInternal json, true

  ###*
    @return {string}
  ###
  getId: ->
    @id

  ###*
    @return {string}
  ###
  getUrl: ->
    url = @url
    url = url() if goog.isFunction url
    url

  ###*
    Generates URLs of the form:
      "/[collection.getUrl()]/[getId()]" if collection
      "/[model.url]/[getId()]" without collection
    @param {este.Collection=} collection
    @return {string}
  ###
  createUrl: (collection) ->
    url = if collection then collection.getUrl() else @getUrl()
    id = @getId()
    return url if !id
    url + '/' + id

  ###*
    Set model attribute(s).
    model.set 'foo', 1
    model set 'foo': 1, 'bla': 2
    Don't set any value on validation error.
    Dispatch change event with changed property, if any.
    Returns errors.
    @param {Object|string} json Object of key value pairs or string key.
    @param {*=} value value or nothing.
    @return {Array.<este.validators.Base>}
  ###
  set: (json, value) ->
    return null if !json

    if typeof json == 'string'
      _json = {}
      _json[json] = value
      json = _json

    @setInternal json

  ###*
    Returns model attribute(s).
    @param {string|Array.<string>} key
    @return {*|Object.<string, *>}
  ###
  get: (key) ->
    if typeof key != 'string'
      json = {}
      json[k] = @get k for k in key
      return json

    meta = @schema[key]?['meta']
    return meta @ if meta

    value = @attributes[@getKey key]
    get = @schema[key]?.get
    return get value if get

    value

  ###*
    @param {string} key
    @return {boolean}
  ###
  has: (key) ->
    return true if @getKey(key) of @attributes
    return true if @schema[key]?['meta']
    false

  ###*
    @param {string} key
    @return {boolean} true if removed
  ###
  remove: (key) ->
    _key = @getKey key
    return false if !(_key of @attributes)
    value = @attributes[_key]
    value.removeParent @ if value instanceof este.Base
    delete @attributes[_key]
    changed = {}
    changed[key] = value
    @dispatchChangeEvent changed
    true

  ###*
    Return a model JSON representation, which can be used for persistence,
    serialization, or model view rendering.
    @param {boolean=} raw If true, _cid, metas, and getters are ignored.
    @return {Object}
  ###
  toJson: (raw) ->
    json = {}
    for $key, value of @attributes
      key = $key.substring 1
      continue if raw && key == '_cid'
      attr = if raw then value else @get key
      if attr?.toJson
        json[key] = attr.toJson raw
      else
        json[key] = attr
    if !raw
      for key, value of @schema
        meta = value?['meta']
        continue if !meta
        json[key] = meta @
    json

  ###*
    @return {Array.<este.validators.Base>}
  ###
  validate: ->
    keys = (key for key, value of @schema when value?['validators'])
    values = (`/** @type {Object} */`) @get keys
    allErrors = @getErrors(values) || []
    for key, value of @attributes
      continue if !value || !goog.isFunction value.validate
      errors = value.validate()
      continue if not errors
      allErrors.push.apply allErrors, errors
    return allErrors if allErrors.length
    null

  ###*
    Prefix because http://www.devthought.com/2012/01/18/an-object-is-not-a-hash
    @param {string} key
    @return {string}
  ###
  getKey: (key) ->
    '$' + key

  ###*
    @return {Object}
    @protected
  ###
  getResolvedDefaults: ->
    return {} if !@defaults
    goog.object.map @defaults, (value, key) ->
      if typeof value == 'function'
        return value()
      value

  ###*
    @param {Object} json
    @param {boolean=} silent
    @return {Array.<este.validators.Base>}
    @protected
  ###
  setInternal: (json, silent) ->
    changes = @getChanges json
    return null if !changes

    if !silent
      errors = @getErrors changes
      return errors if errors

    @setAttributes changes
    if !silent
      @dispatchChangeEvent changes
    null

  ###*
    @param {Object} json
    @protected
  ###
  setAttributes: (json) ->
    idAttributes = @idAttribute.split '.'
    for key, value of json
      $key = @getKey key
      currentValue = @attributes[$key]
      if key == idAttributes[0]
        @setIdAttribute value, currentValue, idAttributes
      if key == '_cid' && currentValue?
        goog.asserts.fail 'Model _cid is immutable.'
      @attributes[$key] = value
      value.addParent @ if value instanceof este.Base
    return

  ###*
    @protected
  ###
  setIdAttribute: (value, currentValue, idAttributes) ->
    if currentValue?
      goog.asserts.fail 'Model id is immutable.'
    if idAttributes.length == 1
      @id = value.toString()
    else
      nestedId = goog.object.getValueByKeys value, idAttributes.slice 1
      @id = nestedId.toString()
    return

  ###*
    @param {Object} json
    @return {Object}
    @protected
  ###
  getChanges: (json) ->
    changes = null
    for key, value of json
      set = @schema[key]?.set
      value = set value if set
      continue if Model.equal value, @get key
      changes ?= {}
      changes[key] = value
    changes
  ###*
    @param {Object} json key is attr, value is its value
    @return {Array.<este.validators.Base>}
    @protected
  ###
  getErrors: (json) ->
    errors = []
    for key, value of json
      validators = @schema[key]?['validators']
      continue if !validators
      for validatorFactory in validators
        validator = validatorFactory()
        validator.model = @
        validator.key = key
        validator.value = value
        continue if not validator.isValidable()
        continue if validator.validate value
        errors.push validator
    return errors if errors.length
    null

  ###*
    @param {Object} changed
    @protected
  ###
  dispatchChangeEvent: (changed) ->
    changeEvent = new este.Model.Event Model.EventType.CHANGE, @
    changeEvent.model = @
    changeEvent.changed = changed
    @dispatchModelEvent changeEvent

  ###*
    @param {este.Model.Event} e
    @protected
  ###
  dispatchModelEvent: (e) ->
    @dispatchEvent e
    updateEvent = new este.Model.Event Model.EventType.UPDATE, @
    updateEvent.origin = e
    @dispatchEvent updateEvent

  ###*
    @param {function(): string=} idGenerator
    @protected
  ###
  ensureClientId: (idGenerator) ->
    return if @get '_cid'
    @set '_cid', if idGenerator
      idGenerator()
    else
      goog.ui.IdGenerator.getInstance().getNextUniqueId()

###*
  @fileoverview este.Model.Event.
###
class este.Model.Event extends goog.events.Event

  ###*
    @param {string} type Event Type.
    @param {goog.events.EventTarget} target
    @constructor
    @extends {goog.events.Event}
  ###
  constructor: (type, target) ->
    super type, target

  ###*
    @type {este.Model}
  ###
  model: null

  ###*
    Changed model attributes.
    @type {Object}
  ###
  changed: null

  ###*
    Added models.
    @type {Array.<este.Model>}
  ###
  added: null

  ###*
    Removed models.
    @type {Array.<este.Model>}
  ###
  removed: null

  ###*
    @type {este.Model.Event}
  ###
  origin: null