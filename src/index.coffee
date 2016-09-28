# @cake-prepend "utilities.coffee"
# @cake-prepend "dimdom.coffee"
# @cake-prepend "dimdom-item.coffee"
# @cake-prepend "dimdom-namespaces.coffee"
# @cake-prepend "dimdom-collection.coffee"

exports = mergeInto(DimDomItem, DimDomNamespaces, Collection: DimDomCollection)
if module?.exports?
	module.exports = exports
else
	@DimDom = exports
