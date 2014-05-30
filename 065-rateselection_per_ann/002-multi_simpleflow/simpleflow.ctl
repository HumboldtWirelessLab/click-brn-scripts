#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE,

# Find hidden nodes by sending from each node to each other
2.0	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 200 2 90 true 1 0
2.1	sk1		ath0	read	sf	stats
2.2	sk1		ath0	write	sf	reset
2.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
2.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
2.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats

3.0	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 200 2 90 true 1 0
3.1	sk1		ath0	read	sf	stats
3.2	sk1		ath0	write	sf	reset
3.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
3.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
3.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats

4.0	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 200 2 90 true 1 0
4.1	sk2		ath0	read	sf	stats
4.1	sk3		ath0	read	device_wifi/wifidevice/cst	stats
4.2	sk2		ath0	write	sf	reset
4.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
4.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
4.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats

5.0	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 200 2 90 true 1 0
5.1	sk2		ath0	read	sf	stats
5.2	sk2		ath0	write	sf	reset
5.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
5.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
5.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats

6.0	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 200 2 90 true 1 0
6.1	sk3		ath0	read	sf	stats
6.2	sk3		ath0	write	sf	reset
6.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
6.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
6.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats

7.0	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 200 2 90 true 1 0
7.1	sk3		ath0	read	sf	stats
7.2	sk3		ath0	write	sf	reset
7.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
7.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
7.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats


# Probe one link with multiple rates
11	sk2		ath0	write	mcs	rate	12
11	sk2		ath0	read	mcs	rate	
11	sk2		ath0	write	sf	reset	
13	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0 6
19	sk2		ath0	read	sf	stats

21	sk2		ath0	write	mcs	rate	18
21	sk2		ath0	read	mcs	rate	
21	sk2		ath0	write	sf	reset	
23	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0 9
29	sk2		ath0	read	sf	stats

31	sk2		ath0	write	mcs	rate	24
31	sk2		ath0	read	mcs	rate	
31	sk2		ath0	write	sf	reset	
33	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0 12
39	sk2		ath0	read	sf	stats

41	sk2		ath0	write	mcs	rate	36
41	sk2		ath0	read	mcs	rate	
41	sk2		ath0	write	sf	reset	
43	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0 18
49	sk2		ath0	read	sf	stats

51	sk2		ath0	write	mcs	rate	48
51	sk2		ath0	read	mcs	rate	
51	sk2		ath0	write	sf	reset	
53	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0 24
59	sk2		ath0	read	sf	stats

61	sk2		ath0	write	mcs	rate	72
61	sk2		ath0	read	mcs	rate	
61	sk2		ath0	write	sf	reset	
63	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0 36
69	sk2		ath0	read	sf	stats

71	sk2		ath0	write	mcs	rate	96
71	sk2		ath0	read	mcs	rate	
71	sk2		ath0	write	sf	reset	
73	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0 48
79	sk2		ath0	read	sf	stats

81	sk2		ath0	write	mcs	rate	108
81	sk2		ath0	read	mcs	rate	
81	sk2		ath0	write	sf	reset	
83	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0 54
89	sk2		ath0	read	sf	stats

