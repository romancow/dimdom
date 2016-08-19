class DimDom

	constructor: (name, attributes, styles, children) ->
		[namespace, name, attributes, styles, children] = 
			findConstructorArgs(name, attributes, styles, children)
		Object.defineProperties @,
			namespace:
				value: namespace
			name:
				value: name
			attributes:
				value: attributes
			styles:
				value: styles
			children:
				value: children
	
	create: (document) ->
		node = 
			if @namespace?
				document.createElementNS(@namespace, @name)
			else
				document.createElement(@name)
		for own name, value of @attributes when value?
			node.setAttribute(name, value)
		for own name, value of @styles when value?
			node.style[name] = value
		for child in @children
			if child instanceof DimDom
				child.appendTo(node)
			else 
				child = document.createTextNode(child) unless child instanceof Node
				node.appendChild(child)
		return node

	appendTo:  (node) ->
		child = @create(node.ownerDocument)
		node.appendChild(child)
		return @

	findConstructorArgs = (name, attributes, styles, children) ->
		[namespace, name] = name if Array.isArray(name)

		if not isString(name)
			throw new TypeError("DimDom name must be a string, not \"#{typeof name}\"")
		if namespace? and not isString(namespace)
			throw new TypeError("DimDom namespace must be a string, not \"#{typeof namespace}\"")

		if isChildren(attributes)
			[attributes, styles, children] = [{}, {}, attributes]
		else if isChildren(styles)			
			[styles, children] = [attributes['styles'] ? {}, styles]
			delete attributes['styles']

		children = ensureArray(children)
			
		[namespace, name, attributes, styles, children]

	isString = (val) ->
		(typeof val is 'string') or (val instanceof String)

	isObject = (val) ->
		val? and (typeof val is 'object') and not Array.isArray(val)

	isChildren = (val) ->
		(val instanceof DimDom) or (val instanceof Node) or not isObject(val)

	ensureArray = (val) ->
		unless val?
			[]
		else if Array.isArray(val)
			val 
		else
			[val]

	# namespace presets
	@NS =
		HTML: 'http://www.w3.org/1999/xhtml'
		SVG: 'http://www.w3.org/2000/svg'
		MathML: 'http://www.w3.org/1998/Math/MathML'


