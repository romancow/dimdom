class DimDom

	constructor: (name, attributes, styles, children) ->
		[namespace, name, attributes, styles, children] =
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
				value: children
	
	create: (document) ->
		fragment = document.createDocumentFragment()
		node = createNode.call(this, document)
		fragment.appendChild(node)
		return fragment

	appendTo: (node) ->
		child = @create(node.ownerDocument)
		node.appendChild(child)
		return this

	# namespace presets
	@NS:
		HTML: 'http://www.w3.org/1999/xhtml'
		SVG: 'http://www.w3.org/2000/svg'
		MathML: 'http://www.w3.org/1998/Math/MathML'

	# private methods

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

	createNode = (document) ->
		node =
			if @namespace?
				document.createElementNS(@namespace, @name)
			else
				document.createElement(@name)
		for own name, value of @attributes when value?
			node.setAttribute(name, value)
		for own name, value of @styles when value?
			node.style[name] = value
		childrenNodes = getChildrenNodes.call(this, document)
		for childNode in childrenNodes when childNode?
			node.appendChild(childNode)
		return node

	getChildrenNodes = (document) ->
		for child in @children
			if child instanceof DimDom
				createNode.call(child, document)
			else if child not instanceof Node
				document.createTextNode(child)
			else
				child

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

	# create a subclass for each namespace preset
	for abbr, ns of @NS
		@[abbr] = class extends DimDom
			namespace = ns

			constructor: (name, attributes, styles, children) ->
				super([namespace, name], attributes, styles, children)


if module?.exports?
	module.exports = DimDom
else
	@DimDom = DimDom
