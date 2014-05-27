#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE
3	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 700 true 1 0
4	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 700 true 1 0
2	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 700 true 1 0
5	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 700 true 1 0
6	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 700 true 1 0
7	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 700 true 1 0


13	sk1 	ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
23	sk1 	ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
33	sk1 	ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0

