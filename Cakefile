{writeFileSync} = require 'fs'
{exec, execSync} = require 'child_process'

libName = 'dimdom'

task 'build', 'Build project with header', (options) ->
	header = compileSync(getHeader(), stdio: true, bare: true, 'no-header': true)
	console.log(header)
	code = compileSync("./src/#{libName}.coffee")
	writeFileSync("./dist/#{libName}.js", "#{header}\n#{code}")
	console.log('\nbuild successful')

getHeader = ->
	info = require('./package.json')
	{version, homepage, copyright, license, licenseUrl} = info
	year = new Date().getUTCFullYear()
	date = new Date().toISOString().replace(/:\d{2}\.\d+Z$/, 'Z')
	"""
	###
	DimDom JavaScript Library v#{version}
	#{homepage}

	Copyright #{year} #{copyright}
	Released under the #{license} license
	#{licenseUrl}

	Date: #{date}
	###
	"""

compileSync = (data, options = {}) ->
	opts = for option, val of options when val
		"--#{option}" + (if val is true then '' else " #{val}")
	cmd = 'coffee -c ' + opts.join(' ')
	result =
		if options.stdio
			execSync(cmd, {input: data})
		else
			execSync("#{cmd} --print #{data}")
	result.toString()
