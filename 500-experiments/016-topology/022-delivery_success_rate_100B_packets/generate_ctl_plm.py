#!/usr/bin/python3
import math
import sys
import random
from optparse import OptionParser


def check_args():
	global nodes_per_step
	global step_distance
	global step_count
	global cmd_line
	global num_measurements

	cmd_line = ' '.join(sys.argv[1:])

	optParser = OptionParser()
	optParser.add_option("-n", "--nodes", dest="node_num", type="int", help="Number of nodes per step.")
	optParser.add_option("-s", "--step_distance", dest="step_distance", type="float", help="Distance of one single step.")
	optParser.add_option("-c", "--step_count", dest="step_count", type="int", help="Number of steps.")
	optParser.add_option("-i", "--iterations", dest="num_measurements", type="int", help="Number of iterations (measurements).")
	(options, args) = optParser.parse_args()

	if not options.node_num or not options.step_distance or not options.step_count or not options.num_measurements:
		optParser.print_help()
		sys.exit(-1)

	nodes_per_step = options.node_num
	step_distance = options.step_distance
	step_count = options.step_count
	num_measurements = options.num_measurements

	
def setup_extra_data(fh):
	global step_count
	global step_distance
	global nodes_per_step

	fh.write("# setup extra_data as distaces\n")
	
	node = 2
	for distance in [i * step_distance for i in range(1, step_count + 1)]: 
		for x in range(1, nodes_per_step + 1):
			fh.write("0	sk{0}		ath0	write	sf	extra_data	{1}\n".format(node, distance))
			node = node + 1
	fh.write("")


def setup_dummies(fh):
	global step_count
	global step_distance
	global nodes_per_step

	fh.write("# add dummies (inactive) to get the extra_data-field visible \n")
	
	node = 2
	for distance in [i * step_distance for i in range(1, step_count + 1)]: 
		for x in range(1, nodes_per_step + 1):
			fh.write("0	sk{0}		ath0	write	sf	add_flow	sk{0}:eth FF-FF-FF-FF-FF-FF 100 1500 0 100 false 5 0\n".format(node))
			node = node + 1
	fh.write("\n")


def setup_sk1(fh):
	fh.write("# mark first node as not relevant\n")
	fh.write("0	sk1		ath0	write	sf	extra_data	dont_use\n")
	fh.write("\n")
	fh.write("# real flow\n")

	duration = 100
	pause = 5
	start_time = 0.001
	for i in range(0, num_measurements):
		start_time =  start_time + (duration + pause)
		#fh.write("{0}	sk1		ath0	write	sf	add_flow	sk1:eth FF-FF-FF-FF-FF-FF 100 100 0 100000 true 1 0\n".format(start_time))
		fh.write("{0}  sk1             ath0    write   sf      add_flow        sk1:eth FF-FF-FF-FF-FF-FF 25 100 0 25000 true 1 0\n".format(start_time))
	fh.write("{0}	ALL		ath0	read	sf	stats	\n".format(start_time +  duration + (pause / 2)))


def setup_plm(fh):
	global step_count
	global step_distance
	global nodes_per_step

	fh.write("sk1 0 2 0\n")

	node = 2
	for distance in [i * step_distance for i in range(1, step_count + 1)]: 
		for x in range(1, nodes_per_step + 1):
			fh.write("sk{0} {1:.0f} 2 0\n".format(node, distance))
			node = node + 1


check_args()

fh = open("simpleflow.ctl", "w")
fh.write("#Created with " + cmd_line + "\n\n")
fh.write("#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE\n\n")
setup_extra_data(fh)
setup_dummies(fh)
setup_sk1(fh)
fh.close()

fh = open("placementfile.plm", "w")
setup_plm(fh)
fh.close()

fh = open("simpleflow.mes", "w")
fh.write("#NODE		DEVICE	MODULSDIR					 MODOPTIONS WIFICONFIG			CLICKMODDIR	CLICKSCRIPT			CLICKLOGFILE			APPLICATION	APPLICATIONLOGFILE\n")
fh.write("random:{0}	DEV0	BASEDIR/nodes/lib/modules/NODEARCH/KERNELVERSION -	    monitor.b.channel		-		simpleflow.click		LOGDIR/NODENAME.NODEDEVICE.log	-		-\n".format((step_count * nodes_per_step + 1)))
fh.close()
