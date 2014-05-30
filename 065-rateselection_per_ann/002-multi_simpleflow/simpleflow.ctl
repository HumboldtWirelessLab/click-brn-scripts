#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE

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

