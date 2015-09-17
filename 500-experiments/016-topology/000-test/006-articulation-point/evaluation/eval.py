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
        ("00-00-00-00-00-03", "00-00-00-00-00-02")]
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


def check_one_articulation_point(file_path):
    tree = dom.parse(file_path)

    ap_elements = tree.getElementsByTagName("ArticulationPoint")

    exp_n = 1;
    n = len(ap_elements)
    if n != exp_n:
        print "Failed, incorrect number of articulation points (have:{0} want:{1})".format(n, exp_n)
        return False

    node_name = ap_elements[0].getAttribute("node")
    if not node_name == "00-00-00-00-00-02":
        print "Failed, incorrect node detected as articulation point ({0})".format(node_name)
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

Result = check_bridges(file_path)
if not Result:
    failed("Failed to find correct bridges.")

Result = check_one_articulation_point(file_path)
if not Result:
    failed("Failed to find correct articulation points");

print "Success"
sys.exit(success)
