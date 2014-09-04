#!/usr/bin/python2

import math
import pylab
import scipy
import sys
import os
import xml.dom.minidom as dom
from optparse import OptionParser
from mpl_toolkits.mplot3d import Axes3D
import csv
import xml.etree.ElementTree as Et
import matplotlib.pyplot as pyplot
import collections
import time

cmd_search_tree 		= 0
cmd_cross_edge 			= 1
cmd_invalid_cross_edge 	= 2
cmd_bridge				= 3
cmd_dibadawn_start		= 4

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

def read_measurement(file_path, specific_search=None):
	command_dict = dict()

	context = Et.iterparse(file_path, events=('start',))
	for event, elem in context:
		if elem.tag == 'DibadawnStartSearch' and (specific_search == None or elem.get("searchId") == specific_search):
			node = elem.get("node")
			time = float(elem.get("time"))
			
			cmds = command_dict.get(time, [])
			cmds.append((cmd_dibadawn_start, {'node': node}))
			command_dict[time] = cmds

		elif elem.tag == 'SearchTree' and (specific_search == None or elem.get("searchId") == specific_search):
			node = elem.get("node")
			parent = elem.get("parent")
			time = float(elem.get("time"))
			
			cmds = command_dict.get(time, [])
			cmds.append( (cmd_search_tree, {'node': node, 'parent': parent}) )
			command_dict[time] = cmds

		elif elem.tag == 'CrossEdgeDetected' and (specific_search == None or elem.get("searchId") == specific_search):
			node = elem.get("node")
			neighbor = elem.get("neighbor")
			time = float(elem.get("time"))
			valid = elem.get("valid") == '1'
			if valid:
				cmd = cmd_cross_edge
			else:
				cmd = cmd_invalid_cross_edge
			
			cmds = command_dict.get(time, [])
			cmds.append( (cmd, {'node': node, 'neighbor': neighbor}) )
			command_dict[time] = cmds

		elif elem.tag == 'Bridge' and (specific_search == None or elem.get("searchId") == specific_search):
			nodeA = elem.get("nodeA")
			nodeB = elem.get("nodeB")
			time = float(elem.get("time"))
			
			cmds = command_dict.get(time, [])
			cmds.append( (cmd_bridge, {'nodeA': nodeA, 'nodeB': nodeB}) )
			command_dict[time] = cmds

		elem.clear()

	sorted_command_dict = collections.OrderedDict(sorted(command_dict.items()))

	return sorted_command_dict

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

def get_node_dict(nodes):
	result = {}

	for x, y, z, name, mac in nodes:
		result[mac] = ((x, y, z), name)

	return result

def on_key(event):
	global current_command_key_idx
	global commands
	global command_keys

	if event.key == 'q':
		sys.exit(0);
	elif event.key == 'left' and current_command_key_idx > 0:
		current_command_key_idx = current_command_key_idx - 1
		
		print(current_command_key_idx, len(command_keys))
		draw_scene()

	elif event.key == 'right' and current_command_key_idx < len(command_keys):
		current_command_key_idx = current_command_key_idx + 1
		
		print(current_command_key_idx, len(command_keys))
		draw_scene()

def draw_scene():
	global plot
	global fig

	plot.clear()
	draw_lines()
	draw_nodes()
	pyplot.draw()

def draw_lines():
	global current_command_key_idx
	global commands
	global command_keys
	global node_dict
	global plot

	for idx in range(0, current_command_key_idx):
		for (cmd, attr) in commands[command_keys[idx]]:

			if cmd == cmd_search_tree :
				node_mac = attr['node']
				parent_mac = attr['parent']
				((nx, ny, nz), node_name) = node_dict[node_mac]
				((px, py, pz), parent_name) = node_dict[parent_mac]
	
				print_link(parent_name, node_name, (px, py, pz), (nx, ny, nz), command_keys[idx], "T ")
				plot.plot([nx, px], [ny, py], color="k", ls="-")

			elif cmd == cmd_cross_edge:
				node_mac = attr['node']
				neighbor_mac = attr['neighbor']
				((nx, ny, nz), node_name) = node_dict[node_mac]
				((px, py, pz), neighbor_name) = node_dict[neighbor_mac]

				print_link(neighbor_name, node_name, (px, py, pz), (nx, ny, nz), command_keys[idx], "C ")
				plot.plot([nx, px], [ny, py], color="k", ls=":", linewidth="1")

			elif cmd == cmd_invalid_cross_edge:
				node_mac = attr['node']
				neighbor_mac = attr['neighbor']
				((nx, ny, nz), node_name) = node_dict[node_mac]
				((px, py, pz), neighbor_name) = node_dict[neighbor_mac]

				print_link(node_name, neighbor_name, (nx, ny, nz), (px, py, pz), command_keys[idx], "IC")
				plot.plot([nx, px], [ny, py], color="c", ls="--", linewidth="1")

			elif cmd == cmd_bridge:
				nodeA_mac = attr['nodeA']
				nodeB_mac = attr['nodeB']
				((nx, ny, nz), nodeA_name) = node_dict[nodeA_mac]
				((px, py, pz), nodeB_name) = node_dict[nodeB_mac]

				print_link(nodeA_name, nodeB_name, (nx, ny, nz), (px, py, pz), command_keys[idx], "Br")
				plot.plot([nx, px], [ny, py], color="y", ls="-", linewidth="1")

def print_link(adesc, bdesc, (ax, ay, az), (bx, by, bz), time, prefix):
	apos = "({0},{1})".format(ax,ay)
	bpos = "({0},{1})".format(bx,by)
	link = "{0}--{1}".format(adesc, bdesc)
	print(" {0:<10} {1} {2:<38} {3}--{4}".format(time, prefix, link, apos, bpos))

def draw_nodes():
	global current_command_key_idx
	global commands
	global command_keys
	global node_dict
	global options

	nodes_with_starting_searches = []
	for (cmd, attr) in commands[command_keys[current_command_key_idx - 1]]:
		if cmd == cmd_dibadawn_start:
			node_mac = attr['node']
			nodes_with_starting_searches.append(node_mac)

	macs = node_dict.keys()
	for mac in macs:
		if mac in nodes_with_starting_searches:
			continue

		((x,y,z), name) = node_dict[mac]
		label = name
		if(options.is_show_macs):
			label = label + ' (%s)' % (mac)
		if(options.is_show_coordinates):
			label = label + '\n(%d, %d, %d)' % (x, y, z)
		plot.scatter(x, y, s=30, c="gray")
		plot.text(x, y, label, horizontalalignment='center', verticalalignment='bottom',)

	for mac in nodes_with_starting_searches:
		((x,y,z), name) = node_dict[mac]
		label = name
		if(options.is_show_macs):
			label = label + ' (%s)' % (mac)
		if(options.is_show_coordinates):
			label = label + '\n(%d, %d, %d)' % (x, y, z)
		plot.scatter(x, y, s=250, c="white")
		plot.scatter(x, y, s=90, c="gray")
		plot.text(x, y, label, horizontalalignment='center', verticalalignment='bottom',)
		print("  {2} Start: {0} > {1}".format(name, (x, y, z), command_keys[current_command_key_idx - 1]))

	print	


optParser = OptionParser()
optParser.add_option("-p", "--path", dest="path", type="string", help="Path to to dir, where to find xml-file")
optParser.add_option("-f", "--file", dest="measurement_file", type="string", help="measurement file")
optParser.add_option("-o", "--output", dest="output_path", type="string", help="write into file")
optParser.add_option("-s", "--search", dest="specific_search", type="string", help="specific search to show")
optParser.add_option("-m", "--macs", dest="is_show_macs", action="store_true", help="Draw macs. (False)", default=False)
optParser.add_option("-c", "--coordinates", dest="is_show_coordinates", action="store_true", help="Draw coordinates. (False)", default=False)
(options, args) = optParser.parse_args()

if not options.path:
	print("Failed: Please enter a path to evaluate with option '-p=<path>'")
	sys.exit(-1)

file_path = os.path.join(options.path, "nodes.csv")
(xs, ys, zs, node_names, macs) = read_nodes_from_file(file_path)


fig = pyplot.figure()
fig.canvas.mpl_connect('key_press_event', on_key)
plot = fig.add_subplot(111)
plot.scatter(xs, ys, s=30, c="gray")

nodes = zip(xs, ys, zs, node_names, macs)
node_dict = get_node_dict(nodes)

print("Nodes:")
for x, y, z, name, mac in nodes:
	print("  {0}: mac={1} pos=({2},{3},{4})".format(name, mac, x, y, z))

if None != options.measurement_file:
	file_path = options.measurement_file
else:
	file_path = os.path.join(options.path, "measurement.xml")

commands = read_measurement(file_path, options.specific_search)
command_keys = commands.keys()
current_command_key_idx = 0

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
print("Cross-Edges: (dotted black)" )
for node, parent, node_pos, parent_pos, skip in crossEdges:
	print("  {0} -- {1} => {2} -- {3}".format(node, parent, node_pos, parent_pos, skip))
for node, parent, (nx, ny, nz), (px, py, pz), skip in crossEdges:
	if not skip:
		plot.plot([nx, px], [ny, py], color="k", ls=":", linewidth="1")

invalidCrossEdges = extract_invalid_cross_edges(file_path)
invalidCrossEdges = translate_nodes_to_pos(invalidCrossEdges, nodes)
print("Invalid Cross-Edges: (dashed cyan)")
for node, parent, node_pos, parent_pos, skip in invalidCrossEdges:
	print("  {0} -- {1} => {2} -- {3}".format(node, parent, node_pos, parent_pos, skip))
for node, parent, (nx, ny, nz), (px, py, pz), skip in invalidCrossEdges:
	if not skip:
		plot.plot([nx, px], [ny, py], color="c", ls="--", linewidth="1")

bridges = extract_topology_bridges(file_path)
bridges = translate_nodes_to_pos(bridges, nodes)
print("Bridges: (solid yellow)")
for node, parent, node_pos, parent_pos, skip in bridges:
	print("  {0} -- {1} => {2} -- {3}".format(node, parent, node_pos, parent_pos, skip))
for node, parent, (nx, ny, nz), (px, py, pz), skip in bridges:
	if not skip:
		plot.plot([nx, px], [ny, py], color="y", ls="-", linewidth="1")

for x, y, z, name, mac in nodes:
	label = name
	if(options.is_show_macs):
		label = label + ' (%s)' % (mac)
	if(options.is_show_coordinates):
		label = label + '\n(%d, %d, %d)' % (x, y, z)
	plot.text(x, y, label, horizontalalignment='center', verticalalignment='bottom',)
	
if not options.output_path:
	pyplot.show()
else:
	picture_file_name = os.path.join(options.output_path, "dibadawn_graph.png")
	print("Write file \"" + picture_file_name + "\".")
	pyplot.savefig(picture_file_name)
