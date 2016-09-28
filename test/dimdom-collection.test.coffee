describe 'DimDomCollection', ->

	given 'ddItem', -> new DimDom('div', 'some inner text')
	given 'strItem', -> 'some inner text'
	given 'nodeItem', ->
		node = document.createElement('div')
		textNode = document.createTextNode('some inner text')
		node.appendChild(textNode)
		return node

	subject -> new DimDom.Collection(@param)

	constructorContexts =
		'with no arguments': ->
			subject -> new DimDom.Collection()

		'with an empty array': ->
			given 'param', -> []

		'with a DimDomItem': ->
			given 'param', -> @ddItem
			given 'nodeType', -> Node.ELEMENT_NODE

		'with a string': ->
			given 'param', -> @strItem
			given 'nodeType', -> Node.TEXT_NODE

		'with a Node': ->
			given 'param', -> @nodeItem
			given 'nodeType', -> Node.ELEMENT_NODE

		'with all item types': ->
			given 'param', -> [@ddItem, @strItem, @nodeItem]

	emptyContexts = filterContexts constructorContexts,
		'with no arguments'
		'with an empty array'

	singleItemContexts = filterContexts constructorContexts,
		'with a DimDomItem'
		'with a string'
		'with a Node'

	multiItemContexts = filterContexts constructorContexts,
		'with all item types'

	describe '#constructor', ->

		forAllContexts constructorContexts, ->
			it 'creates a DimDom collection', ->
				expect(@subject).to.be.an.instanceof(DimDom.Collection)

	describe '#items', ->
		
		forAllContexts emptyContexts, ->
			it 'is empty', ->
				expect(@subject).to.have.property('items')
					.that.is.an('array').and.empty

		forAllContexts singleItemContexts, ->
			it 'has a single item', ->
				expect(@subject).to.have.property('items')
					.that.deep.equals([@param])
					.and.to.have.lengthOf(1)

		forAllContexts multiItemContexts, ->
			it 'has items', ->
				expect(@subject).to.have.property('items')
					.that.deep.equals([@ddItem, @strItem, @nodeItem])
					.and.to.have.lengthOf(3)

	describe '#create', ->
		given 'result', -> @subject.create(document)
		given 'child', -> @result.firstChild

		forAllContexts constructorContexts, ->
			it 'is a DocumentFragment', ->
				expect(@result).to.be.instanceof(DocumentFragment)

		forAllContexts emptyContexts, ->
			it 'has no children', ->
				expect(@result.childNodes).to.have.lengthOf(0)

		forAllContexts singleItemContexts, ->
			it 'has one child', ->
				expect(@result.childNodes).to.have.lengthOf(1)

			it 'is expected node type', ->
				expect(@child).to.have.property('nodeType', @nodeType)

			it 'has text', ->
				expect(@child).to.have.property('textContent', 'some inner text')

		forAllContexts multiItemContexts, ->
			it 'has children', ->
				expect(@result.childNodes).to.have.lengthOf(3)

			it 'has correct node types', ->
				nodeTypes = (child.nodeType for child in @result.childNodes)
				expect(nodeTypes).to.deep.equals([
					Node.ELEMENT_NODE
					Node.TEXT_NODE
					Node.ELEMENT_NODE
				])

			it 'has text', ->
				expect(@result.childNodes).to.all.have.property('textContent', 'some inner text')
		
	describe '#appendTo', ->
		given 'appendContainer', -> document.body.appendChild(document.createElement('div'))

		forAllContexts multiItemContexts, ->
			beforeEach -> @result = @subject.appendTo(@appendContainer)

			it 'returns self', ->
				expect(@result).to.equal(@subject)

			it 'appends', ->
				expect(@appendContainer.childNodes).to.have.lengthOf(3)
					.and.to.all.have.property('textContent', 'some inner text')
