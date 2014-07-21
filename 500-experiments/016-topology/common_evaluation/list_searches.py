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

context = Et.iterparse(measurement_file, events=('end',))

for event, elem in context:
    if elem.tag == 'DibadawnStartSearch':
        print("  " + elem.get("searchId"))
    elem.clear()


del context
