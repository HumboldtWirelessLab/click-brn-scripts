import math
import pylab
import scipy
import sys
import os
import xml.dom.minidom as dom
from optparse import OptionParser
from mpl_toolkits.mplot3d import Axes3D
import csv


def create_random_values():
    p = scipy.randn(1500, 2)

    xs = scipy.array(p[:, 0])
    ys = scipy.array(p[:, 1])
    zs = map(vlen, xs)

    return xs, ys, zs


def vlen(v):
    return math.sqrt(scipy.vdot(v, v))


def extract_position_from_xml(file_path):
    tree = dom.parse(file_path)

    setups = tree.getElementsByTagName("Setup")

    xs = []
    ys = []
    zs = []
    nodes = []
    for entry in setups:
        x = entry.getAttribute("x")
        y = entry.getAttribute("y")
        z = entry.getAttribute("z")
        node = entry.getAttribute("node")

        xs.append(x)
        ys.append(y)
        zs.append(z)
        nodes.append(node)

    return xs, ys, zs, nodes


def extract_position_from_placement_file(file_path):
    xs = []
    ys = []
    zs = []
    nodes = []
    with open(file_path, 'r') as f:
        reader = csv.reader(f, delimiter=' ', quoting=csv.QUOTE_NONE)
        for row in reader:
            nodes.append(row[0])
            xs.append(int(row[1]))
            ys.append(int(row[2]))
            zs.append(int(row[3]))

    return xs, ys, zs, nodes


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


def extract_cross_edges(file_path):
    edges = []

    tree = dom.parse(file_path)

    searchtree_xml_elements = tree.getElementsByTagName("CrossEdgeDetected")
    for entry in searchtree_xml_elements:
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
optParser.add_option("-i", "--interactive", dest="is_interactive", help="Interactive mode" , action="store_true")
optParser.add_option("-t", "--testdata", dest="create_test_data", help="Use testdata" , action="store_true")
(options, args) = optParser.parse_args()

if not options.path:
    print "Failed: Please enter a path to evaluate with option '-p=<path>'"
    sys.exit(-1)

fig = pylab.figure()
ax = Axes3D(fig)

if options.create_test_data:
    (txs, tys, tzs) = create_random_values()
    ax.scatter3D(txs, tys, tzs, s=30, c="blue")

file_path = os.path.join(options.path, "placementfile.plm")
(xs, ys, zs, node_names) = extract_position_from_placement_file(file_path)

ax.scatter3D(xs, ys, zs, s=30, c="gray")

file_path = os.path.join(options.path, "nodes.mac")
macs = extract_mac_by_node_from_mac_file(file_path, node_names)
nodes = zip(xs, ys, zs, node_names, macs)
print("Nodes:")
for x, y, z, name, mac in nodes:
    print("  {0}: mac={1} pos=({2},{3},{4})".format(name, mac, x, y, z))

file_path = os.path.join(options.path, "measurement.xml")
searchtreeEdges = extract_search_tree_edges(file_path)
searchtreeEdges = translate_nodes_to_pos(searchtreeEdges, nodes)
print("Search-Tree-Edges:")
for node, parent, node_pos, parent_pos, skip in searchtreeEdges:
    print("  {0} -- {1} => {2} -- {3} (skip={4})".format(node, parent, node_pos, parent_pos, skip))
for node, parent, (nx, ny, nz), (px, py, pz), skip in searchtreeEdges:
    if not skip:
        ax.plot([nx, px], [ny, py],zs=[nz, pz], color="k", ls="-")

file_path = os.path.join(options.path, "measurement.xml")
crossEdges = extract_cross_edges(file_path)
crossEdges = translate_nodes_to_pos(crossEdges, nodes)
print("Cross-Edges:")
for node, parent, node_pos, parent_pos, skip in crossEdges:
    print("  {0} -- {1} => {2} -- {3} (skip={4})".format(node, parent, node_pos, parent_pos, skip))
for node, parent, (nx, ny, nz), (px, py, pz), skip in crossEdges:
    if not skip:
        ax.plot([nx, px], [ny, py],zs=[nz, pz], color="c", ls="--")

for x, y, z, name, mac in nodes:
    label = '%s (%s)\n(%d, %d, %d)' % (name, mac, x, y, z)
    ax.text(x, y, z, label, horizontalalignment='center', verticalalignment='bottom',)

if options.is_interactive:
    pylab.show()
else:
    picture_file_name = "nodes_on_map.png"
    print("Write file \"" + picture_file_name + "\".")
    pylab.savefig(picture_file_name)

