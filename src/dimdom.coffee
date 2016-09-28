class DimDom

	constructor: (getNodes = (-> [])) ->
		@_getNodes = getNodes

	create: (document) ->
		fragment = document.createDocumentFragment()
		nodes = ensureArray(@_getNodes.call(this, document))
		fragment.appendChild(node) for node in nodes
		return fragment

	appendTo: (node) ->
		fragment = @create(node.ownerDocument)
		node.appendChild(fragment)
		return this
