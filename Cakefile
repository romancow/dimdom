{writeFileSync, readFileSync} = require 'fs'
{execSync} = require 'child_process'

libName  = 'dimdom'
srcDir   = './src'
srcFile  = "#{srcDir}/index.coffee"
destFile = "./dist/#{libName}.js"
minFile  = "./dist/#{libName}.min.js"
encoding = 'utf8'

task 'lint', 'Lint project coffeescript', (options) ->
	{prepends} = getPrepends(srcFile)
	lintAcc = (success, file) ->
		success and tryExecSync("coffeelint #{file}")
	[prepends..., srcFile].reduce(lintAcc, true)

task 'build', 'Build project with header', (options) ->
	return unless invoke('lint')
	header = compileSync(getHeader(), stdio: true, bare: true, 'no-header': true)
	console.log(header)
	console.log("processing \"#{srcFile}\"...")
	coffee = expandPrepends(srcFile)
	console.log('compiling...')
	js = compileSync(coffee, stdio: true)
	writeFileSync(destFile, "#{header}\n#{js}")
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
	['build', 'test', 'test:min'].every (name) -> invoke(name)

task 'prepublish', 'Build and test before publishing', ->
	# we want to throw an error if the prepublish fails
	invoke('build:test') or throw new Error('prepublish failed!')

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

getPrepends = (file) ->
	code = readFileSync(file, encoding: encoding)
	prependRegex = new RegExp(/^\s*\#\s*@cake-prepend\s+"([^"]+)"(\s|$)/)
	result =
		prepends: loop
			prepend = null
			code = code.replace prependRegex, (match, path) ->
				prepend = "#{srcDir}/#{path}"
				''
			break unless prepend
			prepend
		code: code

expandPrepends = (file) ->
	{prepends, code} = getPrepends(file)
	prepends = prepends.map (path) ->
		console.log("prepending \"#{path}\"...")
		readFileSync(path, encoding: encoding)
	return [prepends..., code].join('\n')
