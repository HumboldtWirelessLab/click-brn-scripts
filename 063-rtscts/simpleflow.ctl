#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE
#9	ALL	ath0	read	device_wifi/wifidevice/hnd	stats
#9	ALL	ath0	read	device_wifi/cocst		stats
10	sk1 	ath0	write	sf	add_flow	sk1:eth sk2:eth 10 1500 2 1000 true 1 1000
10	sk3 	ath0	write	sf	add_flow	sk3:eth sk2:eth 10 1500 2 1000 true 1 1000
12	ALL	ath0	read	sf	stats
12	ALL	ath0	read	device_wifi/wifidevice/hnd	stats
12	ALL	ath0	read	device_wifi/wifidevice/setrtscts	stats
12	ALL	ath0	read	device_wifi/wifidevice/cst		stats
