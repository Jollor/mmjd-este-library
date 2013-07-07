suite 'este.react.create', ->

  improve = este.react.improve

  context = null
  props = null
  children = null

  setup ->
    context = {}
    props = {}
    children = []

  suite 'este.react.improve', ->
    test 'should work without args', (done) ->
      factory = (p_props, p_children) ->
        assert.lengthOf arguments, 0
        assert.equal @, context
        done()
      improvedFactory = improve factory
      improvedFactory.call context

    test 'should work with props', (done) ->
      factory = (p_props, p_children) ->
        assert.lengthOf arguments, 1
        assert.deepEqual p_props, props
        assert.equal @, context
        done()
      improvedFactory = improve factory
      improvedFactory.call context, props

    test 'should work with props and children', (done) ->
      factory = (p_props, p_children) ->
        assert.lengthOf arguments, 2
        assert.deepEqual p_props, props
        assert.deepEqual p_children, children
        assert.equal @, context
        done()
      improvedFactory = improve factory
      improvedFactory.call context, props, children

    suite 'should allow to omit props and pass children instead', ->
      test 'for array', (done) ->
        factory = (p_props, p_children) ->
          assert.lengthOf arguments, 2
          assert.isNull p_props
          assert.deepEqual p_children, children
          assert.equal @, context
          done()
        improvedFactory = improve factory
        improvedFactory.call context, children

      test 'for string', (done) ->
        factory = (p_props, p_children) ->
          assert.lengthOf arguments, 2
          assert.isNull p_props
          assert.equal p_children, 'Text'
          assert.equal @, context
          done()
        improvedFactory = improve factory
        improvedFactory.call context, 'Text'

      test 'for instance', (done) ->
        instance = new Function
        factory = (p_props, p_children) ->
          assert.lengthOf arguments, 2
          assert.isNull p_props
          assert.equal p_children, instance
          assert.equal @, context
          done()
        improvedFactory = improve factory
        improvedFactory.call context, instance

    suite 'should autobind handlers', ->
      test 'for props', (done) ->
        handler = ->
          assert.equal @, context
          done()
        factory = (p_props, p_children) ->
          p_props.onClick()
        improvedFactory = improve factory
        improvedFactory.call context,
          onClick: handler

      test 'for props and children', (done) ->
        handler = ->
          assert.equal @, context
          done()
        factory = (p_props, p_children) ->
          p_props.onClick()
        improvedFactory = improve factory
        improvedFactory.call context,
          onClick: handler
        , children

    suite 'should filter children non existent items', ->
      test 'for children', (done) ->
        factory = (p_props, p_children) ->
          assert.lengthOf p_children, 1
          done()
        improvedFactory = improve factory
        improvedFactory.call context, [null, undefined, '']

      test 'for props and children', (done) ->
        factory = (p_props, p_children) ->
          assert.lengthOf p_children, 1
          done()
        improvedFactory = improve factory
        improvedFactory.call context, props, [null, undefined, '']
