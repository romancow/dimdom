given = (name, fn) ->
	beforeEach "given #{name}", ->
		[cache, isCached] = [null, false]
		Object.defineProperty @, name,
			configurable: true,
			get: ->
				unless isCached
					isCached = true
					cache = fn.call(@)
				return cache
			set: (val) ->
				isCached = true
				cache = val
	afterEach ->
		delete @subject

subject = (fn) -> given('subject', fn)

filterContexts = (contexts, descriptions...) ->
    newContexts = {}
    includes = (desc) -> 
        descriptions.some (description) -> description is desc
    for desc, fn of contexts when includes(desc)
        newContexts[desc] = fn
    newContexts

forAllContexts = (contexts, spec) ->
    for desc, fn of contexts
        context desc, ->
            fn.call(@)
            spec.call(@)
