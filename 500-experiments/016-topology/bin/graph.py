#!/usr/bin/env python

import math
import pylab
import scipy
import sys
import os
import xml.dom.minidom as dom
from optparse import OptionParser
import csv
import numpy as np
import matplotlib.pyplot as plot


def create_random_values():
	p = scipy.randn(1500, 2)

	xs = scipy.array(p[:, 0])
	ys = scipy.array(p[:, 1])
	zs = map(vlen, xs)

	return xs, ys, zs


def vlen(v):
	return math.sqrt(scipy.vdot(v, v))


def read_nodes_from_file(file_path):
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


def extract_mac_by_node_from_mac_file(file_path, nodes):
	macs = []
	for node in nodes:
		with open(file_path, 'r') as f:
			reader = csv.reader(f, delimiter=' ', quoting=csv.QUOTE_NONE)
			for row in reader:
				node_name = row[0]
				interface = row[1]
				mac = row[2]
				number = row[3]

				if(node_name == node):
					macs.append(mac)

	return macs


def extract_search_tree_edges(file_path):
	edges = []

	tree = dom.parse(file_path)

	searchtree_xml_elements = tree.getElementsByTagName("SearchTree")
	for entry in searchtree_xml_elements:
		parent = entry.getAttribute("parent")
		node = entry.getAttribute("node")

		if (node, parent, False) in edges or (parent, node, False) in edges:
			skip = True
		else:
			skip = False

		edges.append((node, parent, skip))

	return edges


def extract_links(file_path):
	edges = []

	with open(file_path, 'rb') as csvfile:
		spamreader = csv.reader(csvfile, delimiter=',', quotechar='"')
		first = True
		for row in spamreader:
			if first:
				first = False
				continue

			edges.append((row[0], row[1], False))

	return edges


def extract_cross_edges(file_path):
	edges = []

	tree = dom.parse(file_path)

	searchtree_xml_elements = tree.getElementsByTagName("CrossEdgeDetected")
	for entry in searchtree_xml_elements:
		valid = entry.getAttribute("valid")
		if valid == "0":
			continue

		neighbor = entry.getAttribute("neighbor")
		node = entry.getAttribute("node")
		if (node, neighbor, False) in edges or (neighbor, node, False) in edges:
			skip = True
		else:
			skip = False

		edges.append((node, neighbor, skip))

	return edges


def extract_invalid_cross_edges(file_path):
	edges = []

	tree = dom.parse(file_path)

	searchtree_xml_elements = tree.getElementsByTagName("CrossEdgeDetected")
	for entry in searchtree_xml_elements:
		valid = entry.getAttribute("valid")
		if valid != "0":
			continue

		neighbor = entry.getAttribute("neighbor")
		node = entry.getAttribute("node")
		if (node, neighbor, False) in edges or (neighbor, node, False) in edges:
			skip = True
		else:
			skip = False

		edges.append((node, neighbor, skip))

	return edges


def translate_nodes_to_pos(edges, nodes):
	result=[]
	pos_a=(0,0,0)
	pos_b=(0,0,0)
	for node_a, node_b, skip_info in edges:
		for x, y, z, name, mac in nodes:
			if node_a == mac:
				pos_a=(x,y,z)
			elif node_b == mac:
				pos_b=(x,y,z)

		result.append((node_a, node_b, pos_a, pos_b, skip_info))
	return result

optParser = OptionParser()
optParser.add_option("-p", "--path", dest="path", type="string", help="Path to to dir, where to find xml-file")
optParser.add_option("-o", "--output", dest="output_path", type="string", help="write into file")
optParser.add_option("-m", "--macs", dest="is_show_macs", action="store_false", help="Draw macs. (False)", default=False)
optParser.add_option("-c", "--coordinates", dest="is_show_coordinates", action="store_false", help="Draw coordinates. (False)", default=False)
(options, args) = optParser.parse_args()

if not options.path:
	print "Failed: Please enter a path to evaluate with option '-p=<path>'"
	sys.exit(-1)


file_path = os.path.join(options.path, "nodes.csv")
(xs, ys, zs, node_names, macs) = read_nodes_from_file(file_path)
nodes = zip(xs, ys, zs, node_names, macs)
print("Nodes:")
for x, y, z, name, mac in nodes:
	print("  {0}: mac={1} pos=({2},{3},{4})".format(name, mac, x, y, z))
for x, y, z, name, mac in nodes:
	plot.scatter(x, y, s=30, c="gray")

file_path_links = os.path.join(options.path, "links.csv")
links = extract_links(file_path_links)
links = translate_nodes_to_pos(links, nodes)
print("Links:")
for node, parent, node_pos, parent_pos, skip in links:
	print("  {0} -- {1} => {2} -- {3}".format(node, parent, node_pos, parent_pos, skip))
for node, parent, (nx, ny, nz), (px, py, pz), skip in links:
	if not skip:
		plot.plot([nx, px], [ny, py], color="k", ls="-")

for x, y, z, name, mac in nodes:
	label = name
	if(options.is_show_macs):
		label = label + ' (%s)' % (mac)
	if(options.is_show_coordinates):
		label = label + '\n(%d, %d, %d)' % (x, y, z)
	plot.text(x, y, label, horizontalalignment='center', verticalalignment='bottom',)

if not options.output_path:
	plot.show()
else:
	picture_file_name = os.path.join(options.output_path, "link_graph.png")
	print("Write file \"" + picture_file_name + "\".")
	plot.savefig(picture_file_name)

