describe 'DimDomNamespaces', ->

	describe 'namespace sub-class', ->
		namespaceContexts =
			'HTML': ->
				given 'namespace', -> DimDom.NS.HTML
				subject -> new DimDom.HTML('div')
			'SVG': ->
				given 'namespace', -> DimDom.NS.SVG
				subject -> new DimDom.SVG('image', 'xlink:href': 'sample.png')
			'MathML': ->
				given 'namespace', -> DimDom.NS.MathML
				subject -> new DimDom.MathML('mn')

		forAllContexts namespaceContexts, ->
			describe '#constructor', ->
				it 'creates a DimDom', ->
					expect(@subject).to.be.an.instanceof(DimDom)

				it 'sets namespace', ->
					expect(@subject).to.have.property('namespace')
						.that.equals(@namespace)
