#!/usr/bin/python

import os
import libeval


path_to_evaluate = os.environ.get("RESULTDIR")
if path_to_evaluate is None:
    libeval.failed("Missing environment var RESULTDIR.")

file_path = os.path.join(path_to_evaluate, "measurement.xml")

bridge_pairs = [
    ("00-00-00-00-00-01", "00-00-00-00-00-02"),
    ("00-00-00-00-00-02", "00-00-00-00-00-01"),
    ("00-00-00-00-00-02", "00-00-00-00-00-03"),
    ("00-00-00-00-00-03", "00-00-00-00-00-02")]
Result = libeval.check_bridges(file_path, bridge_pairs)
if not Result:
    libeval.failed("Failed to find correct bridges.")

articulation_nodes = ["00-00-00-00-00-02"]
Result = libeval.check_articulation_points(file_path, articulation_nodes)
if not Result:
    libeval.failed("Failed to find correct articulation points")

libeval.success("Success")

