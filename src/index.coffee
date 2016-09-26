# @cake-prepend "utilities.coffee"
# @cake-prepend "dimdom.coffee"

if module?.exports?
	module.exports = DimDom
else
	@DimDom = DimDom
