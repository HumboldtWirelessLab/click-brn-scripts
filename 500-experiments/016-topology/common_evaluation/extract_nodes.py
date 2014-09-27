#!/usr/bin/env python3

from optparse import OptionParser
import sys
import os
import csv
from collections import OrderedDict


def extract_names_and_macs_from_file(file_path):
	macs = []
	node_names = []
	
	with open(file_path, 'r') as f:
		reader = csv.reader(f, delimiter=' ', quoting=csv.QUOTE_NONE)
		for row in reader:
			node_name = row[0]
			interface = row[1]
			mac = row[2]
			number = row[3]

			macs.append(mac)
			node_names.append(node_name)

	return node_names, macs

def extract_node_id_from_file(file_path, node_name):
	id = None
	try:
		with open(file_path, 'r') as f:
			reader = csv.reader(f, delimiter=' ', quoting=csv.QUOTE_NONE)
			found = False
			for row in reader:
				if row[0] == "n" and (node_name + ".") in row[8]:
					id = row[4]
					found = True
					break

			if not found:
				print("Error: Failed to find id for node {0} in {1}.".format(node_name, file_path))
				sys.exit(-1)
	except:
		id = 0

	return id


def extract_pos_by_id_from_file(file_path, id):
	x = y = z = None
	try:
		with open(file_path, 'r') as f:
			reader = csv.reader(f, delimiter=' ', quoting=csv.QUOTE_NONE)
			found = False
			for row in reader:
				if row[0] == "n" and  id == row[4] and row[2] == "*":
					x = row[7]
					y = row[9]
					z = row[11]
					found = True
					break

			if not found:
				print("Error: Failed to find position for id {0} in {1}.".format(id, file_path))
				sys.exit(-1)
	except:
		x = 0
		y = 0
		z = 0
	

	return x, y, z


def extract_pos_by_node_names_from_file(file_path, nodes_names):
	xs = []
	ys = []
	zs = []
	nodes = []

	for node_name in node_names:
		id = extract_node_id_from_file(file_path, node_name)
		(x, y, z) = extract_pos_by_id_from_file(file_path, id)
		xs.append(x)
		ys.append(y)
		zs.append(z)

	return xs, ys, zs


optParser = OptionParser()
optParser.add_option("-p", "--path", dest="path", type="string", help="Path to to dir, where to find xml-file")
optParser.add_option("-i", "--interactive", dest="is_interactive", help="Interactive mode" , action="store_true")
(options, args) = optParser.parse_args()

if not options.path:
    print("Failed: Please enter a path to evaluate with option '-p=<path>'")
    sys.exit(-1)

file_path = os.path.join(options.path, "nodes.mac")
(node_names, macs) = extract_names_and_macs_from_file(file_path)

file_path = os.path.join(options.path, "simpleflow.nam")
(xs, ys, zs) = extract_pos_by_node_names_from_file(file_path, node_names)

nodes = zip(xs, ys, zs, node_names, macs)

file_path = os.path.join(options.path, "nodes.csv")
with open(file_path, 'w', newline='') as f:
	header = OrderedDict([('x',None),('y',None), ('z',None), ('name',None), ('mac',None)])
	dw = csv.DictWriter(f, delimiter=',', fieldnames=header, quotechar='"', quoting=csv.QUOTE_ALL)
	dw.writerow(dict((fn,fn) for fn in header))

	writer = csv.writer(f, quotechar='"', quoting=csv.QUOTE_ALL)
	writer.writerows(nodes)
