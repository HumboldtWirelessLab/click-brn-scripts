#TIME	NODE(S)	DEVICE	MODE	ELEMENT				HANDLER		VALUE
1	sk1	ath0 	write	device_wifi/ig_suppressor	active0		false
1	sk2	ath0 	write	device_wifi/ig_suppressor	active0		false
5	sk1	ath0 	write	device_wifi/ig_flow		add_flow	sk1:eth FF-FF-FF-FF-FF-FF 0 1500 0 1000 true 10 1000
6	sk1	ath0 	write	device_wifi/ig_suppressor	active0		true
7	sk1	ath0 	write	device_wifi/ig_suppressor	active0		false
7	sk1	ath0 	write	device_wifi/ig_notifierqueue	reset		0
9	sk2	ath0 	write	device_wifi/ig_flow		add_flow	sk2:eth FF-FF-FF-FF-FF-FF 0 1500 0 1000 true 10 1000
10	sk2	ath0 	write	device_wifi/ig_suppressor	active0		true
11	sk2	ath0 	write	device_wifi/ig_suppressor	active0		false
11	sk2	ath0 	write	device_wifi/ig_notifierqueue	reset		0
13	sk1	ath0 	write	device_wifi/ig_flow		add_flow	sk1:eth FF-FF-FF-FF-FF-FF 0 1500 0 2000 true 10 1000
13	sk2	ath0 	write	device_wifi/ig_flow		add_flow	sk2:eth FF-FF-FF-FF-FF-FF 0 1500 0 2000 true 10 1000
14	sk1	ath0 	write	device_wifi/ig_suppressor	active0		true
14	sk2	ath0 	write	device_wifi/ig_suppressor	active0		true
16	sk1	ath0 	write	device_wifi/ig_suppressor	active0		false
16	sk2	ath0 	write	device_wifi/ig_suppressor	active0		false
16	sk1	ath0 	write	device_wifi/ig_notifierqueue	reset		0
16	sk2	ath0 	write	device_wifi/ig_notifierqueue	reset		0
20	sk1	ath0    read	device_wifi/ig_flow stats
20	sk2	ath0    read	device_wifi/ig_flow stats
