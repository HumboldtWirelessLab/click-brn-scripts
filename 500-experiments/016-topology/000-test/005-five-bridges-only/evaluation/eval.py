#!/usr/bin/python

import sys
import os
import xml.dom.minidom as dom


def get_list_of_bride_tuples(elements):
    result = []
    for element in elements:
        nodeA = element.getAttribute("nodeA").encode('utf-8')
        nodeB = element.getAttribute("nodeB").encode('utf-8')
        result.append((nodeA, nodeB))
    return result

def check_bridges(file_path):
    tree = dom.parse(file_path)

    bridge_elements = tree.getElementsByTagName("Bridge")
    bridge_detecting_node_names = get_list_of_bride_tuples(bridge_elements)

    expected_nodes = [
        ("00-00-00-00-00-01", "00-00-00-00-00-02"),
        ("00-00-00-00-00-02", "00-00-00-00-00-01"),
        ("00-00-00-00-00-02", "00-00-00-00-00-03"),
        ("00-00-00-00-00-03", "00-00-00-00-00-02"),
        ("00-00-00-00-00-03", "00-00-00-00-00-04"),
        ("00-00-00-00-00-04", "00-00-00-00-00-03"),
        ("00-00-00-00-00-04", "00-00-00-00-00-05"),
        ("00-00-00-00-00-05", "00-00-00-00-00-04")]
    for node in expected_nodes:
        if not node in bridge_detecting_node_names:
            print "Mising bridge {0}.".format(node)
            print "Found Bridges: {0}.".format(bridge_detecting_node_names)
            return False

    for node in bridge_detecting_node_names:
        if not node in expected_nodes:
            print "Wrong bridge {0}.".format(node)
            print "Found Bridges: {0}.".format(bridge_detecting_node_names)
            return False

    return True


def failed(comment):
  print comment
  sys.exit(1)


success = 0

path_to_evaluate =  os.environ.get("RESULTDIR")
if path_to_evaluate is None:
  failed("Error: missing environment var RESULTDIR.")
  eval_result = failed

file_path = os.path.join(path_to_evaluate, "measurement.xml")

Result1 = check_bridges(file_path)
if not Result1:
    failed("Failed incorrect bridges.")

print "Success"
sys.exit(success)
