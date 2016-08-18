given = (name, fn) ->
	beforeEach "given #{name}", ->
		[cache, isCached] = [null, false]
		Object.defineProperty @, name,
			configurable: true,
			get: ->
				unless isCached
					isCached = true
					cache = fn.call(@)
				return cache
			set: (val) ->
				isCached = true
				cache = val
	afterEach ->
		delete @subject

subject = (fn) -> given('subject', fn)

describe 'DimDom', ->

	given 'name', -> 'div'
	given 'attributes', ->  { class: 'test', id: '1' }
	given 'styles', -> { color: 'black', margin: 0 }
	given 'child', -> new DimDom('p', 'Testing...')
	given 'children', -> [
		new DimDom('h1', 'The Header')
		@child
	]

	constructorContexts =
		'with just name': ->
			subject -> new DimDom(@name)

		'with attributes': ->
			subject -> new DimDom(@name, @attributes)

		'with styles': ->
			subject -> new DimDom(@name, {}, @styles)

		'with styles in attributes': ->
			subject -> new DimDom(@name, styles: @styles)

		'with a child': ->
			subject -> new DimDom(@name, @child)

		'with children': ->
			subject -> new DimDom(@name, @children)

		'with all properties': ->
			subject -> new DimDom(@name, @attributes, @styles, @children)

	filterContexts = (contexts, descriptions...) ->
		newContexts = {}
		includes = (desc) -> 
			descriptions.some (description) -> description is desc
		for desc, fn of contexts when includes(desc)
			newContexts[desc] = fn
		newContexts

	forAllContexts = (contexts, spec) ->
		for desc, fn of contexts
			context desc, ->
				fn.call(@)
				spec.call(@)

	describe '#constructor', ->

		forAllContexts constructorContexts, ->
			it 'creates a DimDom', ->
				expect(@subject).to.be.an.instanceof(DimDom)
		
	describe '#name', ->

		forAllContexts constructorContexts, ->
			it 'is set', ->
				expect(@subject).to.have.property('name')
					.that.equals('div')

	describe '#attributes', ->
		setContexts = filterContexts constructorContexts,
			'with attributes'
			'with all properties'
		emptyContexts = filterContexts constructorContexts,
			'with just name'
			'with styles'
			'with styles in attributes'
			'with a child'
			'with children'

		forAllContexts setContexts, ->
			it 'is set', ->
				expect(@subject).to.have.property('attributes')
					.that.deep.equals({ class: 'test', id: '1' })

		forAllContexts emptyContexts, ->
			it 'is empty', ->
				expect(@subject).to.have.property('attributes')
					.that.is.empty

	describe '#styles', ->
		setContexts = filterContexts constructorContexts,
			'with styles'
			'with styles in attributes'
			'with all properties'
		emptyContexts = filterContexts constructorContexts,
			'with just name'
			'with attributes'
			'with a child'
			'with children'

		forAllContexts setContexts, ->
			it 'is set', ->
				expect(@subject).to.have.property('styles')
					.that.deep.equals({ color: 'black', margin: 0 })

		forAllContexts emptyContexts, ->
			it 'is empty', ->
				expect(@subject).to.have.property('styles')
					.that.is.empty

	describe '#children', ->
		childContexts = filterContexts constructorContexts,
			'with a child'
		childrenContexts = filterContexts constructorContexts,
			'with children'
			'with all properties'
		emptyContexts = filterContexts constructorContexts,
			'with just name'
			'with attributes'
			'with styles'
			'with styles in attributes'

		forAllContexts childContexts, ->
			it 'is set with child', ->
				expect(@subject).to.have.property('children')
					.that.deep.equals([new DimDom('p', 'Testing...')])

		forAllContexts childrenContexts, ->
			it 'is set with children', ->
				expect(@subject).to.have.property('children')
					.that.deep.equals([new DimDom('h1', 'The Header'), new DimDom('p', 'Testing...')])

		forAllContexts emptyContexts, ->
			it 'is empty', ->
				expect(@subject).to.have.property('children')
					.that.is.empty

	describe '#create'

	describe '#appendTo'

		
