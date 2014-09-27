#!/usr/bin/python3

import xml.etree.ElementTree as Et
import sys
from optparse import OptionParser


optParser = OptionParser()
optParser.add_option("-f", "--file", dest="measurement_file", type="string", help="Measurement XML file")
(options, args) = optParser.parse_args()

if not options.measurement_file:
	print("Failed: Missing input measurement file")
	optParser.print_help()
	sys.exit(-1)
measurement_file = options.measurement_file

context = Et.iterparse(measurement_file, events=('start','end'))

extracted_root = Et.Element("simpleflow")

inside_of_link_stat = False
for event, elem in context:
	if elem.tag == 'DibadawnLinkStat' and event == 'start':
		inside_of_link_stat = True
		continue
	elif elem.tag == 'DibadawnLinkStat' and event == 'end':
		extracted_root.append(elem)
		inside_of_link_stat = False
		continue
	
	if not inside_of_link_stat:
		elem.clear()

print(Et.tostring(extracted_root))

del context
