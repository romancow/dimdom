# Karma configuration
module.exports = (config) -> config.set

	# base path that will be used to resolve all patterns (eg. files, exclude)
	basePath: ''


	# frameworks to use
	# available frameworks: https://npmjs.org/browse/keyword/karma-adapter
	frameworks: ['mocha', 'chai']


	# list of files / patterns to load in the browser
	files: [
		'src/utilities.coffee'
		'src/dimdom.coffee'
		'src/dimdom-item.coffee'
		'src/dimdom-namespaces.coffee'
		'src/dimdom-collection.coffee'
		'src/index.coffee'
		'test/**/*helpers.coffee'
		'test/*.test.coffee'
	]


	# list of files to exclude
	exclude: []


	# preprocess matching files before serving them to the browser
	# available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
	preprocessors:
		'**/*.coffee': ['coffee']


	# test results reporter to use
	# possible values: 'dots', 'progress'
	# available reporters: https://npmjs.org/browse/keyword/karma-reporter
	reporters: ['progress']


	# web server port
	port: 9876


	# enable / disable colors in the output (reporters and logs)
	colors: true


	# level of logging
	# possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
	logLevel: config.LOG_INFO


	# enable / disable watching file and executing tests whenever any file changes
	autoWatch: false


	# start these browsers
	# available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
	browsers: ['PhantomJS']


	# Continuous Integration mode
	# if true, Karma captures browsers, runs the tests and exits
	singleRun: true

	# Concurrency level
	# how many browser should be started simultaneous
	concurrency: Infinity
