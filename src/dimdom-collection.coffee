class DimDomCollection extends DimDom

	constructor: (items) ->
		super(@toNodes)
		Object.defineProperties this,
			items:
				value: ensureArray(items)
	
	toNodes: (document) ->
		for item in @items
			if item instanceof DimDomItem
				item.toNode(document)
			else if item not instanceof Node
				document.createTextNode(item)
			else
				item
