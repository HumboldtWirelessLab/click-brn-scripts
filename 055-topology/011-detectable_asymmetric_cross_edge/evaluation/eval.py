#!/usr/bin/python

import sys
import os
import xml.dom.minidom as dom
import libeval


def check_cross_edge(file_path):
    tree = dom.parse(file_path)

    found_list = tree.getElementsByTagName("CrossEdgeDetected")
    if len(found_list) < 1:
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

libeval.copy_placement_file_if_missing(path_to_evaluate)

file_path = os.path.join(path_to_evaluate, "measurement.xml")

Result1 = check_cross_edge(file_path)
if not Result1:
    failed("Failed to find at least one cross edge.")

print "Success"
sys.exit(success)
