#!/usr/bin/python

# import modules
import os
import sys
import json


if len(sys.argv) < 3:
	print('Usage: '+sys.argv[0]+' <in_json> <key name> <convert sec to ms (default: 0)>')
	exit(1)
 

in_file=sys.argv[1]
key=sys.argv[2]

do_sec_to_ms=0

if len(sys.argv) >3:
	do_sec_to_ms=int(sys.argv[3])




with open(in_file) as data_file:
	data = json.load(data_file)
	val=data[key]
	if do_sec_to_ms == 1:
		val=val*1000
	print(val)


