# # ==================================================================== INITIAL
# binary = ( n, b = "", c = [])->
# 	if n-- > 1
# 		binary n, "#{b}0", c
# 		binary n, "#{b}1", c
# 	else
# 		c.push "#{b}0"
# 		c.push "#{b}1"
# 	c

# algo = ( list, disable )->
# 	for combo, i in (combos = binary list.length)
# 		buffer = ""
# 		for char, j in combo
# 			buffer += if char is '0' then disable else list[j]
# 		combos[i] = buffer
# 	combos

# start = (new Date).getTime()
# (algo ('abcdefghijklmno'.split ''), "-").join '\n'
# console.log "\t--> Duration: #{(new Date).getTime() - start}ms"


# # ==================================================================== REDUCED
# binary = ( n, b = "", c = [])->
# 	(binary n, "#{b}0", c) and (binary n, "#{b}1", c) if n-- > 1
# 	c.splice c.length, 0, "#{b}0", "#{b}1" if n == 0
# 	c

# algo = ( opts, char )->
# 	for cb, i in (cbs = binary opts.length)
# 		b = ""
# 		(b += if ch is '0' then char else opts[j]) for ch, j in cb
# 		cbs[i] = b
# 	cbs

# start = (new Date).getTime()
# (algo ('abcdefghijklmno'.split ''), "-").join '\n'
# console.log "\t--> Duration: #{(new Date).getTime() - start}ms"


# ==================================================================== MERGED
algo = ( opts, char, n = 0, b = "", co = [] )->
	a = algo; c = char; o = opts;
	if (++n < o.length) then (a o, c, n, b+o[n-1], co) && (a o, c, n, b+c, co) 
	else (co.splice co.length, 0, b+o[n-1], b+char); co

start = (new Date).getTime()
res = (algo ('abcde'.split ''), "-").join '\n'
ms = (new Date).getTime() - start
console.log res
console.log "\t--> Duration: #{ms}ms"



# ==================================================================== EXPLAINED
# algo = ( opts, char, step = 0, buffer = "", combos = [] )->
# 	if ++step < o.length
# 		algo opts, char, step, buffer + options[step-1], combos
# 		algo opts, char, step, buffer + char, combos
# 	else
# 		co.push b+o[n-1] # filled
# 		co.push b+char) # empty
# 		return co