#!/usr/bin/python

import sys
import os
import xml.dom.minidom as dom
import shutil

def check_bridge_btw_node3_and_node2_edge(file_path):
    tree = dom.parse(file_path)

    found_list = tree.getElementsByTagName("Bridge")
    if len(found_list) != 2:
        print "Did not found two bridge detections, got {0}.".format(len(found_list))
        return False


    nodeName1 = found_list[0].getAttribute("node")
    nodeName2 = found_list[1].getAttribute("node")
    if not ((nodeName1 == "00-00-00-00-00-03" and nodeName2 == "00-00-00-00-00-02") or (nodeName1 == "00-00-00-00-00-02" and nodeName2 == "00-00-00-00-00-03")):
        print "Bridge between wrong nodes ({0},{1}).".format(nodeName1, nodeName2)
        return False
    return True


def failed(comment):
    print comment
    sys.exit(1)


def copy_placement_file_if_missing(path_to_evaluate):
    expected_file_path = os.path.join(path_to_evaluate, "placementfile.plm")
    alternative_file_path = os.path.join(path_to_evaluate, "../placementfile.plm")

    if not os.path.exists(expected_file_path):
        if os.path.exists(alternative_file_path):
            print("Copy placement file {0} to {1}.".format(alternative_file_path, expected_file_path))
            shutil.copyfile(alternative_file_path, expected_file_path)
        else:
            print("Error, Placementfile missing.")


success = 0

path_to_evaluate =  os.environ.get("RESULTDIR")
if path_to_evaluate is None:
  failed("Error: missing environment var RESULTDIR.")
  eval_result = failed

copy_placement_file_if_missing(path_to_evaluate)

file_path = os.path.join(path_to_evaluate, "measurement.xml")

Result1 = check_bridge_btw_node3_and_node2_edge(file_path)
if not Result1:
    failed("Failed to find bridge between node 2 and 3.")

print "Success"
sys.exit(success)
