describe 'DimDom', ->

	given 'name', -> 'div'
	given 'namespace', -> DimDom.NS.HTML
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

		'with namespace': ->
			subject -> new DimDom([@namespace, @name])

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
			subject -> new DimDom([@namespace, @name], @attributes, @styles, @children)

	describe '#constructor', ->

		forAllContexts constructorContexts, ->
			it 'creates a DimDom', ->
				expect(@subject).to.be.an.instanceof(DimDom)
		
	describe '#name', ->

		forAllContexts constructorContexts, ->
			it 'is set', ->
				expect(@subject).to.have.property('name', 'div')

	describe '#namespace', ->
		setContexts = filterContexts constructorContexts,
			'with namespace'
			'with all properties'
		emptyContexts = filterContexts constructorContexts,
			'with just name'
			'with attributes'
			'with styles'
			'with styles in attributes'
			'with a child'
			'with children'

		forAllContexts setContexts, ->
			it 'is set', ->
				expect(@subject).to.have.property('namespace', DimDom.NS.HTML)

		forAllContexts emptyContexts, ->
			it 'is non-existent', ->
				expect(@subject).to.have.property('namespace').and.not.exist

	describe '#attributes', ->
		setContexts = filterContexts constructorContexts,
			'with attributes'
			'with all properties'
		emptyContexts = filterContexts constructorContexts,
			'with just name'
			'with namespace'
			'with styles'
			'with styles in attributes'
			'with a child'
			'with children'

		forAllContexts setContexts, ->
			it 'is set', ->
				expect(@subject).to.have.deep.property('attributes')
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
			'with namespace'
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
			'with namespace'
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

	describe '#create', ->
		basicContext = filterContexts constructorContexts,
			'with just name'
		complexContext = filterContexts constructorContexts,
			'with all properties'
		basicAndComplexContexts = filterContexts constructorContexts,
			'with just name'
			'with all properties'

		given 'result', -> @subject.create(document)

		forAllContexts basicAndComplexContexts, ->
			it 'is a HTMLDivElement', ->
				expect(@result).to.be.instanceof(HTMLDivElement)

			it 'is a div', ->
				expect(@result.tagName).to.equal('DIV')

		forAllContexts basicContext, ->
			it 'has no attributes', ->
				expect(@result.hasAttributes()).to.be.false

			it 'has no styles', ->
				expect(@result.style).to.have.lengthOf(0)

			it 'has no children', ->
				expect(@result.hasChildNodes()).to.be.false

		forAllContexts complexContext, ->
			it 'has attributes', ->
				expect(@result.attributes).to.satisfy (attrs) ->
					attrs.getNamedItem('class')?.value is 'test' and 
					attrs.getNamedItem('id')?.value is '1'

			it 'has styles', ->
				expect(@result.style).to.have.property('color', 'black')
				expect(@result.style).to.have.property('margin', '0px')

			it 'has children', ->
				expect(@result.children).to.satisfy ([h1, p]) ->
					(h1.tagName is 'H1') and (h1.innerHTML is 'The Header') and 
					(p.tagName is 'P') and (p.innerHTML is 'Testing...')
	
		context 'with SVG namespace', ->
			subject -> new DimDom([DimDom.NS.SVG, 'svg'], width:100, height:100)

			it 'is a SVGSVGElement', ->
				expect(@result).to.be.instanceof(SVGSVGElement)

	describe '#appendTo', ->
		given 'result', -> @subject.appendTo(document.body)
		myContext = filterContexts constructorContexts,
			'with all properties'

		forAllContexts myContext, ->
			it 'resturns self', ->
				expect(@result).to.equal(@subject)

			it 'appends', ->
				element = document.getElementById('1')
				expect(element).to.exist.and.to.have.property('tagName', 'DIV')