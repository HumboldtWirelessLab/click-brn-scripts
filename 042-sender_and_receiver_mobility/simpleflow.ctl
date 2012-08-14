#TIME	NODE(S)	DEVICE	MODE	ELEMENT		HANDLER		VALUE
10	sk110 	ath0	write	sf		add_flow	sk110:eth FF-FF-FF-FF-FF-FF 10 1500 0 15000 true
#10	sk110 	ath0	write	sf		add_flow	sk110:eth sk111:eth 10 1500 0 15000 true
12	sk112 	ath0	move	absolute	2		100 50 0
14	sk110 	ath0	write	mob		move		1 50 0 2
18	sk110 	ath0	write	sf		add_flow	sk110:eth FF-FF-FF-FF-FF-FF 10 1500 0 15000 false
#18	sk110 	ath0	write	sf		add_flow	sk110:eth sk111:eth 10 1500 0 15000 false
19	sk110	ath0	read	sf		stats
19	sk111	ath0	read	sf		stats
