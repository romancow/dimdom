class DimDomItem extends DimDom

	constructor: (name, attributes, styles, children) ->
		super(@toNode)
		[namespace, name, attributes, styles, @_children] =
			findConstructorArgs(name, attributes, styles, children)
		Object.defineProperties this,
			namespace:
				value: namespace
			name:
				value: name
			attributes:
				value: attributes
			styles:
				value: styles
			children:
				value: @_children.items

	toNode: (document) ->
		node =
			if @namespace?
				document.createElementNS(@namespace, @name)
			else
				document.createElement(@name)
		for own name, value of @attributes when value?
			[prefix, hasPrefix] = name.split(':', 2)
			if hasPrefix?
				ns = DimDom.NSPrefix[prefix] ? ''
				node.setAttributeNS(ns, name, value)
			else
				node.setAttribute(name, value)
		for own name, value of @styles when value?
			node.style[name] = value
		childrenNodes = @_children.toNodes(document)
		for childNode in childrenNodes when childNode?
			node.appendChild(childNode)
		return node

	# private methods

	findConstructorArgs = (name, attributes = {}, styles, children = []) ->
		[namespace, name] = name if Array.isArray(name)

		if not isString(name)
			throw new TypeError("DimDom name must be a string, not \"#{typeof name}\"")
		if namespace? and not isString(namespace)
			throw new TypeError("DimDom namespace must be a string, not \"#{typeof namespace}\"")

		if isChildren(attributes)
			[attributes, children] = [{}, attributes]
		else if isChildren(styles)
			[styles, children] = [null, styles]

		unless styles?
			styles = attributes['styles'] ? {}
			delete attributes['styles']

		if children not instanceof DimDomCollection
			children = new DimDomCollection(children)
			
		[namespace, name, attributes, styles, children]

	isChildren = (val) ->
		val? and (
			(val instanceof DimDom) or
			(val instanceof Node) or
			(val instanceof DimDomCollection) or
			not isObject(val)
		)
