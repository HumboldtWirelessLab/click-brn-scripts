#!/usr/bin/python
from os import fork

import sys
import os
import xml.dom.minidom as dom


def check_num_tx_and_rx(file_path):
    tree = dom.parse(file_path)

    txList = tree.getElementsByTagName("DibadawnPacketTx")
    rxList = tree.getElementsByTagName("DibadawnPacketRx")

    if len(txList) != 3:
        print "Failed, found {0} TX-packets".format(len(txList))
        return False
    if len(rxList) != 3:
        print "Failed, found {0} RX-packets".format(len(rxList))
        return False
    return True


def check_node_equal_forwaredBy(file_path):
    tree = dom.parse(file_path)

    tx_list = tree.getElementsByTagName("DibadawnPacketTx")

    for entry in tx_list:
        node = entry.getAttribute("node")

        forwardedBy = entry.getElementsByTagName("forwardedBy")[0]
        forwardedByValue = forwardedBy.firstChild.data
        if node != forwardedByValue:
            print("Failed, TX by node:{0} has wrong forwardBy attribute ({1})".format(node, forwardedByValue))
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

Result = check_num_tx_and_rx(file_path)
if not Result:
    failed("Failed, invalid num of TX/RX packets.")

Result = check_node_equal_forwaredBy(file_path)
if not Result:
    failed("The attribute forwardedBy is not equal to node.")
print "Success"
sys.exit(success)
