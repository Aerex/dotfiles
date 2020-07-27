#! /usr/bin/env python
# Credits CountZukula https://bbs.archlinux.org/viewtopic.php?pid=1784316#p1784316

import colortrans
import json
import os

home = os.environ['HOME']
 
# open the current config.json and potentially overwrite the right values
colorjsonfile = '{}/.config/powerline/colors.json'.format(home)
with open(colorjsonfile) as pywaljsonfile:	
	pywaljson = json.load(pywaljsonfile)

# read the pywal cache file
pywalcolors = open('{}/.cache/wal/colors'.format(home), "r")
i = 0
for row in pywalcolors:
	# clean up the color
	colorstring = row.strip()
	# remove the hashtag
	colorstring = colorstring.lstrip('#')
	# convert it to short
	colorshort = colortrans.rgb2short(colorstring)[0]
	# print the color
	print(colorshort)
	# overwrite the setting in the json file
	colorname = 'pywal'+str(i)
	pywaljson['colors'][colorname] = int(colorshort)
	i = i+1

# write the json object back to the file
with open(colorjsonfile, 'w') as outfile:
	json.dump(pywaljson, outfile)
