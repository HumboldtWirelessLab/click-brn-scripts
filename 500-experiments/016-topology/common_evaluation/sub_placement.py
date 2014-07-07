#!/usr/bin/python

from optparse import OptionParser
import csv
import sys


def read_placement_from_file(file_path):
	xs = []
	ys = []
	zs = []
	nodes = []
	macs = []
	with open(file_path, 'r') as f:
		reader = csv.reader(f, delimiter=',', quoting=csv.QUOTE_ALL)
		reader.next()
		for row in reader:
			xs.append(int(row[0]))
			ys.append(int(row[1]))
			zs.append(int(row[2]))
			nodes.append(row[3])
			macs.append(row[4])
			
	return xs, ys, zs, nodes, macs


def read_nodes_from_file(file_path):
	nodes = []
	with open(file_path, 'r') as f:
		reader = csv.reader(f, delimiter=',', quoting=csv.QUOTE_ALL)
		for row in reader:
			nodes.append(row[0])
			
	return nodes


def get_placement_by_node_names(origin_placement, nodes):
	new_placement = []
	for node in nodes:
		found = False
		for (x, y, z, name, mac) in origin_placement:
			if name == node:
				new_placement.append((x, y, z, name, mac))
				found = True
				break

		if not found:
			return []

	return new_placement


def get_placement_by_node_macs(origin_placement, nodes):
	new_placement = []
	for node in nodes:
		found = False
		for (x, y, z, name, mac) in origin_placement:
			if mac == node:
				new_placement.append((x, y, z, name, mac))
				found = True
				break

		if not found:
			return []

	return new_placement


optParser = OptionParser()
optParser.add_option("-n", "--nodes", dest="origin_placement_path", help="Path to nodes.csv", default=False)
optParser.add_option("-l", "--list", dest="nodes_path", help="Path to list of node sub set.", default=False)
optParser.add_option("-r", "--rename", dest="is_rename", action="store_true", help="Rename node names to sk... .", default=False)
(options, args) = optParser.parse_args()

if(not options.origin_placement_path or not options.nodes_path):
	optParser.print_help()
	sys.exit()

(xs, ys, zs, node_names, macs) = read_placement_from_file(options.origin_placement_path)
origin_placement = zip(xs, ys, zs, node_names, macs)

nodes = read_nodes_from_file(options.nodes_path)

new_placement = get_placement_by_node_names(origin_placement, nodes)
if len(new_placement) == 0:
	new_placement = get_placement_by_node_macs(origin_placement, nodes)
if len(new_placement) == 0:
	sys.exit(-1)

sk_counter = 0
first = True
for (x, y, z, name, mac) in new_placement:
	if not first:
		print
	else:
		first = False

	if options.is_rename:
		sys.stdout.write("sk{0} {1} {2} {3}".format(sk_counter, x, y, z))
		sk_counter = sk_counter + 1
	else:
		sys.stdout.write("{0} {1} {2} {3}".format(name, x, y, z))
