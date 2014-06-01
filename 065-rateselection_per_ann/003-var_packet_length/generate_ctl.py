#!/usr/bin/python
import math
import sys

argc = len(sys.argv)
if argc < 2:
    print "Usage: generate_ctl.py NumberOfNodes"
    sys.exit();

node_number = int(sys.argv[1])
current_time = 2


print("#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE\n")

print("# Probing multiple packet lengths with multiple rates for all variations")
for a in range(1, node_number + 1):
	for b in range(1, node_number + 1):
		if a == b:
			continue
		

		for rate in [6, 9, 12, 18, 24, 36, 48, 54]:

			for len in range(100, 1600, 100):
				print("# Probe link {0} - {1} with length {2}".format(a, b, len))
				
				current_time = math.ceil(current_time / 10) * 10 
				current_time += 1
				print("{0:.0f}	sk{1}		ath0	write	mcs	rate	{2}".format(current_time, a, rate * 2))
				print("{0:.0f}	sk{1}		ath0	read	mcs	rate	".format(current_time, a))
				print("{0:.0f}	sk{1}		ath0	write	sf	reset	".format(current_time, a))
				current_time += 2
				print("{0:.0f}	sk{1}		ath0	write	sf	add_flow	sk{1}:eth sk{2}:eth 50 {4} 2 5000 true 1 0 mcs_rate={3}".format(current_time, a, b, rate, len))
				current_time += 6
				print("{0:.0f}	sk{1}		ath0	read	sf	stats".format(current_time, a))
				print
		
		print