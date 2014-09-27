#!/usr/bin/python3

import xml.etree.ElementTree as Et
import sys
import csv
import math
from optparse import OptionParser


def read_nodes_from_file(file_path):
	xs = []
	ys = []
	zs = []
	nodes = []
	macs = []
	with open(file_path, 'r') as f:
		reader = csv.reader(f, delimiter=',', quoting=csv.QUOTE_ALL)
		next(reader)
		for row in reader:
			xs.append(int(row[0]))
			ys.append(int(row[1]))
			zs.append(int(row[2]))
			nodes.append(row[3])
			macs.append(row[4])
			
	return xs, ys, zs, nodes, macs


def get_node_dict(nodes):
	result = {}

	for x, y, z, name, mac in nodes:
		result[mac] = ((x, y, z), name)

	return result


optParser = OptionParser()
optParser.add_option("-l", "--link_file", dest="links_path", type="string", help="Path to Links XML file")
optParser.add_option("-n", "--nodes_file", dest="nodes_path", type="string", help="Path to nodes CSV file")
optParser.add_option("-e", "--metric_etx_limit", type="float", dest="etx_metric_limit", default=999999.9, help="ETX-metric limit for accepted links")
(options, args) = optParser.parse_args()

if not options.links_path or not options.nodes_path:
	print("Failed: Missing input measurement file")
	optParser.print_help()
	sys.exit(-1)


(xs, ys, zs, node_names, macs) = read_nodes_from_file(options.nodes_path)
nodes = zip(xs, ys, zs, node_names, macs)
node_dict = get_node_dict(nodes)

used_content = list()
num_filtered = 0
num_used     = 0
header 		 = str()
print("\"node_a\",\"node_b\",\"etx_metric\",\"distance\"")
with open(options.links_path, 'r') as f:
	reader = csv.reader(f, delimiter=',', quoting=csv.QUOTE_ALL)
	next(reader)
	
	for row in reader:
		a_node_mac = row[0]
		b_node_mac = row[1]
		etx_metric = row[2]

		((a_x, a_y, a_z), a_name) = node_dict[a_node_mac]
		((b_x, b_y, b_z), b_name) = node_dict[b_node_mac]

		distance = math.sqrt(pow(a_x - b_x, 2) + pow(a_y - b_y, 2) + pow(a_z - b_z, 2))
		print("{0},{1},{2},{3:.3f}".format(a_node_mac, b_node_mac, etx_metric, distance))


