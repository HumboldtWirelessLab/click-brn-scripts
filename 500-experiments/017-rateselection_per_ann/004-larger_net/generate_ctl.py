#!/usr/bin/python
import math
import sys

argc = len(sys.argv)
if argc < 2:
    print("Usage: generate_ctl.py NumberOfNodes")
    sys.exit();

node_number = int(sys.argv[1])
current_time = 2


print("#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE\n")


print("# Setup jammer")
print("1	sk8 	ath0	write	sj	cca		-10 -5 10")
print("1	sk8 	ath0	write	sj	jammer		true")

print("# Find hidden nodes by sending from each node to each other")
current_time = math.ceil(current_time)
for a in range(1, node_number + 1):
	for b in range(1, node_number + 1):
		if a == b:
			continue
		print("{0:.1f}	sk{1}		ath0	write	sf	add_flow	sk{1}:eth sk{2}:eth 50 3000 2 90 true 1 0".format(current_time, a, b))
current_time += 1
for a in range(1, node_number + 1):
	print("{0:.1f}	sk{1}		ath0	read	sf	stats".format(current_time, a))
current_time += 0.1
for a in range(1, node_number + 1):
	print("{0:.1f}	sk{1}		ath0	read	device_wifi/wifidevice/hnd	stats".format(current_time, a))
print
print

print("# Get RSSI")
current_time = math.ceil(current_time / 10) * 10
for a in range(1, node_number + 1):
	print("{0:.1f}	sk{1}		ath0	read	device_wifi/link_stat bcast_stats".format(current_time, a))
print
print

print("# Probing with multiple rates for all variations")
for a in range(1, node_number + 1):
	for b in range(1, node_number + 1):
		if a == b:
			continue
		print("# Probe link {0} - {1}".format(a, b))

		for rate in [6, 9, 12, 18, 24, 36, 48, 54]:
			current_time = math.ceil(current_time / 10) * 10 
			current_time += 1
			print("{0:.0f}	sk{1}		ath0	write	mcs	rate	{2}".format(current_time, a, rate * 2))
			print("{0:.0f}	sk{1}		ath0	write	sf	reset	".format(current_time, a))
			print("{0:.0f}	sk{1}		ath0	write	sf	reset	".format(current_time, b))
			print("{0:.0f}	sk{1}		ath0	write	sf	extra_data	mcs_rate={2}".format(current_time, a, rate))
			current_time += 2
			print("{0:.0f}	sk{1}		ath0	write	sf	add_flow	sk{1}:eth sk{2}:eth 50 1500 2 1000 true 1 0".format(current_time, a, b))
			current_time += 6
			print("{0:.0f}	sk{1}		ath0	read	sf	stats".format(current_time, b))
			print
		
		print