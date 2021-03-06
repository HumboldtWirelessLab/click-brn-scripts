#!/usr/bin/python3


import xml.etree.ElementTree as Et
import sys
from optparse import OptionParser


optParser = OptionParser()
optParser.add_option("-s", "--search", dest="search_id", type="string", help="Search ID to extract")
optParser.add_option("-f", "--file", dest="measurement_file", type="string", help="Measurement XML file")
(options, args) = optParser.parse_args()

if not options.search_id:
    print("Failed: Missing search ID")
    optParser.print_help()
    sys.exit(-1)
search_id = options.search_id

if not options.measurement_file:
    print("Failed: Missing input measurement file")
    optParser.print_help()
    sys.exit(-1)
measurement_file = options.measurement_file

context = Et.iterparse(measurement_file, events=('start',))

print("<simpleflow>")
for event, elem in context:
    if elem.tag == 'DibadawnStartSearch' and elem.get("searchId") == search_id:
        sys.stdout.write("  " + Et.tostring(elem).decode('utf-8'))
    elif elem.tag == 'CrossEdgeDetected' and elem.get("searchId") == search_id:
        sys.stdout.write("  " + Et.tostring(elem).decode('utf-8'))
    elif elem.tag == 'SearchTree' and elem.get("searchId") == search_id:
        sys.stdout.write("  " + Et.tostring(elem).decode('utf-8'))
    elif elem.tag == 'Bridge' and elem.get("searchId") == search_id:
        sys.stdout.write("  " + Et.tostring(elem).decode('utf-8'))
    elif elem.tag == 'topology_info' and elem.get("extra_data") == search_id:
        sys.stdout.write("  " + Et.tostring(elem).decode('utf-8'))
    elem.clear()
print("</simpleflow>")


del context
