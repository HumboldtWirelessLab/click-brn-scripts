#TIME	NODE(S)		DEVICE	MODE	ELEMENT				HANDLER		VALUE
#100	ALL		ath0	read	lt				links
#100	ALL		ath0	read    device_wifi/link_stat		bcast_stats
200	FIRSTNODE 	ath0	write	sf				add_flow	FIRSTNODE:eth LASTNODE:eth 500 100 2 15000 true
218	FIRSTNODE 	ath0	write	sf				add_flow	FIRSTNODE:eth LASTNODE:eth 500 100 2 15000 false
219	FIRSTNODE	ath0	read	sf				stats
219	LASTNODE	ath0	read	sf				stats
220	FIRSTNODE	ath0	read	routing/routing/dsr_stats	stats
220	LASTNODE	ath0	read	routing/routing/dsr_stats	stats
#220	ALL		ath0	read	routing/routing/dsr_stats	stats
#220	ALL		ath0	read	routing/routing/querier		stats
#220	ALL		ath0	write	routing/routing/dsr_stats	reset		0
#220	ALL		ath0	read	routing/routing/dsr_stats	stats
	  