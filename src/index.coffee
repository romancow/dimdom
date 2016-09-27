# @cake-prepend "utilities.coffee"
# @cake-prepend "dimdom.coffee"
# @cake-prepend "dimdom-item.coffee"
# @cake-prepend "dimdom-collection.coffee"

DimDomItem.Collection = DimDomCollection

if module?.exports?
	module.exports = DimDomItem
else
	@DimDom = DimDomItem
