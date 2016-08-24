# Karma minified configuration
module.exports = (config) ->
	require('./karma.conf.coffee')(config)
	config.set

		# list of files / patterns to load in the browser
		files: [
			'dist/*.min.js'
			'test/**/*helpers.coffee'
			'test/*.test.coffee'
		]
