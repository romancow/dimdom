isString = (val) ->
	(typeof val is 'string') or (val instanceof String)

isObject = (val) ->
	val? and (typeof val is 'object') and not Array.isArray(val)

ensureArray = (val) ->
	unless val?
		[]
	else if Array.isArray(val)
		val
	else
		[val]

mergeInto = (obj, items...) ->
	for item in items
		for own key, val of item
			obj[key] = val
	return obj
