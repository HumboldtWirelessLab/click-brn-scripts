#!/usr/bin/python3

import xml.etree.ElementTree as Et
import sys
import csv
from optparse import OptionParser


optParser = OptionParser()
optParser.add_option("-f", "--file", dest="raw_links_path", type="string", help="Path to unfiltered Links XML file")
optParser.add_option("-e", "--metric_etx_limit", type="float", dest="etx_metric_limit", help="ETX-metric limit for accepted links")
(options, args) = optParser.parse_args()

if not options.raw_links_path or not options.etx_metric_limit:
	print("Failed: Missing input measurement file")
	optParser.print_help()
	sys.exit(-1)


used_content = list()
num_filtered = 0
num_used     = 0
header 		 = str()
with open(options.raw_links_path, 'r') as f:
	reader = csv.reader(f, delimiter=',', quoting=csv.QUOTE_ALL)
	
	header = next(reader)
	
	for row in reader:
		etx_value = float(row[2])
		if etx_value <= options.etx_metric_limit:
			used_content.append(row)
			num_used = num_used + 1
		else:
			num_filtered = num_filtered + 1

for e in header:
	sys.stdout.write("\"" + e + "\",")
sys.stdout.write("\n")

for line in used_content:
	sys.stdout.write(','.join(line) + '\n')

sys.stderr.write("Links used:" + str(num_used) + " filtered:" + str(num_filtered) + " ETX-threshold:" + str(options.etx_metric_limit) + "\n")