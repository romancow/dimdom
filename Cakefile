{writeFileSync} = require 'fs'
{execSync} = require 'child_process'

libName  = 'dimdom'
srcFile  = "./src/#{libName}.coffee"
destFile = "./dist/#{libName}.js"
minFile  = "./dist/#{libName}.min.js"

task 'lint', 'Lint project coffeescript', (options) ->
	tryExecSync("coffeelint #{srcFile}")

task 'build', 'Build project with header', (options) ->
	return unless invoke('lint')
	header = compileSync(getHeader(), stdio: true, bare: true, 'no-header': true)
	console.log(header)
	code = compileSync(srcFile)
	writeFileSync(destFile, "#{header}\n#{code}")
	console.log('minifying...')
	success = invoke('minify')
	console.log(if success then '\nbuild successful' else 'minification failed!')
	success

task 'minify', 'Create minified version of the current build', (options) ->
	tryExecSync "uglifyjs #{destFile}",
		compress: true
		comments: true
		output: minFile
		lint: true

task 'test', 'Run tests on project coffeescript', (options) ->
	tryExecSync('karma start')

task 'test:min', 'Run tests on project\'s minified javascript', (options) ->
	tryExecSync('karma start karma-min.conf.coffee')

task 'build:test', 'Build the project and run tests on source and minified js', (options) ->
	invoke('build') and
	invoke('test')  and
	invoke('test:min')

getHeader = ->
	info = require('./package.json')
	{version, homepage, copyright, license, licenseUrl} = info
	year = new Date().getUTCFullYear()
	date = new Date().toISOString().replace(/:\d{2}\.\d+Z$/, 'Z')
	"""
	###*
	# @license
	# DimDom JavaScript Library v#{version}
	# #{homepage}
	#
	# Copyright #{year} #{copyright}
	# Released under the #{license} license
	# #{licenseUrl}
	#
	# Date: #{date}
	###
	"""

compileSync = (data, options = {}) ->
	cmd = "coffee -c #{joinOptions(options)}"
	result =
		if options.stdio
			execSync(cmd, {input: data})
		else
			execSync("#{cmd} --print #{data}")
	result.toString()

joinOptions = (options = {}) ->
	opts = for opt, val of options when val
		"--#{opt}" + (if val is true then '' else " #{val}")
	opts.join(' ')

tryExecSync = (cmd, options) ->
	error = null
	cmd += " #{joinOptions(options)}" if options?
	try
		execSync(cmd, stdio: 'inherit')
	catch error
		console.log(error.message)
	not error
