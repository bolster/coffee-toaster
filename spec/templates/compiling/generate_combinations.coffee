fs = require 'fs'
path = require 'path'
exec = (require 'child_process').exec

{FsUtil} = (require __dirname + "/../../../lib/toaster").toaster.utils

binary_map = ( n, b = "", c = [])->
	(binary_map n, "#{b}0", c) and (binary_map n, "#{b}1", c) if n-- > 1
	c.splice c.length, 0, "#{b}0", "#{b}1" if n == 0
	c

template = """
toast 'src'
	exclude: ~EXCLUDE
	vendors: ~VENDORS
	bare: ~BARE
	packaging: ~PACKAGING
	expose: ~EXPOSE
	minify: ~MINIFY

	httpfolder: ''
	release: 'www/app.js'
	debug: 'www/app-debug.js'
"""

map = 
	packaging: [true, false]
	minify: [true, false]
	bare: [true, false]
	expose: ["'window'", null]
	exclude: ["['misc', 'utils']", null]
	vendors: ["['vendors/vendor_a.js', 'vendors/vendor_b.js']", null]

labels = Object.keys map
combos = binary_map labels.length

for combo in combos
	config = template
	props = ""
	for label, i in labels
		value = map[label][combo[i]]
		key = "~#{label.toUpperCase()}"
		config = config.replace key, value
		props += "#{label}: #{value}, "


	FsUtil.rmdir_rf "combos/#{combo}" if (path.existsSync "combos/#{combo}")
	fs.mkdirSync "combos/#{combo}"

	FsUtil.cp_dir "simple-app/src", "combos/#{combo}/src"
	FsUtil.cp_dir "simple-app/vendors", "combos/#{combo}/vendors"
	FsUtil.cp_dir "simple-app/www", "combos/#{combo}/www"
	fs.writeFileSync "combos/#{combo}/toaster.coffee", config

	console.log "CREATED " + props.slice 0, -2
	break

compile_all = (i = 0)->
	combo = combos[i]
	cmd = "toaster -c combos/#{combo}"

	exec cmd, (a, b, c)->
		throw error if error?
		console.log "COMPILED combos/#{combo}"
		# compile_all i if ++i < combos.length

compile_all()