#!/usr/bin/python

"""This script calls the trusted_dealer binary and generates a CLICK ctl script
from its output. The trusted_dealer generates an RSA key using safe primes and
encodes it as a polynomial of degree t. It then outputs n points on this
polynomial. These n parts will then be distributed by the generated CLICK ctl
script to n nodes in the network. After that a new node will broadcast a request
(via flooding) to which the existing nodes respond. The new node will then try to
reconstruct the secret"""

import subprocess

def resp_str(node_id, modulus, pub, share):
    base = ""
    base += "1 " #TIME
    base += "sk" + str(node_id) #NODE
    base += " ath0 " #DEVICE
    base += "write " #MODE
    base += "shamir_server " #ELEMENT

    ret = base
    ret += "modulus " #HANDLER
    ret += modulus + "\n"
    ret += base
    ret += "share " #HANDLER
    ret += share + "\n" #FIXME: Do we also need to pass the public key to the handler
    ret += base
    ret += "share_id " #Handler
    ret += str(node_id) + "\n"
    return ret

def req_str(node_id, modulus, threshold):
    base = ""
    base += "1 " #TIME
    base += "sk" + str(node_id) #NODE
    base += " ath0 " #DEVICE
    base += "write " #MODE
    base += "chamir_client " #ELEMENT

    ret = base
    ret += "modulus " #HANDLER
    ret += modulus + "\n"
    ret += base
    ret += "threshold " #HANDLER
    ret += str(threshold) + "\n"
    return ret

def req_activate(node_id):
    ret = ""
    ret += "5 " #TIME
    ret += "sk" + str(node_id) #NODE
    ret += " ath0 " #DEVICE
    ret += "write " #MODE
    ret += "shamir_client " #ELEMENT
    ret += "active " #HANDLER
    ret += "true"
    ret += "\n"
    return ret

def mes_line(node_id):
    ret = ""
    ret += "sk" + str(node_id) #NODE
    ret += " DEV0 " #DEVICE
    ret += "BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION " #MODULSDIR
    ret += "- " #MODOPTIONS
    ret += "monitor.b.channel " #WIFICONFIG
    ret += "- " #CLICKMODDIR
    ret += "shamir_server.click " #CLICKSCRIPT #FIXME: Needs to be shamir_client.click for the last entry
    ret += "LOGDIR/NODENAME.NODEDEVICE.log " #CLICKLOGFILE
    ret += "- " #APPLICATION
    ret += "-" #APPLICATIONLOGFILE
    ret += "\n"
    return ret

t = 3
n = 5

"""
Call the trusted_dealer binary. Parameters are n and t. The output is:
    modulus
    public key
    n shares
"""
params = subprocess.check_output(["dealer/dealer"])
param_lst = params.split()
modulus = param_lst[0]
pub = param_lst[1]
shares = param_lst[2:]

"""
Output the Click ctl script. The script will setup n+1 nodes. Every node
will receive the modulus, the public key and the node id. The first n
nodes will receive a secret share. The first n nodes will have the
element shamir_resp, the last element will have the element shamir_req.
"""
fd = open("shamir.ctl", "w+")
fd.write("#TIME NODE(S) DEVICE MODE ELEMENT HANDLER VALUE\n")
for i in range(n):
    fd.write(resp_str(i+1, modulus, pub, shares[i]))
fd.write(req_str(n+1, modulus, 3)) #FIXME: threshold 3 should be configurable

fd.write(req_activate(n+1))

"""
Write *.mes file
"""
fd = open("shamir.mes", "w+") #TODO: Replace existing files
fd.write("#NODE DEVICE MODULSDIR MODOPTIONS WIFICONFIG CLICKMODDIR CLICKSCRIPT CLICKLOGFILE APPLICATION APPLICATIONLOGFILE\n")
for i in range(n+1):
    fd.write(mes_line(i+1))
fd.close()
