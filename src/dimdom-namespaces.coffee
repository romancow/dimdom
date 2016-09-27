(->
	# namespace presets
	@NS =
		HTML: 'http://www.w3.org/1999/xhtml'
		SVG: 'http://www.w3.org/2000/svg'
		MathML: 'http://www.w3.org/1998/Math/MathML'
		XLink: 'http://www.w3.org/1999/xlink'
		XMLNS: 'http://www.w3.org/2000/xmlns/'

	@NSPrefix =
		xlink: @NS.XLink
		xmlns: @NS.XMLNS

	# create subclass for namespace presets
	for abbr in ['HTML', 'SVG', 'MathML']
		ns = @NS[abbr]
		@[abbr] = class extends DimDomItem
			namespace = ns

			constructor: (name, attributes, styles, children) ->
				super([namespace, name], attributes, styles, children)

).call(DimDomNamespaces = {})
