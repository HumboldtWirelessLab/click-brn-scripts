#!/usr/bin/python
import math
import sys
import random

def check_args():
	global node_number

	argc = len(sys.argv)
	if argc < 2:
	    print("Usage: generate_ctl.py NumberOfNodes")
	    sys.exit();
	
	node_number = int(sys.argv[1])


def find_hidden_nodes():
	global current_time

	print("# Find hidden nodes by sending from each node to each other")

	current_time = math.ceil(current_time)
	for a in range(1, node_number + 1):
		for b in range(1, node_number + 1):
			if a == b:
				continue

			print("{0:.1f}	sk{1}		ath0	write	sf	add_flow	sk{1}:eth sk{2}:eth 50 1500 2 90 true 1 0".format(current_time, a, b))
			current_time += 0.1

	current_time += 1
	for a in range(1, node_number + 1):
		print("{0:.1f}	sk{1}		ath0	read	sf	stats".format(current_time, a))

	current_time += 0.1
	for a in range(1, node_number + 1):
		print("{0:.1f}	sk{1}		ath0	read	hnd	stats".format(current_time, a))
	
	print
	print


def reset_rssi_measurement(src, des, rate):
	global current_time
	global node_number

	print("# Reset RSSI")
	current_time += 0.1
	for a in range(1, node_number + 1):
		print("{0:.1f}	sk{1}		ath0	write	device_wifi/link_stat reset".format(current_time, a))
	print("{0:.1f}	sk{1}		ath0	write	device_wifi/link_stat probes \"2 500 24\"".format(current_time, src))
	print("{0:.1f}	sk{1}		ath0	write	device_wifi/link_stat probes \"2 500 24\"".format(current_time, des))
	print


def get_rssi(src, des, rate):
	global current_time

	print("# Get RSSI")
	current_time += 0.1
	print("{0:.1f}	sk{1}		ath0	write	mcs	rate	{2}".format(current_time, src, rate))
	current_time += 0.1
	print("{0:.1f}	sk{1}		ath0	write	sf	add_flow	sk{1}:eth sk{2}:eth 0 1500 0 500 true".format(current_time, src, des))
	current_time += 0.5
	print("{0:.1f}	sk{1}		ath0	read	device_wifi/link_stat bcast_stats".format(current_time, des))
	print("{0:.1f}	sk{1}		ath0	write	device_wifi/link_stat probes \"\"".format(current_time, src))
	print("{0:.1f}	sk{1}		ath0	write	device_wifi/link_stat probes \"\"".format(current_time, des))
	print


def link_probe_with_load(load_mbitpersec):
	global current_time
	global node_number

	load_burst_count = 5
	load_pck_size = 1500
	load_interval_per_node = 1000.0 / (load_mbitpersec / 8 / (load_burst_count * load_pck_size) / (node_number - 2) )

	print("# Probing with multiple rates for all variations")

	for a in range(1, node_number + 1):
		for b in range(1, node_number + 1):
			if a == b:
				continue
			
			rates=[6, 9, 12, 18, 24, 36, 48, 54]
			current_time = math.ceil(current_time / 10) * 10
			print("# Setup load for next probes")
			for c in range(1, node_number + 1):
				if c == a or c == b:
					continue
				
				print("{0:.1f}	sk{1}		ath0	write	sj	jammer		true".format(current_time, c))
				print("{0:.1f}	sk{1}		ath0	write	mcs	rate	{2}".format(current_time, c, rates[3] * 2))
				print("{0:.1f}	sk{1}		ath0	write	sf	add_flow	sk{1}:eth FF-FF-FF-FF-FF-FF {6:.6f} {4} 0 {2} true {5} {3:.6f}\n".format(
					current_time + 0.1, 
					c, 
					len(rates) * 10 * 1000, 
					random.random() * 10.0,
					load_pck_size,
					load_burst_count,
					load_interval_per_node))
	
			print("# Probe link {0} - {1}".format(a, b))
			for rate in rates:
				current_time = math.ceil(current_time / 10) * 10 
				current_time += 1
				
				print("{0:.0f}	sk{1}		ath0	write	sj	jammer		false".format(current_time, a))
				print("{0:.0f}	sk{1}		ath0	write	sj	jammer		false".format(current_time, b))
				print("{0:.0f}	sk{1}		ath0	write	mcs	rate	{2}".format(current_time, a, rate * 2))
				print("{0:.0f}	sk{1}		ath0	write	sf	reset	".format(current_time, a))
				print("{0:.0f}	sk{1}		ath0	write	sf	reset	".format(current_time, b))
				print("{0:.0f}	sk{1}		ath0	write	sf	extra_data	mcs_rate={2}".format(current_time, a, rate))
				current_time += 2
				print("{0:.0f}	sk{1}		ath0	write	sf	add_flow	sk{1}:eth sk{2}:eth 0 1500 0 1000 true 5 0".format(current_time, a, b))
				current_time += 6
				print("{0:.0f}	sk{1}		ath0	read	sf	stats".format(current_time, b))
				print
			
			print
	

check_args()
current_time = 2

print("#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE\n")

find_hidden_nodes()
link_probe_with_load(22 * 1000 * 1000)
