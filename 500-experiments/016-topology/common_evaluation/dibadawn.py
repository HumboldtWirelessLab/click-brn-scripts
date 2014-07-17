#!/usr/bin/env python

import math
import pylab
import scipy
import sys
import os
import xml.dom.minidom as dom
from optparse import OptionParser
from mpl_toolkits.mplot3d import Axes3D
import csv
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


def extract_bridges(file_path):
	edges = []

	tree = dom.parse(file_path)

	searchtree_xml_elements = tree.getElementsByTagName("Bridge")
	for entry in searchtree_xml_elements:
		node_a = entry.getAttribute("nodeA")
		node_b = entry.getAttribute("nodeB")
		if (node_b, node_a, False) in edges or (node_a, node_b, False) in edges:
			skip = True
		else:
			skip = False

		edges.append((node_b, node_a, skip))

	return edges


def extract_topology_bridges(file_path):
	edges = []

	tree = dom.parse(file_path)

	searchtree_xml_elements = tree.getElementsByTagName("bridge")
	for entry in searchtree_xml_elements:
		node_a = entry.getAttribute("node_a")
		node_b = entry.getAttribute("node_b")
		if (node_b, node_a, False) in edges or (node_a, node_b, False) in edges:
			continue
		
		edges.append((node_b, node_a, False))

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
optParser.add_option("-f", "--file", dest="measurement_file", type="string", help="measurement file")
optParser.add_option("-o", "--output", dest="output_path", type="string", help="write into file")
optParser.add_option("-m", "--macs", dest="is_show_macs", action="store_true", help="Draw macs. (False)", default=False)
optParser.add_option("-c", "--coordinates", dest="is_show_coordinates", action="store_true", help="Draw coordinates. (False)", default=False)
(options, args) = optParser.parse_args()

if not options.path:
	print("Failed: Please enter a path to evaluate with option '-p=<path>'")
	sys.exit(-1)

file_path = os.path.join(options.path, "nodes.csv")
(xs, ys, zs, node_names, macs) = read_nodes_from_file(file_path)

plot.scatter(xs, ys, s=30, c="gray")


nodes = zip(xs, ys, zs, node_names, macs)
print("Nodes:")
for x, y, z, name, mac in nodes:
	print("  {0}: mac={1} pos=({2},{3},{4})".format(name, mac, x, y, z))

if None != options.measurement_file:
	file_path = options.measurement_file
else:
	file_path = os.path.join(options.path, "measurement.xml")

searchtreeEdges = extract_search_tree_edges(file_path)
searchtreeEdges = translate_nodes_to_pos(searchtreeEdges, nodes)
print("Search-Tree-Edges: (solid black)")
for node, parent, node_pos, parent_pos, skip in searchtreeEdges:
	print("  {0} -- {1} => {2} -- {3}".format(node, parent, node_pos, parent_pos, skip))
for node, parent, (nx, ny, nz), (px, py, pz), skip in searchtreeEdges:
	if not skip:
		plot.plot([nx, px], [ny, py], color="k", ls="-")

crossEdges = extract_cross_edges(file_path)
crossEdges = translate_nodes_to_pos(crossEdges, nodes)
print("Cross-Edges: (dashed yellow)" )
for node, parent, node_pos, parent_pos, skip in crossEdges:
	print("  {0} -- {1} => {2} -- {3}".format(node, parent, node_pos, parent_pos, skip))
for node, parent, (nx, ny, nz), (px, py, pz), skip in crossEdges:
	if not skip:
		plot.plot([nx, px], [ny, py], color="y", ls="--", linewidth="3")

invalidCrossEdges = extract_invalid_cross_edges(file_path)
invalidCrossEdges = translate_nodes_to_pos(invalidCrossEdges, nodes)
print("Invalid Cross-Edges: (dashed cyan)")
for node, parent, node_pos, parent_pos, skip in invalidCrossEdges:
	print("  {0} -- {1} => {2} -- {3}".format(node, parent, node_pos, parent_pos, skip))
for node, parent, (nx, ny, nz), (px, py, pz), skip in invalidCrossEdges:
	if not skip:
		plot.plot([nx, px], [ny, py], color="c", ls="--", linewidth="3")

bridges = extract_topology_bridges(file_path)
bridges = translate_nodes_to_pos(bridges, nodes)
print("Bridges: (solid yellow)")
for node, parent, node_pos, parent_pos, skip in bridges:
	print("  {0} -- {1} => {2} -- {3}".format(node, parent, node_pos, parent_pos, skip))
for node, parent, (nx, ny, nz), (px, py, pz), skip in bridges:
	if not skip:
		plot.plot([nx, px], [ny, py], color="y", ls="-", linewidth="3")

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
	picture_file_name = os.path.join(options.output_path, "dibadawn_graph.png")
	print("Write file \"" + picture_file_name + "\".")
	plot.savefig(picture_file_name)
