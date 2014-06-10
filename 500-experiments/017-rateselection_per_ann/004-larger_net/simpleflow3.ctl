#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE

# Setup jammer
1	sk8 	ath0	write	sj	cca		-10 -5 10
1	sk8 	ath0	write	sj	jammer		true
# Find hidden nodes by sending from each node to each other
2.0	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 3000 2 90 true 1 0
2.0	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 3000 2 90 true 1 0
2.0	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 50 3000 2 90 true 1 0
2.0	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 50 3000 2 90 true 1 0
2.0	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 50 3000 2 90 true 1 0
2.0	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 3000 2 90 true 1 0
2.0	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 3000 2 90 true 1 0
2.0	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 50 3000 2 90 true 1 0
2.0	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 50 3000 2 90 true 1 0
2.0	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 50 3000 2 90 true 1 0
2.0	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 3000 2 90 true 1 0
2.0	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 3000 2 90 true 1 0
2.0	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 50 3000 2 90 true 1 0
2.0	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 50 3000 2 90 true 1 0
2.0	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 50 3000 2 90 true 1 0
2.0	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 50 3000 2 90 true 1 0
2.0	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 50 3000 2 90 true 1 0
2.0	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 50 3000 2 90 true 1 0
2.0	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 50 3000 2 90 true 1 0
2.0	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 50 3000 2 90 true 1 0
2.0	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 50 3000 2 90 true 1 0
2.0	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 50 3000 2 90 true 1 0
2.0	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 50 3000 2 90 true 1 0
2.0	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 50 3000 2 90 true 1 0
2.0	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 50 3000 2 90 true 1 0
2.0	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 50 3000 2 90 true 1 0
2.0	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 50 3000 2 90 true 1 0
2.0	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 50 3000 2 90 true 1 0
2.0	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 50 3000 2 90 true 1 0
2.0	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 50 3000 2 90 true 1 0
3.0	sk1		ath0	read	sf	stats
3.0	sk2		ath0	read	sf	stats
3.0	sk3		ath0	read	sf	stats
3.0	sk4		ath0	read	sf	stats
3.0	sk5		ath0	read	sf	stats
3.0	sk6		ath0	read	sf	stats
3.1	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
3.1	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
3.1	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
3.1	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
3.1	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
3.1	sk6		ath0	read	device_wifi/wifidevice/hnd	stats


# Get RSSI
10.0	sk1		ath0	read	device_wifi/link_stat bcast_stats
10.0	sk2		ath0	read	device_wifi/link_stat bcast_stats
10.0	sk3		ath0	read	device_wifi/link_stat bcast_stats
10.0	sk4		ath0	read	device_wifi/link_stat bcast_stats
10.0	sk5		ath0	read	device_wifi/link_stat bcast_stats
10.0	sk6		ath0	read	device_wifi/link_stat bcast_stats


# Probing with multiple rates for all variations
# Probe link 1 - 2
11	sk1		ath0	write	mcs	rate	12
11	sk1		ath0	write	sf	reset	
11	sk2		ath0	write	sf	reset	
11	sk1		ath0	write	sf	extra_data	mcs_rate=6
13	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
19	sk2		ath0	read	sf	stats

21	sk1		ath0	write	mcs	rate	18
21	sk1		ath0	write	sf	reset	
21	sk2		ath0	write	sf	reset	
21	sk1		ath0	write	sf	extra_data	mcs_rate=9
23	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
29	sk2		ath0	read	sf	stats

31	sk1		ath0	write	mcs	rate	24
31	sk1		ath0	write	sf	reset	
31	sk2		ath0	write	sf	reset	
31	sk1		ath0	write	sf	extra_data	mcs_rate=12
33	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
39	sk2		ath0	read	sf	stats

41	sk1		ath0	write	mcs	rate	36
41	sk1		ath0	write	sf	reset	
41	sk2		ath0	write	sf	reset	
41	sk1		ath0	write	sf	extra_data	mcs_rate=18
43	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
49	sk2		ath0	read	sf	stats

51	sk1		ath0	write	mcs	rate	48
51	sk1		ath0	write	sf	reset	
51	sk2		ath0	write	sf	reset	
51	sk1		ath0	write	sf	extra_data	mcs_rate=24
53	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
59	sk2		ath0	read	sf	stats

61	sk1		ath0	write	mcs	rate	72
61	sk1		ath0	write	sf	reset	
61	sk2		ath0	write	sf	reset	
61	sk1		ath0	write	sf	extra_data	mcs_rate=36
63	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
69	sk2		ath0	read	sf	stats

71	sk1		ath0	write	mcs	rate	96
71	sk1		ath0	write	sf	reset	
71	sk2		ath0	write	sf	reset	
71	sk1		ath0	write	sf	extra_data	mcs_rate=48
73	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
79	sk2		ath0	read	sf	stats

81	sk1		ath0	write	mcs	rate	108
81	sk1		ath0	write	sf	reset	
81	sk2		ath0	write	sf	reset	
81	sk1		ath0	write	sf	extra_data	mcs_rate=54
83	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
89	sk2		ath0	read	sf	stats


# Probe link 1 - 3
91	sk1		ath0	write	mcs	rate	12
91	sk1		ath0	write	sf	reset	
91	sk3		ath0	write	sf	reset	
91	sk1		ath0	write	sf	extra_data	mcs_rate=6
93	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0
99	sk3		ath0	read	sf	stats

101	sk1		ath0	write	mcs	rate	18
101	sk1		ath0	write	sf	reset	
101	sk3		ath0	write	sf	reset	
101	sk1		ath0	write	sf	extra_data	mcs_rate=9
103	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0
109	sk3		ath0	read	sf	stats

111	sk1		ath0	write	mcs	rate	24
111	sk1		ath0	write	sf	reset	
111	sk3		ath0	write	sf	reset	
111	sk1		ath0	write	sf	extra_data	mcs_rate=12
113	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0
119	sk3		ath0	read	sf	stats

121	sk1		ath0	write	mcs	rate	36
121	sk1		ath0	write	sf	reset	
121	sk3		ath0	write	sf	reset	
121	sk1		ath0	write	sf	extra_data	mcs_rate=18
123	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0
129	sk3		ath0	read	sf	stats

131	sk1		ath0	write	mcs	rate	48
131	sk1		ath0	write	sf	reset	
131	sk3		ath0	write	sf	reset	
131	sk1		ath0	write	sf	extra_data	mcs_rate=24
133	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0
139	sk3		ath0	read	sf	stats

141	sk1		ath0	write	mcs	rate	72
141	sk1		ath0	write	sf	reset	
141	sk3		ath0	write	sf	reset	
141	sk1		ath0	write	sf	extra_data	mcs_rate=36
143	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0
149	sk3		ath0	read	sf	stats

151	sk1		ath0	write	mcs	rate	96
151	sk1		ath0	write	sf	reset	
151	sk3		ath0	write	sf	reset	
151	sk1		ath0	write	sf	extra_data	mcs_rate=48
153	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0
159	sk3		ath0	read	sf	stats

161	sk1		ath0	write	mcs	rate	108
161	sk1		ath0	write	sf	reset	
161	sk3		ath0	write	sf	reset	
161	sk1		ath0	write	sf	extra_data	mcs_rate=54
163	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0
169	sk3		ath0	read	sf	stats


# Probe link 1 - 4
171	sk1		ath0	write	mcs	rate	12
171	sk1		ath0	write	sf	reset	
171	sk4		ath0	write	sf	reset	
171	sk1		ath0	write	sf	extra_data	mcs_rate=6
173	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 50 1500 2 1000 true 1 0
179	sk4		ath0	read	sf	stats

181	sk1		ath0	write	mcs	rate	18
181	sk1		ath0	write	sf	reset	
181	sk4		ath0	write	sf	reset	
181	sk1		ath0	write	sf	extra_data	mcs_rate=9
183	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 50 1500 2 1000 true 1 0
189	sk4		ath0	read	sf	stats

191	sk1		ath0	write	mcs	rate	24
191	sk1		ath0	write	sf	reset	
191	sk4		ath0	write	sf	reset	
191	sk1		ath0	write	sf	extra_data	mcs_rate=12
193	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 50 1500 2 1000 true 1 0
199	sk4		ath0	read	sf	stats

201	sk1		ath0	write	mcs	rate	36
201	sk1		ath0	write	sf	reset	
201	sk4		ath0	write	sf	reset	
201	sk1		ath0	write	sf	extra_data	mcs_rate=18
203	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 50 1500 2 1000 true 1 0
209	sk4		ath0	read	sf	stats

211	sk1		ath0	write	mcs	rate	48
211	sk1		ath0	write	sf	reset	
211	sk4		ath0	write	sf	reset	
211	sk1		ath0	write	sf	extra_data	mcs_rate=24
213	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 50 1500 2 1000 true 1 0
219	sk4		ath0	read	sf	stats

221	sk1		ath0	write	mcs	rate	72
221	sk1		ath0	write	sf	reset	
221	sk4		ath0	write	sf	reset	
221	sk1		ath0	write	sf	extra_data	mcs_rate=36
223	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 50 1500 2 1000 true 1 0
229	sk4		ath0	read	sf	stats

231	sk1		ath0	write	mcs	rate	96
231	sk1		ath0	write	sf	reset	
231	sk4		ath0	write	sf	reset	
231	sk1		ath0	write	sf	extra_data	mcs_rate=48
233	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 50 1500 2 1000 true 1 0
239	sk4		ath0	read	sf	stats

241	sk1		ath0	write	mcs	rate	108
241	sk1		ath0	write	sf	reset	
241	sk4		ath0	write	sf	reset	
241	sk1		ath0	write	sf	extra_data	mcs_rate=54
243	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 50 1500 2 1000 true 1 0
249	sk4		ath0	read	sf	stats


# Probe link 1 - 5
251	sk1		ath0	write	mcs	rate	12
251	sk1		ath0	write	sf	reset	
251	sk5		ath0	write	sf	reset	
251	sk1		ath0	write	sf	extra_data	mcs_rate=6
253	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 50 1500 2 1000 true 1 0
259	sk5		ath0	read	sf	stats

261	sk1		ath0	write	mcs	rate	18
261	sk1		ath0	write	sf	reset	
261	sk5		ath0	write	sf	reset	
261	sk1		ath0	write	sf	extra_data	mcs_rate=9
263	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 50 1500 2 1000 true 1 0
269	sk5		ath0	read	sf	stats

271	sk1		ath0	write	mcs	rate	24
271	sk1		ath0	write	sf	reset	
271	sk5		ath0	write	sf	reset	
271	sk1		ath0	write	sf	extra_data	mcs_rate=12
273	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 50 1500 2 1000 true 1 0
279	sk5		ath0	read	sf	stats

281	sk1		ath0	write	mcs	rate	36
281	sk1		ath0	write	sf	reset	
281	sk5		ath0	write	sf	reset	
281	sk1		ath0	write	sf	extra_data	mcs_rate=18
283	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 50 1500 2 1000 true 1 0
289	sk5		ath0	read	sf	stats

291	sk1		ath0	write	mcs	rate	48
291	sk1		ath0	write	sf	reset	
291	sk5		ath0	write	sf	reset	
291	sk1		ath0	write	sf	extra_data	mcs_rate=24
293	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 50 1500 2 1000 true 1 0
299	sk5		ath0	read	sf	stats

301	sk1		ath0	write	mcs	rate	72
301	sk1		ath0	write	sf	reset	
301	sk5		ath0	write	sf	reset	
301	sk1		ath0	write	sf	extra_data	mcs_rate=36
303	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 50 1500 2 1000 true 1 0
309	sk5		ath0	read	sf	stats

311	sk1		ath0	write	mcs	rate	96
311	sk1		ath0	write	sf	reset	
311	sk5		ath0	write	sf	reset	
311	sk1		ath0	write	sf	extra_data	mcs_rate=48
313	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 50 1500 2 1000 true 1 0
319	sk5		ath0	read	sf	stats

321	sk1		ath0	write	mcs	rate	108
321	sk1		ath0	write	sf	reset	
321	sk5		ath0	write	sf	reset	
321	sk1		ath0	write	sf	extra_data	mcs_rate=54
323	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 50 1500 2 1000 true 1 0
329	sk5		ath0	read	sf	stats


# Probe link 1 - 6
331	sk1		ath0	write	mcs	rate	12
331	sk1		ath0	write	sf	reset	
331	sk6		ath0	write	sf	reset	
331	sk1		ath0	write	sf	extra_data	mcs_rate=6
333	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 50 1500 2 1000 true 1 0
339	sk6		ath0	read	sf	stats

341	sk1		ath0	write	mcs	rate	18
341	sk1		ath0	write	sf	reset	
341	sk6		ath0	write	sf	reset	
341	sk1		ath0	write	sf	extra_data	mcs_rate=9
343	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 50 1500 2 1000 true 1 0
349	sk6		ath0	read	sf	stats

351	sk1		ath0	write	mcs	rate	24
351	sk1		ath0	write	sf	reset	
351	sk6		ath0	write	sf	reset	
351	sk1		ath0	write	sf	extra_data	mcs_rate=12
353	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 50 1500 2 1000 true 1 0
359	sk6		ath0	read	sf	stats

361	sk1		ath0	write	mcs	rate	36
361	sk1		ath0	write	sf	reset	
361	sk6		ath0	write	sf	reset	
361	sk1		ath0	write	sf	extra_data	mcs_rate=18
363	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 50 1500 2 1000 true 1 0
369	sk6		ath0	read	sf	stats

371	sk1		ath0	write	mcs	rate	48
371	sk1		ath0	write	sf	reset	
371	sk6		ath0	write	sf	reset	
371	sk1		ath0	write	sf	extra_data	mcs_rate=24
373	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 50 1500 2 1000 true 1 0
379	sk6		ath0	read	sf	stats

381	sk1		ath0	write	mcs	rate	72
381	sk1		ath0	write	sf	reset	
381	sk6		ath0	write	sf	reset	
381	sk1		ath0	write	sf	extra_data	mcs_rate=36
383	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 50 1500 2 1000 true 1 0
389	sk6		ath0	read	sf	stats

391	sk1		ath0	write	mcs	rate	96
391	sk1		ath0	write	sf	reset	
391	sk6		ath0	write	sf	reset	
391	sk1		ath0	write	sf	extra_data	mcs_rate=48
393	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 50 1500 2 1000 true 1 0
399	sk6		ath0	read	sf	stats

401	sk1		ath0	write	mcs	rate	108
401	sk1		ath0	write	sf	reset	
401	sk6		ath0	write	sf	reset	
401	sk1		ath0	write	sf	extra_data	mcs_rate=54
403	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 50 1500 2 1000 true 1 0
409	sk6		ath0	read	sf	stats


# Probe link 2 - 1
411	sk2		ath0	write	mcs	rate	12
411	sk2		ath0	write	sf	reset	
411	sk1		ath0	write	sf	reset	
411	sk2		ath0	write	sf	extra_data	mcs_rate=6
413	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
419	sk1		ath0	read	sf	stats

421	sk2		ath0	write	mcs	rate	18
421	sk2		ath0	write	sf	reset	
421	sk1		ath0	write	sf	reset	
421	sk2		ath0	write	sf	extra_data	mcs_rate=9
423	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
429	sk1		ath0	read	sf	stats

431	sk2		ath0	write	mcs	rate	24
431	sk2		ath0	write	sf	reset	
431	sk1		ath0	write	sf	reset	
431	sk2		ath0	write	sf	extra_data	mcs_rate=12
433	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
439	sk1		ath0	read	sf	stats

441	sk2		ath0	write	mcs	rate	36
441	sk2		ath0	write	sf	reset	
441	sk1		ath0	write	sf	reset	
441	sk2		ath0	write	sf	extra_data	mcs_rate=18
443	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
449	sk1		ath0	read	sf	stats

451	sk2		ath0	write	mcs	rate	48
451	sk2		ath0	write	sf	reset	
451	sk1		ath0	write	sf	reset	
451	sk2		ath0	write	sf	extra_data	mcs_rate=24
453	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
459	sk1		ath0	read	sf	stats

461	sk2		ath0	write	mcs	rate	72
461	sk2		ath0	write	sf	reset	
461	sk1		ath0	write	sf	reset	
461	sk2		ath0	write	sf	extra_data	mcs_rate=36
463	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
469	sk1		ath0	read	sf	stats

471	sk2		ath0	write	mcs	rate	96
471	sk2		ath0	write	sf	reset	
471	sk1		ath0	write	sf	reset	
471	sk2		ath0	write	sf	extra_data	mcs_rate=48
473	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
479	sk1		ath0	read	sf	stats

481	sk2		ath0	write	mcs	rate	108
481	sk2		ath0	write	sf	reset	
481	sk1		ath0	write	sf	reset	
481	sk2		ath0	write	sf	extra_data	mcs_rate=54
483	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
489	sk1		ath0	read	sf	stats


# Probe link 2 - 3
491	sk2		ath0	write	mcs	rate	12
491	sk2		ath0	write	sf	reset	
491	sk3		ath0	write	sf	reset	
491	sk2		ath0	write	sf	extra_data	mcs_rate=6
493	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
499	sk3		ath0	read	sf	stats

501	sk2		ath0	write	mcs	rate	18
501	sk2		ath0	write	sf	reset	
501	sk3		ath0	write	sf	reset	
501	sk2		ath0	write	sf	extra_data	mcs_rate=9
503	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
509	sk3		ath0	read	sf	stats

511	sk2		ath0	write	mcs	rate	24
511	sk2		ath0	write	sf	reset	
511	sk3		ath0	write	sf	reset	
511	sk2		ath0	write	sf	extra_data	mcs_rate=12
513	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
519	sk3		ath0	read	sf	stats

521	sk2		ath0	write	mcs	rate	36
521	sk2		ath0	write	sf	reset	
521	sk3		ath0	write	sf	reset	
521	sk2		ath0	write	sf	extra_data	mcs_rate=18
523	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
529	sk3		ath0	read	sf	stats

531	sk2		ath0	write	mcs	rate	48
531	sk2		ath0	write	sf	reset	
531	sk3		ath0	write	sf	reset	
531	sk2		ath0	write	sf	extra_data	mcs_rate=24
533	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
539	sk3		ath0	read	sf	stats

541	sk2		ath0	write	mcs	rate	72
541	sk2		ath0	write	sf	reset	
541	sk3		ath0	write	sf	reset	
541	sk2		ath0	write	sf	extra_data	mcs_rate=36
543	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
549	sk3		ath0	read	sf	stats

551	sk2		ath0	write	mcs	rate	96
551	sk2		ath0	write	sf	reset	
551	sk3		ath0	write	sf	reset	
551	sk2		ath0	write	sf	extra_data	mcs_rate=48
553	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
559	sk3		ath0	read	sf	stats

561	sk2		ath0	write	mcs	rate	108
561	sk2		ath0	write	sf	reset	
561	sk3		ath0	write	sf	reset	
561	sk2		ath0	write	sf	extra_data	mcs_rate=54
563	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
569	sk3		ath0	read	sf	stats


# Probe link 2 - 4
571	sk2		ath0	write	mcs	rate	12
571	sk2		ath0	write	sf	reset	
571	sk4		ath0	write	sf	reset	
571	sk2		ath0	write	sf	extra_data	mcs_rate=6
573	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 50 1500 2 1000 true 1 0
579	sk4		ath0	read	sf	stats

581	sk2		ath0	write	mcs	rate	18
581	sk2		ath0	write	sf	reset	
581	sk4		ath0	write	sf	reset	
581	sk2		ath0	write	sf	extra_data	mcs_rate=9
583	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 50 1500 2 1000 true 1 0
589	sk4		ath0	read	sf	stats

591	sk2		ath0	write	mcs	rate	24
591	sk2		ath0	write	sf	reset	
591	sk4		ath0	write	sf	reset	
591	sk2		ath0	write	sf	extra_data	mcs_rate=12
593	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 50 1500 2 1000 true 1 0
599	sk4		ath0	read	sf	stats

601	sk2		ath0	write	mcs	rate	36
601	sk2		ath0	write	sf	reset	
601	sk4		ath0	write	sf	reset	
601	sk2		ath0	write	sf	extra_data	mcs_rate=18
603	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 50 1500 2 1000 true 1 0
609	sk4		ath0	read	sf	stats

611	sk2		ath0	write	mcs	rate	48
611	sk2		ath0	write	sf	reset	
611	sk4		ath0	write	sf	reset	
611	sk2		ath0	write	sf	extra_data	mcs_rate=24
613	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 50 1500 2 1000 true 1 0
619	sk4		ath0	read	sf	stats

621	sk2		ath0	write	mcs	rate	72
621	sk2		ath0	write	sf	reset	
621	sk4		ath0	write	sf	reset	
621	sk2		ath0	write	sf	extra_data	mcs_rate=36
623	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 50 1500 2 1000 true 1 0
629	sk4		ath0	read	sf	stats

631	sk2		ath0	write	mcs	rate	96
631	sk2		ath0	write	sf	reset	
631	sk4		ath0	write	sf	reset	
631	sk2		ath0	write	sf	extra_data	mcs_rate=48
633	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 50 1500 2 1000 true 1 0
639	sk4		ath0	read	sf	stats

641	sk2		ath0	write	mcs	rate	108
641	sk2		ath0	write	sf	reset	
641	sk4		ath0	write	sf	reset	
641	sk2		ath0	write	sf	extra_data	mcs_rate=54
643	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 50 1500 2 1000 true 1 0
649	sk4		ath0	read	sf	stats


# Probe link 2 - 5
651	sk2		ath0	write	mcs	rate	12
651	sk2		ath0	write	sf	reset	
651	sk5		ath0	write	sf	reset	
651	sk2		ath0	write	sf	extra_data	mcs_rate=6
653	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 50 1500 2 1000 true 1 0
659	sk5		ath0	read	sf	stats

661	sk2		ath0	write	mcs	rate	18
661	sk2		ath0	write	sf	reset	
661	sk5		ath0	write	sf	reset	
661	sk2		ath0	write	sf	extra_data	mcs_rate=9
663	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 50 1500 2 1000 true 1 0
669	sk5		ath0	read	sf	stats

671	sk2		ath0	write	mcs	rate	24
671	sk2		ath0	write	sf	reset	
671	sk5		ath0	write	sf	reset	
671	sk2		ath0	write	sf	extra_data	mcs_rate=12
673	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 50 1500 2 1000 true 1 0
679	sk5		ath0	read	sf	stats

681	sk2		ath0	write	mcs	rate	36
681	sk2		ath0	write	sf	reset	
681	sk5		ath0	write	sf	reset	
681	sk2		ath0	write	sf	extra_data	mcs_rate=18
683	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 50 1500 2 1000 true 1 0
689	sk5		ath0	read	sf	stats

691	sk2		ath0	write	mcs	rate	48
691	sk2		ath0	write	sf	reset	
691	sk5		ath0	write	sf	reset	
691	sk2		ath0	write	sf	extra_data	mcs_rate=24
693	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 50 1500 2 1000 true 1 0
699	sk5		ath0	read	sf	stats

701	sk2		ath0	write	mcs	rate	72
701	sk2		ath0	write	sf	reset	
701	sk5		ath0	write	sf	reset	
701	sk2		ath0	write	sf	extra_data	mcs_rate=36
703	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 50 1500 2 1000 true 1 0
709	sk5		ath0	read	sf	stats

711	sk2		ath0	write	mcs	rate	96
711	sk2		ath0	write	sf	reset	
711	sk5		ath0	write	sf	reset	
711	sk2		ath0	write	sf	extra_data	mcs_rate=48
713	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 50 1500 2 1000 true 1 0
719	sk5		ath0	read	sf	stats

721	sk2		ath0	write	mcs	rate	108
721	sk2		ath0	write	sf	reset	
721	sk5		ath0	write	sf	reset	
721	sk2		ath0	write	sf	extra_data	mcs_rate=54
723	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 50 1500 2 1000 true 1 0
729	sk5		ath0	read	sf	stats


# Probe link 2 - 6
731	sk2		ath0	write	mcs	rate	12
731	sk2		ath0	write	sf	reset	
731	sk6		ath0	write	sf	reset	
731	sk2		ath0	write	sf	extra_data	mcs_rate=6
733	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 50 1500 2 1000 true 1 0
739	sk6		ath0	read	sf	stats

741	sk2		ath0	write	mcs	rate	18
741	sk2		ath0	write	sf	reset	
741	sk6		ath0	write	sf	reset	
741	sk2		ath0	write	sf	extra_data	mcs_rate=9
743	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 50 1500 2 1000 true 1 0
749	sk6		ath0	read	sf	stats

751	sk2		ath0	write	mcs	rate	24
751	sk2		ath0	write	sf	reset	
751	sk6		ath0	write	sf	reset	
751	sk2		ath0	write	sf	extra_data	mcs_rate=12
753	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 50 1500 2 1000 true 1 0
759	sk6		ath0	read	sf	stats

761	sk2		ath0	write	mcs	rate	36
761	sk2		ath0	write	sf	reset	
761	sk6		ath0	write	sf	reset	
761	sk2		ath0	write	sf	extra_data	mcs_rate=18
763	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 50 1500 2 1000 true 1 0
769	sk6		ath0	read	sf	stats

771	sk2		ath0	write	mcs	rate	48
771	sk2		ath0	write	sf	reset	
771	sk6		ath0	write	sf	reset	
771	sk2		ath0	write	sf	extra_data	mcs_rate=24
773	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 50 1500 2 1000 true 1 0
779	sk6		ath0	read	sf	stats

781	sk2		ath0	write	mcs	rate	72
781	sk2		ath0	write	sf	reset	
781	sk6		ath0	write	sf	reset	
781	sk2		ath0	write	sf	extra_data	mcs_rate=36
783	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 50 1500 2 1000 true 1 0
789	sk6		ath0	read	sf	stats

791	sk2		ath0	write	mcs	rate	96
791	sk2		ath0	write	sf	reset	
791	sk6		ath0	write	sf	reset	
791	sk2		ath0	write	sf	extra_data	mcs_rate=48
793	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 50 1500 2 1000 true 1 0
799	sk6		ath0	read	sf	stats

801	sk2		ath0	write	mcs	rate	108
801	sk2		ath0	write	sf	reset	
801	sk6		ath0	write	sf	reset	
801	sk2		ath0	write	sf	extra_data	mcs_rate=54
803	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 50 1500 2 1000 true 1 0
809	sk6		ath0	read	sf	stats


# Probe link 3 - 1
811	sk3		ath0	write	mcs	rate	12
811	sk3		ath0	write	sf	reset	
811	sk1		ath0	write	sf	reset	
811	sk3		ath0	write	sf	extra_data	mcs_rate=6
813	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
819	sk1		ath0	read	sf	stats

821	sk3		ath0	write	mcs	rate	18
821	sk3		ath0	write	sf	reset	
821	sk1		ath0	write	sf	reset	
821	sk3		ath0	write	sf	extra_data	mcs_rate=9
823	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
829	sk1		ath0	read	sf	stats

831	sk3		ath0	write	mcs	rate	24
831	sk3		ath0	write	sf	reset	
831	sk1		ath0	write	sf	reset	
831	sk3		ath0	write	sf	extra_data	mcs_rate=12
833	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
839	sk1		ath0	read	sf	stats

841	sk3		ath0	write	mcs	rate	36
841	sk3		ath0	write	sf	reset	
841	sk1		ath0	write	sf	reset	
841	sk3		ath0	write	sf	extra_data	mcs_rate=18
843	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
849	sk1		ath0	read	sf	stats

851	sk3		ath0	write	mcs	rate	48
851	sk3		ath0	write	sf	reset	
851	sk1		ath0	write	sf	reset	
851	sk3		ath0	write	sf	extra_data	mcs_rate=24
853	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
859	sk1		ath0	read	sf	stats

861	sk3		ath0	write	mcs	rate	72
861	sk3		ath0	write	sf	reset	
861	sk1		ath0	write	sf	reset	
861	sk3		ath0	write	sf	extra_data	mcs_rate=36
863	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
869	sk1		ath0	read	sf	stats

871	sk3		ath0	write	mcs	rate	96
871	sk3		ath0	write	sf	reset	
871	sk1		ath0	write	sf	reset	
871	sk3		ath0	write	sf	extra_data	mcs_rate=48
873	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
879	sk1		ath0	read	sf	stats

881	sk3		ath0	write	mcs	rate	108
881	sk3		ath0	write	sf	reset	
881	sk1		ath0	write	sf	reset	
881	sk3		ath0	write	sf	extra_data	mcs_rate=54
883	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
889	sk1		ath0	read	sf	stats


# Probe link 3 - 2
891	sk3		ath0	write	mcs	rate	12
891	sk3		ath0	write	sf	reset	
891	sk2		ath0	write	sf	reset	
891	sk3		ath0	write	sf	extra_data	mcs_rate=6
893	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
899	sk2		ath0	read	sf	stats

901	sk3		ath0	write	mcs	rate	18
901	sk3		ath0	write	sf	reset	
901	sk2		ath0	write	sf	reset	
901	sk3		ath0	write	sf	extra_data	mcs_rate=9
903	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
909	sk2		ath0	read	sf	stats

911	sk3		ath0	write	mcs	rate	24
911	sk3		ath0	write	sf	reset	
911	sk2		ath0	write	sf	reset	
911	sk3		ath0	write	sf	extra_data	mcs_rate=12
913	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
919	sk2		ath0	read	sf	stats

921	sk3		ath0	write	mcs	rate	36
921	sk3		ath0	write	sf	reset	
921	sk2		ath0	write	sf	reset	
921	sk3		ath0	write	sf	extra_data	mcs_rate=18
923	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
929	sk2		ath0	read	sf	stats

931	sk3		ath0	write	mcs	rate	48
931	sk3		ath0	write	sf	reset	
931	sk2		ath0	write	sf	reset	
931	sk3		ath0	write	sf	extra_data	mcs_rate=24
933	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
939	sk2		ath0	read	sf	stats

941	sk3		ath0	write	mcs	rate	72
941	sk3		ath0	write	sf	reset	
941	sk2		ath0	write	sf	reset	
941	sk3		ath0	write	sf	extra_data	mcs_rate=36
943	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
949	sk2		ath0	read	sf	stats

951	sk3		ath0	write	mcs	rate	96
951	sk3		ath0	write	sf	reset	
951	sk2		ath0	write	sf	reset	
951	sk3		ath0	write	sf	extra_data	mcs_rate=48
953	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
959	sk2		ath0	read	sf	stats

961	sk3		ath0	write	mcs	rate	108
961	sk3		ath0	write	sf	reset	
961	sk2		ath0	write	sf	reset	
961	sk3		ath0	write	sf	extra_data	mcs_rate=54
963	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
969	sk2		ath0	read	sf	stats


# Probe link 3 - 4
971	sk3		ath0	write	mcs	rate	12
971	sk3		ath0	write	sf	reset	
971	sk4		ath0	write	sf	reset	
971	sk3		ath0	write	sf	extra_data	mcs_rate=6
973	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 50 1500 2 1000 true 1 0
979	sk4		ath0	read	sf	stats

981	sk3		ath0	write	mcs	rate	18
981	sk3		ath0	write	sf	reset	
981	sk4		ath0	write	sf	reset	
981	sk3		ath0	write	sf	extra_data	mcs_rate=9
983	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 50 1500 2 1000 true 1 0
989	sk4		ath0	read	sf	stats

991	sk3		ath0	write	mcs	rate	24
991	sk3		ath0	write	sf	reset	
991	sk4		ath0	write	sf	reset	
991	sk3		ath0	write	sf	extra_data	mcs_rate=12
993	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 50 1500 2 1000 true 1 0
999	sk4		ath0	read	sf	stats

1001	sk3		ath0	write	mcs	rate	36
1001	sk3		ath0	write	sf	reset	
1001	sk4		ath0	write	sf	reset	
1001	sk3		ath0	write	sf	extra_data	mcs_rate=18
1003	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 50 1500 2 1000 true 1 0
1009	sk4		ath0	read	sf	stats

1011	sk3		ath0	write	mcs	rate	48
1011	sk3		ath0	write	sf	reset	
1011	sk4		ath0	write	sf	reset	
1011	sk3		ath0	write	sf	extra_data	mcs_rate=24
1013	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 50 1500 2 1000 true 1 0
1019	sk4		ath0	read	sf	stats

1021	sk3		ath0	write	mcs	rate	72
1021	sk3		ath0	write	sf	reset	
1021	sk4		ath0	write	sf	reset	
1021	sk3		ath0	write	sf	extra_data	mcs_rate=36
1023	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 50 1500 2 1000 true 1 0
1029	sk4		ath0	read	sf	stats

1031	sk3		ath0	write	mcs	rate	96
1031	sk3		ath0	write	sf	reset	
1031	sk4		ath0	write	sf	reset	
1031	sk3		ath0	write	sf	extra_data	mcs_rate=48
1033	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 50 1500 2 1000 true 1 0
1039	sk4		ath0	read	sf	stats

1041	sk3		ath0	write	mcs	rate	108
1041	sk3		ath0	write	sf	reset	
1041	sk4		ath0	write	sf	reset	
1041	sk3		ath0	write	sf	extra_data	mcs_rate=54
1043	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 50 1500 2 1000 true 1 0
1049	sk4		ath0	read	sf	stats


# Probe link 3 - 5
1051	sk3		ath0	write	mcs	rate	12
1051	sk3		ath0	write	sf	reset	
1051	sk5		ath0	write	sf	reset	
1051	sk3		ath0	write	sf	extra_data	mcs_rate=6
1053	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 50 1500 2 1000 true 1 0
1059	sk5		ath0	read	sf	stats

1061	sk3		ath0	write	mcs	rate	18
1061	sk3		ath0	write	sf	reset	
1061	sk5		ath0	write	sf	reset	
1061	sk3		ath0	write	sf	extra_data	mcs_rate=9
1063	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 50 1500 2 1000 true 1 0
1069	sk5		ath0	read	sf	stats

1071	sk3		ath0	write	mcs	rate	24
1071	sk3		ath0	write	sf	reset	
1071	sk5		ath0	write	sf	reset	
1071	sk3		ath0	write	sf	extra_data	mcs_rate=12
1073	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 50 1500 2 1000 true 1 0
1079	sk5		ath0	read	sf	stats

1081	sk3		ath0	write	mcs	rate	36
1081	sk3		ath0	write	sf	reset	
1081	sk5		ath0	write	sf	reset	
1081	sk3		ath0	write	sf	extra_data	mcs_rate=18
1083	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 50 1500 2 1000 true 1 0
1089	sk5		ath0	read	sf	stats

1091	sk3		ath0	write	mcs	rate	48
1091	sk3		ath0	write	sf	reset	
1091	sk5		ath0	write	sf	reset	
1091	sk3		ath0	write	sf	extra_data	mcs_rate=24
1093	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 50 1500 2 1000 true 1 0
1099	sk5		ath0	read	sf	stats

1101	sk3		ath0	write	mcs	rate	72
1101	sk3		ath0	write	sf	reset	
1101	sk5		ath0	write	sf	reset	
1101	sk3		ath0	write	sf	extra_data	mcs_rate=36
1103	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 50 1500 2 1000 true 1 0
1109	sk5		ath0	read	sf	stats

1111	sk3		ath0	write	mcs	rate	96
1111	sk3		ath0	write	sf	reset	
1111	sk5		ath0	write	sf	reset	
1111	sk3		ath0	write	sf	extra_data	mcs_rate=48
1113	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 50 1500 2 1000 true 1 0
1119	sk5		ath0	read	sf	stats

1121	sk3		ath0	write	mcs	rate	108
1121	sk3		ath0	write	sf	reset	
1121	sk5		ath0	write	sf	reset	
1121	sk3		ath0	write	sf	extra_data	mcs_rate=54
1123	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 50 1500 2 1000 true 1 0
1129	sk5		ath0	read	sf	stats


# Probe link 3 - 6
1131	sk3		ath0	write	mcs	rate	12
1131	sk3		ath0	write	sf	reset	
1131	sk6		ath0	write	sf	reset	
1131	sk3		ath0	write	sf	extra_data	mcs_rate=6
1133	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 50 1500 2 1000 true 1 0
1139	sk6		ath0	read	sf	stats

1141	sk3		ath0	write	mcs	rate	18
1141	sk3		ath0	write	sf	reset	
1141	sk6		ath0	write	sf	reset	
1141	sk3		ath0	write	sf	extra_data	mcs_rate=9
1143	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 50 1500 2 1000 true 1 0
1149	sk6		ath0	read	sf	stats

1151	sk3		ath0	write	mcs	rate	24
1151	sk3		ath0	write	sf	reset	
1151	sk6		ath0	write	sf	reset	
1151	sk3		ath0	write	sf	extra_data	mcs_rate=12
1153	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 50 1500 2 1000 true 1 0
1159	sk6		ath0	read	sf	stats

1161	sk3		ath0	write	mcs	rate	36
1161	sk3		ath0	write	sf	reset	
1161	sk6		ath0	write	sf	reset	
1161	sk3		ath0	write	sf	extra_data	mcs_rate=18
1163	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 50 1500 2 1000 true 1 0
1169	sk6		ath0	read	sf	stats

1171	sk3		ath0	write	mcs	rate	48
1171	sk3		ath0	write	sf	reset	
1171	sk6		ath0	write	sf	reset	
1171	sk3		ath0	write	sf	extra_data	mcs_rate=24
1173	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 50 1500 2 1000 true 1 0
1179	sk6		ath0	read	sf	stats

1181	sk3		ath0	write	mcs	rate	72
1181	sk3		ath0	write	sf	reset	
1181	sk6		ath0	write	sf	reset	
1181	sk3		ath0	write	sf	extra_data	mcs_rate=36
1183	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 50 1500 2 1000 true 1 0
1189	sk6		ath0	read	sf	stats

1191	sk3		ath0	write	mcs	rate	96
1191	sk3		ath0	write	sf	reset	
1191	sk6		ath0	write	sf	reset	
1191	sk3		ath0	write	sf	extra_data	mcs_rate=48
1193	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 50 1500 2 1000 true 1 0
1199	sk6		ath0	read	sf	stats

1201	sk3		ath0	write	mcs	rate	108
1201	sk3		ath0	write	sf	reset	
1201	sk6		ath0	write	sf	reset	
1201	sk3		ath0	write	sf	extra_data	mcs_rate=54
1203	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 50 1500 2 1000 true 1 0
1209	sk6		ath0	read	sf	stats


# Probe link 4 - 1
1211	sk4		ath0	write	mcs	rate	12
1211	sk4		ath0	write	sf	reset	
1211	sk1		ath0	write	sf	reset	
1211	sk4		ath0	write	sf	extra_data	mcs_rate=6
1213	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 50 1500 2 1000 true 1 0
1219	sk1		ath0	read	sf	stats

1221	sk4		ath0	write	mcs	rate	18
1221	sk4		ath0	write	sf	reset	
1221	sk1		ath0	write	sf	reset	
1221	sk4		ath0	write	sf	extra_data	mcs_rate=9
1223	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 50 1500 2 1000 true 1 0
1229	sk1		ath0	read	sf	stats

1231	sk4		ath0	write	mcs	rate	24
1231	sk4		ath0	write	sf	reset	
1231	sk1		ath0	write	sf	reset	
1231	sk4		ath0	write	sf	extra_data	mcs_rate=12
1233	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 50 1500 2 1000 true 1 0
1239	sk1		ath0	read	sf	stats

1241	sk4		ath0	write	mcs	rate	36
1241	sk4		ath0	write	sf	reset	
1241	sk1		ath0	write	sf	reset	
1241	sk4		ath0	write	sf	extra_data	mcs_rate=18
1243	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 50 1500 2 1000 true 1 0
1249	sk1		ath0	read	sf	stats

1251	sk4		ath0	write	mcs	rate	48
1251	sk4		ath0	write	sf	reset	
1251	sk1		ath0	write	sf	reset	
1251	sk4		ath0	write	sf	extra_data	mcs_rate=24
1253	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 50 1500 2 1000 true 1 0
1259	sk1		ath0	read	sf	stats

1261	sk4		ath0	write	mcs	rate	72
1261	sk4		ath0	write	sf	reset	
1261	sk1		ath0	write	sf	reset	
1261	sk4		ath0	write	sf	extra_data	mcs_rate=36
1263	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 50 1500 2 1000 true 1 0
1269	sk1		ath0	read	sf	stats

1271	sk4		ath0	write	mcs	rate	96
1271	sk4		ath0	write	sf	reset	
1271	sk1		ath0	write	sf	reset	
1271	sk4		ath0	write	sf	extra_data	mcs_rate=48
1273	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 50 1500 2 1000 true 1 0
1279	sk1		ath0	read	sf	stats

1281	sk4		ath0	write	mcs	rate	108
1281	sk4		ath0	write	sf	reset	
1281	sk1		ath0	write	sf	reset	
1281	sk4		ath0	write	sf	extra_data	mcs_rate=54
1283	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 50 1500 2 1000 true 1 0
1289	sk1		ath0	read	sf	stats


# Probe link 4 - 2
1291	sk4		ath0	write	mcs	rate	12
1291	sk4		ath0	write	sf	reset	
1291	sk2		ath0	write	sf	reset	
1291	sk4		ath0	write	sf	extra_data	mcs_rate=6
1293	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 50 1500 2 1000 true 1 0
1299	sk2		ath0	read	sf	stats

1301	sk4		ath0	write	mcs	rate	18
1301	sk4		ath0	write	sf	reset	
1301	sk2		ath0	write	sf	reset	
1301	sk4		ath0	write	sf	extra_data	mcs_rate=9
1303	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 50 1500 2 1000 true 1 0
1309	sk2		ath0	read	sf	stats

1311	sk4		ath0	write	mcs	rate	24
1311	sk4		ath0	write	sf	reset	
1311	sk2		ath0	write	sf	reset	
1311	sk4		ath0	write	sf	extra_data	mcs_rate=12
1313	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 50 1500 2 1000 true 1 0
1319	sk2		ath0	read	sf	stats

1321	sk4		ath0	write	mcs	rate	36
1321	sk4		ath0	write	sf	reset	
1321	sk2		ath0	write	sf	reset	
1321	sk4		ath0	write	sf	extra_data	mcs_rate=18
1323	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 50 1500 2 1000 true 1 0
1329	sk2		ath0	read	sf	stats

1331	sk4		ath0	write	mcs	rate	48
1331	sk4		ath0	write	sf	reset	
1331	sk2		ath0	write	sf	reset	
1331	sk4		ath0	write	sf	extra_data	mcs_rate=24
1333	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 50 1500 2 1000 true 1 0
1339	sk2		ath0	read	sf	stats

1341	sk4		ath0	write	mcs	rate	72
1341	sk4		ath0	write	sf	reset	
1341	sk2		ath0	write	sf	reset	
1341	sk4		ath0	write	sf	extra_data	mcs_rate=36
1343	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 50 1500 2 1000 true 1 0
1349	sk2		ath0	read	sf	stats

1351	sk4		ath0	write	mcs	rate	96
1351	sk4		ath0	write	sf	reset	
1351	sk2		ath0	write	sf	reset	
1351	sk4		ath0	write	sf	extra_data	mcs_rate=48
1353	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 50 1500 2 1000 true 1 0
1359	sk2		ath0	read	sf	stats

1361	sk4		ath0	write	mcs	rate	108
1361	sk4		ath0	write	sf	reset	
1361	sk2		ath0	write	sf	reset	
1361	sk4		ath0	write	sf	extra_data	mcs_rate=54
1363	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 50 1500 2 1000 true 1 0
1369	sk2		ath0	read	sf	stats


# Probe link 4 - 3
1371	sk4		ath0	write	mcs	rate	12
1371	sk4		ath0	write	sf	reset	
1371	sk3		ath0	write	sf	reset	
1371	sk4		ath0	write	sf	extra_data	mcs_rate=6
1373	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 50 1500 2 1000 true 1 0
1379	sk3		ath0	read	sf	stats

1381	sk4		ath0	write	mcs	rate	18
1381	sk4		ath0	write	sf	reset	
1381	sk3		ath0	write	sf	reset	
1381	sk4		ath0	write	sf	extra_data	mcs_rate=9
1383	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 50 1500 2 1000 true 1 0
1389	sk3		ath0	read	sf	stats

1391	sk4		ath0	write	mcs	rate	24
1391	sk4		ath0	write	sf	reset	
1391	sk3		ath0	write	sf	reset	
1391	sk4		ath0	write	sf	extra_data	mcs_rate=12
1393	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 50 1500 2 1000 true 1 0
1399	sk3		ath0	read	sf	stats

1401	sk4		ath0	write	mcs	rate	36
1401	sk4		ath0	write	sf	reset	
1401	sk3		ath0	write	sf	reset	
1401	sk4		ath0	write	sf	extra_data	mcs_rate=18
1403	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 50 1500 2 1000 true 1 0
1409	sk3		ath0	read	sf	stats

1411	sk4		ath0	write	mcs	rate	48
1411	sk4		ath0	write	sf	reset	
1411	sk3		ath0	write	sf	reset	
1411	sk4		ath0	write	sf	extra_data	mcs_rate=24
1413	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 50 1500 2 1000 true 1 0
1419	sk3		ath0	read	sf	stats

1421	sk4		ath0	write	mcs	rate	72
1421	sk4		ath0	write	sf	reset	
1421	sk3		ath0	write	sf	reset	
1421	sk4		ath0	write	sf	extra_data	mcs_rate=36
1423	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 50 1500 2 1000 true 1 0
1429	sk3		ath0	read	sf	stats

1431	sk4		ath0	write	mcs	rate	96
1431	sk4		ath0	write	sf	reset	
1431	sk3		ath0	write	sf	reset	
1431	sk4		ath0	write	sf	extra_data	mcs_rate=48
1433	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 50 1500 2 1000 true 1 0
1439	sk3		ath0	read	sf	stats

1441	sk4		ath0	write	mcs	rate	108
1441	sk4		ath0	write	sf	reset	
1441	sk3		ath0	write	sf	reset	
1441	sk4		ath0	write	sf	extra_data	mcs_rate=54
1443	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 50 1500 2 1000 true 1 0
1449	sk3		ath0	read	sf	stats


# Probe link 4 - 5
1451	sk4		ath0	write	mcs	rate	12
1451	sk4		ath0	write	sf	reset	
1451	sk5		ath0	write	sf	reset	
1451	sk4		ath0	write	sf	extra_data	mcs_rate=6
1453	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 50 1500 2 1000 true 1 0
1459	sk5		ath0	read	sf	stats

1461	sk4		ath0	write	mcs	rate	18
1461	sk4		ath0	write	sf	reset	
1461	sk5		ath0	write	sf	reset	
1461	sk4		ath0	write	sf	extra_data	mcs_rate=9
1463	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 50 1500 2 1000 true 1 0
1469	sk5		ath0	read	sf	stats

1471	sk4		ath0	write	mcs	rate	24
1471	sk4		ath0	write	sf	reset	
1471	sk5		ath0	write	sf	reset	
1471	sk4		ath0	write	sf	extra_data	mcs_rate=12
1473	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 50 1500 2 1000 true 1 0
1479	sk5		ath0	read	sf	stats

1481	sk4		ath0	write	mcs	rate	36
1481	sk4		ath0	write	sf	reset	
1481	sk5		ath0	write	sf	reset	
1481	sk4		ath0	write	sf	extra_data	mcs_rate=18
1483	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 50 1500 2 1000 true 1 0
1489	sk5		ath0	read	sf	stats

1491	sk4		ath0	write	mcs	rate	48
1491	sk4		ath0	write	sf	reset	
1491	sk5		ath0	write	sf	reset	
1491	sk4		ath0	write	sf	extra_data	mcs_rate=24
1493	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 50 1500 2 1000 true 1 0
1499	sk5		ath0	read	sf	stats

1501	sk4		ath0	write	mcs	rate	72
1501	sk4		ath0	write	sf	reset	
1501	sk5		ath0	write	sf	reset	
1501	sk4		ath0	write	sf	extra_data	mcs_rate=36
1503	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 50 1500 2 1000 true 1 0
1509	sk5		ath0	read	sf	stats

1511	sk4		ath0	write	mcs	rate	96
1511	sk4		ath0	write	sf	reset	
1511	sk5		ath0	write	sf	reset	
1511	sk4		ath0	write	sf	extra_data	mcs_rate=48
1513	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 50 1500 2 1000 true 1 0
1519	sk5		ath0	read	sf	stats

1521	sk4		ath0	write	mcs	rate	108
1521	sk4		ath0	write	sf	reset	
1521	sk5		ath0	write	sf	reset	
1521	sk4		ath0	write	sf	extra_data	mcs_rate=54
1523	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 50 1500 2 1000 true 1 0
1529	sk5		ath0	read	sf	stats


# Probe link 4 - 6
1531	sk4		ath0	write	mcs	rate	12
1531	sk4		ath0	write	sf	reset	
1531	sk6		ath0	write	sf	reset	
1531	sk4		ath0	write	sf	extra_data	mcs_rate=6
1533	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 50 1500 2 1000 true 1 0
1539	sk6		ath0	read	sf	stats

1541	sk4		ath0	write	mcs	rate	18
1541	sk4		ath0	write	sf	reset	
1541	sk6		ath0	write	sf	reset	
1541	sk4		ath0	write	sf	extra_data	mcs_rate=9
1543	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 50 1500 2 1000 true 1 0
1549	sk6		ath0	read	sf	stats

1551	sk4		ath0	write	mcs	rate	24
1551	sk4		ath0	write	sf	reset	
1551	sk6		ath0	write	sf	reset	
1551	sk4		ath0	write	sf	extra_data	mcs_rate=12
1553	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 50 1500 2 1000 true 1 0
1559	sk6		ath0	read	sf	stats

1561	sk4		ath0	write	mcs	rate	36
1561	sk4		ath0	write	sf	reset	
1561	sk6		ath0	write	sf	reset	
1561	sk4		ath0	write	sf	extra_data	mcs_rate=18
1563	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 50 1500 2 1000 true 1 0
1569	sk6		ath0	read	sf	stats

1571	sk4		ath0	write	mcs	rate	48
1571	sk4		ath0	write	sf	reset	
1571	sk6		ath0	write	sf	reset	
1571	sk4		ath0	write	sf	extra_data	mcs_rate=24
1573	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 50 1500 2 1000 true 1 0
1579	sk6		ath0	read	sf	stats

1581	sk4		ath0	write	mcs	rate	72
1581	sk4		ath0	write	sf	reset	
1581	sk6		ath0	write	sf	reset	
1581	sk4		ath0	write	sf	extra_data	mcs_rate=36
1583	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 50 1500 2 1000 true 1 0
1589	sk6		ath0	read	sf	stats

1591	sk4		ath0	write	mcs	rate	96
1591	sk4		ath0	write	sf	reset	
1591	sk6		ath0	write	sf	reset	
1591	sk4		ath0	write	sf	extra_data	mcs_rate=48
1593	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 50 1500 2 1000 true 1 0
1599	sk6		ath0	read	sf	stats

1601	sk4		ath0	write	mcs	rate	108
1601	sk4		ath0	write	sf	reset	
1601	sk6		ath0	write	sf	reset	
1601	sk4		ath0	write	sf	extra_data	mcs_rate=54
1603	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 50 1500 2 1000 true 1 0
1609	sk6		ath0	read	sf	stats


# Probe link 5 - 1
1611	sk5		ath0	write	mcs	rate	12
1611	sk5		ath0	write	sf	reset	
1611	sk1		ath0	write	sf	reset	
1611	sk5		ath0	write	sf	extra_data	mcs_rate=6
1613	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 50 1500 2 1000 true 1 0
1619	sk1		ath0	read	sf	stats

1621	sk5		ath0	write	mcs	rate	18
1621	sk5		ath0	write	sf	reset	
1621	sk1		ath0	write	sf	reset	
1621	sk5		ath0	write	sf	extra_data	mcs_rate=9
1623	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 50 1500 2 1000 true 1 0
1629	sk1		ath0	read	sf	stats

1631	sk5		ath0	write	mcs	rate	24
1631	sk5		ath0	write	sf	reset	
1631	sk1		ath0	write	sf	reset	
1631	sk5		ath0	write	sf	extra_data	mcs_rate=12
1633	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 50 1500 2 1000 true 1 0
1639	sk1		ath0	read	sf	stats

1641	sk5		ath0	write	mcs	rate	36
1641	sk5		ath0	write	sf	reset	
1641	sk1		ath0	write	sf	reset	
1641	sk5		ath0	write	sf	extra_data	mcs_rate=18
1643	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 50 1500 2 1000 true 1 0
1649	sk1		ath0	read	sf	stats

1651	sk5		ath0	write	mcs	rate	48
1651	sk5		ath0	write	sf	reset	
1651	sk1		ath0	write	sf	reset	
1651	sk5		ath0	write	sf	extra_data	mcs_rate=24
1653	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 50 1500 2 1000 true 1 0
1659	sk1		ath0	read	sf	stats

1661	sk5		ath0	write	mcs	rate	72
1661	sk5		ath0	write	sf	reset	
1661	sk1		ath0	write	sf	reset	
1661	sk5		ath0	write	sf	extra_data	mcs_rate=36
1663	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 50 1500 2 1000 true 1 0
1669	sk1		ath0	read	sf	stats

1671	sk5		ath0	write	mcs	rate	96
1671	sk5		ath0	write	sf	reset	
1671	sk1		ath0	write	sf	reset	
1671	sk5		ath0	write	sf	extra_data	mcs_rate=48
1673	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 50 1500 2 1000 true 1 0
1679	sk1		ath0	read	sf	stats

1681	sk5		ath0	write	mcs	rate	108
1681	sk5		ath0	write	sf	reset	
1681	sk1		ath0	write	sf	reset	
1681	sk5		ath0	write	sf	extra_data	mcs_rate=54
1683	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 50 1500 2 1000 true 1 0
1689	sk1		ath0	read	sf	stats


# Probe link 5 - 2
1691	sk5		ath0	write	mcs	rate	12
1691	sk5		ath0	write	sf	reset	
1691	sk2		ath0	write	sf	reset	
1691	sk5		ath0	write	sf	extra_data	mcs_rate=6
1693	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 50 1500 2 1000 true 1 0
1699	sk2		ath0	read	sf	stats

1701	sk5		ath0	write	mcs	rate	18
1701	sk5		ath0	write	sf	reset	
1701	sk2		ath0	write	sf	reset	
1701	sk5		ath0	write	sf	extra_data	mcs_rate=9
1703	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 50 1500 2 1000 true 1 0
1709	sk2		ath0	read	sf	stats

1711	sk5		ath0	write	mcs	rate	24
1711	sk5		ath0	write	sf	reset	
1711	sk2		ath0	write	sf	reset	
1711	sk5		ath0	write	sf	extra_data	mcs_rate=12
1713	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 50 1500 2 1000 true 1 0
1719	sk2		ath0	read	sf	stats

1721	sk5		ath0	write	mcs	rate	36
1721	sk5		ath0	write	sf	reset	
1721	sk2		ath0	write	sf	reset	
1721	sk5		ath0	write	sf	extra_data	mcs_rate=18
1723	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 50 1500 2 1000 true 1 0
1729	sk2		ath0	read	sf	stats

1731	sk5		ath0	write	mcs	rate	48
1731	sk5		ath0	write	sf	reset	
1731	sk2		ath0	write	sf	reset	
1731	sk5		ath0	write	sf	extra_data	mcs_rate=24
1733	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 50 1500 2 1000 true 1 0
1739	sk2		ath0	read	sf	stats

1741	sk5		ath0	write	mcs	rate	72
1741	sk5		ath0	write	sf	reset	
1741	sk2		ath0	write	sf	reset	
1741	sk5		ath0	write	sf	extra_data	mcs_rate=36
1743	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 50 1500 2 1000 true 1 0
1749	sk2		ath0	read	sf	stats

1751	sk5		ath0	write	mcs	rate	96
1751	sk5		ath0	write	sf	reset	
1751	sk2		ath0	write	sf	reset	
1751	sk5		ath0	write	sf	extra_data	mcs_rate=48
1753	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 50 1500 2 1000 true 1 0
1759	sk2		ath0	read	sf	stats

1761	sk5		ath0	write	mcs	rate	108
1761	sk5		ath0	write	sf	reset	
1761	sk2		ath0	write	sf	reset	
1761	sk5		ath0	write	sf	extra_data	mcs_rate=54
1763	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 50 1500 2 1000 true 1 0
1769	sk2		ath0	read	sf	stats


# Probe link 5 - 3
1771	sk5		ath0	write	mcs	rate	12
1771	sk5		ath0	write	sf	reset	
1771	sk3		ath0	write	sf	reset	
1771	sk5		ath0	write	sf	extra_data	mcs_rate=6
1773	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 50 1500 2 1000 true 1 0
1779	sk3		ath0	read	sf	stats

1781	sk5		ath0	write	mcs	rate	18
1781	sk5		ath0	write	sf	reset	
1781	sk3		ath0	write	sf	reset	
1781	sk5		ath0	write	sf	extra_data	mcs_rate=9
1783	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 50 1500 2 1000 true 1 0
1789	sk3		ath0	read	sf	stats

1791	sk5		ath0	write	mcs	rate	24
1791	sk5		ath0	write	sf	reset	
1791	sk3		ath0	write	sf	reset	
1791	sk5		ath0	write	sf	extra_data	mcs_rate=12
1793	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 50 1500 2 1000 true 1 0
1799	sk3		ath0	read	sf	stats

1801	sk5		ath0	write	mcs	rate	36
1801	sk5		ath0	write	sf	reset	
1801	sk3		ath0	write	sf	reset	
1801	sk5		ath0	write	sf	extra_data	mcs_rate=18
1803	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 50 1500 2 1000 true 1 0
1809	sk3		ath0	read	sf	stats

1811	sk5		ath0	write	mcs	rate	48
1811	sk5		ath0	write	sf	reset	
1811	sk3		ath0	write	sf	reset	
1811	sk5		ath0	write	sf	extra_data	mcs_rate=24
1813	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 50 1500 2 1000 true 1 0
1819	sk3		ath0	read	sf	stats

1821	sk5		ath0	write	mcs	rate	72
1821	sk5		ath0	write	sf	reset	
1821	sk3		ath0	write	sf	reset	
1821	sk5		ath0	write	sf	extra_data	mcs_rate=36
1823	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 50 1500 2 1000 true 1 0
1829	sk3		ath0	read	sf	stats

1831	sk5		ath0	write	mcs	rate	96
1831	sk5		ath0	write	sf	reset	
1831	sk3		ath0	write	sf	reset	
1831	sk5		ath0	write	sf	extra_data	mcs_rate=48
1833	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 50 1500 2 1000 true 1 0
1839	sk3		ath0	read	sf	stats

1841	sk5		ath0	write	mcs	rate	108
1841	sk5		ath0	write	sf	reset	
1841	sk3		ath0	write	sf	reset	
1841	sk5		ath0	write	sf	extra_data	mcs_rate=54
1843	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 50 1500 2 1000 true 1 0
1849	sk3		ath0	read	sf	stats


# Probe link 5 - 4
1851	sk5		ath0	write	mcs	rate	12
1851	sk5		ath0	write	sf	reset	
1851	sk4		ath0	write	sf	reset	
1851	sk5		ath0	write	sf	extra_data	mcs_rate=6
1853	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 50 1500 2 1000 true 1 0
1859	sk4		ath0	read	sf	stats

1861	sk5		ath0	write	mcs	rate	18
1861	sk5		ath0	write	sf	reset	
1861	sk4		ath0	write	sf	reset	
1861	sk5		ath0	write	sf	extra_data	mcs_rate=9
1863	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 50 1500 2 1000 true 1 0
1869	sk4		ath0	read	sf	stats

1871	sk5		ath0	write	mcs	rate	24
1871	sk5		ath0	write	sf	reset	
1871	sk4		ath0	write	sf	reset	
1871	sk5		ath0	write	sf	extra_data	mcs_rate=12
1873	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 50 1500 2 1000 true 1 0
1879	sk4		ath0	read	sf	stats

1881	sk5		ath0	write	mcs	rate	36
1881	sk5		ath0	write	sf	reset	
1881	sk4		ath0	write	sf	reset	
1881	sk5		ath0	write	sf	extra_data	mcs_rate=18
1883	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 50 1500 2 1000 true 1 0
1889	sk4		ath0	read	sf	stats

1891	sk5		ath0	write	mcs	rate	48
1891	sk5		ath0	write	sf	reset	
1891	sk4		ath0	write	sf	reset	
1891	sk5		ath0	write	sf	extra_data	mcs_rate=24
1893	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 50 1500 2 1000 true 1 0
1899	sk4		ath0	read	sf	stats

1901	sk5		ath0	write	mcs	rate	72
1901	sk5		ath0	write	sf	reset	
1901	sk4		ath0	write	sf	reset	
1901	sk5		ath0	write	sf	extra_data	mcs_rate=36
1903	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 50 1500 2 1000 true 1 0
1909	sk4		ath0	read	sf	stats

1911	sk5		ath0	write	mcs	rate	96
1911	sk5		ath0	write	sf	reset	
1911	sk4		ath0	write	sf	reset	
1911	sk5		ath0	write	sf	extra_data	mcs_rate=48
1913	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 50 1500 2 1000 true 1 0
1919	sk4		ath0	read	sf	stats

1921	sk5		ath0	write	mcs	rate	108
1921	sk5		ath0	write	sf	reset	
1921	sk4		ath0	write	sf	reset	
1921	sk5		ath0	write	sf	extra_data	mcs_rate=54
1923	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 50 1500 2 1000 true 1 0
1929	sk4		ath0	read	sf	stats


# Probe link 5 - 6
1931	sk5		ath0	write	mcs	rate	12
1931	sk5		ath0	write	sf	reset	
1931	sk6		ath0	write	sf	reset	
1931	sk5		ath0	write	sf	extra_data	mcs_rate=6
1933	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 50 1500 2 1000 true 1 0
1939	sk6		ath0	read	sf	stats

1941	sk5		ath0	write	mcs	rate	18
1941	sk5		ath0	write	sf	reset	
1941	sk6		ath0	write	sf	reset	
1941	sk5		ath0	write	sf	extra_data	mcs_rate=9
1943	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 50 1500 2 1000 true 1 0
1949	sk6		ath0	read	sf	stats

1951	sk5		ath0	write	mcs	rate	24
1951	sk5		ath0	write	sf	reset	
1951	sk6		ath0	write	sf	reset	
1951	sk5		ath0	write	sf	extra_data	mcs_rate=12
1953	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 50 1500 2 1000 true 1 0
1959	sk6		ath0	read	sf	stats

1961	sk5		ath0	write	mcs	rate	36
1961	sk5		ath0	write	sf	reset	
1961	sk6		ath0	write	sf	reset	
1961	sk5		ath0	write	sf	extra_data	mcs_rate=18
1963	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 50 1500 2 1000 true 1 0
1969	sk6		ath0	read	sf	stats

1971	sk5		ath0	write	mcs	rate	48
1971	sk5		ath0	write	sf	reset	
1971	sk6		ath0	write	sf	reset	
1971	sk5		ath0	write	sf	extra_data	mcs_rate=24
1973	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 50 1500 2 1000 true 1 0
1979	sk6		ath0	read	sf	stats

1981	sk5		ath0	write	mcs	rate	72
1981	sk5		ath0	write	sf	reset	
1981	sk6		ath0	write	sf	reset	
1981	sk5		ath0	write	sf	extra_data	mcs_rate=36
1983	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 50 1500 2 1000 true 1 0
1989	sk6		ath0	read	sf	stats

1991	sk5		ath0	write	mcs	rate	96
1991	sk5		ath0	write	sf	reset	
1991	sk6		ath0	write	sf	reset	
1991	sk5		ath0	write	sf	extra_data	mcs_rate=48
1993	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 50 1500 2 1000 true 1 0
1999	sk6		ath0	read	sf	stats

2001	sk5		ath0	write	mcs	rate	108
2001	sk5		ath0	write	sf	reset	
2001	sk6		ath0	write	sf	reset	
2001	sk5		ath0	write	sf	extra_data	mcs_rate=54
2003	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 50 1500 2 1000 true 1 0
2009	sk6		ath0	read	sf	stats


# Probe link 6 - 1
2011	sk6		ath0	write	mcs	rate	12
2011	sk6		ath0	write	sf	reset	
2011	sk1		ath0	write	sf	reset	
2011	sk6		ath0	write	sf	extra_data	mcs_rate=6
2013	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 50 1500 2 1000 true 1 0
2019	sk1		ath0	read	sf	stats

2021	sk6		ath0	write	mcs	rate	18
2021	sk6		ath0	write	sf	reset	
2021	sk1		ath0	write	sf	reset	
2021	sk6		ath0	write	sf	extra_data	mcs_rate=9
2023	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 50 1500 2 1000 true 1 0
2029	sk1		ath0	read	sf	stats

2031	sk6		ath0	write	mcs	rate	24
2031	sk6		ath0	write	sf	reset	
2031	sk1		ath0	write	sf	reset	
2031	sk6		ath0	write	sf	extra_data	mcs_rate=12
2033	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 50 1500 2 1000 true 1 0
2039	sk1		ath0	read	sf	stats

2041	sk6		ath0	write	mcs	rate	36
2041	sk6		ath0	write	sf	reset	
2041	sk1		ath0	write	sf	reset	
2041	sk6		ath0	write	sf	extra_data	mcs_rate=18
2043	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 50 1500 2 1000 true 1 0
2049	sk1		ath0	read	sf	stats

2051	sk6		ath0	write	mcs	rate	48
2051	sk6		ath0	write	sf	reset	
2051	sk1		ath0	write	sf	reset	
2051	sk6		ath0	write	sf	extra_data	mcs_rate=24
2053	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 50 1500 2 1000 true 1 0
2059	sk1		ath0	read	sf	stats

2061	sk6		ath0	write	mcs	rate	72
2061	sk6		ath0	write	sf	reset	
2061	sk1		ath0	write	sf	reset	
2061	sk6		ath0	write	sf	extra_data	mcs_rate=36
2063	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 50 1500 2 1000 true 1 0
2069	sk1		ath0	read	sf	stats

2071	sk6		ath0	write	mcs	rate	96
2071	sk6		ath0	write	sf	reset	
2071	sk1		ath0	write	sf	reset	
2071	sk6		ath0	write	sf	extra_data	mcs_rate=48
2073	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 50 1500 2 1000 true 1 0
2079	sk1		ath0	read	sf	stats

2081	sk6		ath0	write	mcs	rate	108
2081	sk6		ath0	write	sf	reset	
2081	sk1		ath0	write	sf	reset	
2081	sk6		ath0	write	sf	extra_data	mcs_rate=54
2083	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 50 1500 2 1000 true 1 0
2089	sk1		ath0	read	sf	stats


# Probe link 6 - 2
2091	sk6		ath0	write	mcs	rate	12
2091	sk6		ath0	write	sf	reset	
2091	sk2		ath0	write	sf	reset	
2091	sk6		ath0	write	sf	extra_data	mcs_rate=6
2093	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 50 1500 2 1000 true 1 0
2099	sk2		ath0	read	sf	stats

2101	sk6		ath0	write	mcs	rate	18
2101	sk6		ath0	write	sf	reset	
2101	sk2		ath0	write	sf	reset	
2101	sk6		ath0	write	sf	extra_data	mcs_rate=9
2103	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 50 1500 2 1000 true 1 0
2109	sk2		ath0	read	sf	stats

2111	sk6		ath0	write	mcs	rate	24
2111	sk6		ath0	write	sf	reset	
2111	sk2		ath0	write	sf	reset	
2111	sk6		ath0	write	sf	extra_data	mcs_rate=12
2113	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 50 1500 2 1000 true 1 0
2119	sk2		ath0	read	sf	stats

2121	sk6		ath0	write	mcs	rate	36
2121	sk6		ath0	write	sf	reset	
2121	sk2		ath0	write	sf	reset	
2121	sk6		ath0	write	sf	extra_data	mcs_rate=18
2123	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 50 1500 2 1000 true 1 0
2129	sk2		ath0	read	sf	stats

2131	sk6		ath0	write	mcs	rate	48
2131	sk6		ath0	write	sf	reset	
2131	sk2		ath0	write	sf	reset	
2131	sk6		ath0	write	sf	extra_data	mcs_rate=24
2133	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 50 1500 2 1000 true 1 0
2139	sk2		ath0	read	sf	stats

2141	sk6		ath0	write	mcs	rate	72
2141	sk6		ath0	write	sf	reset	
2141	sk2		ath0	write	sf	reset	
2141	sk6		ath0	write	sf	extra_data	mcs_rate=36
2143	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 50 1500 2 1000 true 1 0
2149	sk2		ath0	read	sf	stats

2151	sk6		ath0	write	mcs	rate	96
2151	sk6		ath0	write	sf	reset	
2151	sk2		ath0	write	sf	reset	
2151	sk6		ath0	write	sf	extra_data	mcs_rate=48
2153	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 50 1500 2 1000 true 1 0
2159	sk2		ath0	read	sf	stats

2161	sk6		ath0	write	mcs	rate	108
2161	sk6		ath0	write	sf	reset	
2161	sk2		ath0	write	sf	reset	
2161	sk6		ath0	write	sf	extra_data	mcs_rate=54
2163	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 50 1500 2 1000 true 1 0
2169	sk2		ath0	read	sf	stats


# Probe link 6 - 3
2171	sk6		ath0	write	mcs	rate	12
2171	sk6		ath0	write	sf	reset	
2171	sk3		ath0	write	sf	reset	
2171	sk6		ath0	write	sf	extra_data	mcs_rate=6
2173	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 50 1500 2 1000 true 1 0
2179	sk3		ath0	read	sf	stats

2181	sk6		ath0	write	mcs	rate	18
2181	sk6		ath0	write	sf	reset	
2181	sk3		ath0	write	sf	reset	
2181	sk6		ath0	write	sf	extra_data	mcs_rate=9
2183	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 50 1500 2 1000 true 1 0
2189	sk3		ath0	read	sf	stats

2191	sk6		ath0	write	mcs	rate	24
2191	sk6		ath0	write	sf	reset	
2191	sk3		ath0	write	sf	reset	
2191	sk6		ath0	write	sf	extra_data	mcs_rate=12
2193	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 50 1500 2 1000 true 1 0
2199	sk3		ath0	read	sf	stats

2201	sk6		ath0	write	mcs	rate	36
2201	sk6		ath0	write	sf	reset	
2201	sk3		ath0	write	sf	reset	
2201	sk6		ath0	write	sf	extra_data	mcs_rate=18
2203	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 50 1500 2 1000 true 1 0
2209	sk3		ath0	read	sf	stats

2211	sk6		ath0	write	mcs	rate	48
2211	sk6		ath0	write	sf	reset	
2211	sk3		ath0	write	sf	reset	
2211	sk6		ath0	write	sf	extra_data	mcs_rate=24
2213	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 50 1500 2 1000 true 1 0
2219	sk3		ath0	read	sf	stats

2221	sk6		ath0	write	mcs	rate	72
2221	sk6		ath0	write	sf	reset	
2221	sk3		ath0	write	sf	reset	
2221	sk6		ath0	write	sf	extra_data	mcs_rate=36
2223	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 50 1500 2 1000 true 1 0
2229	sk3		ath0	read	sf	stats

2231	sk6		ath0	write	mcs	rate	96
2231	sk6		ath0	write	sf	reset	
2231	sk3		ath0	write	sf	reset	
2231	sk6		ath0	write	sf	extra_data	mcs_rate=48
2233	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 50 1500 2 1000 true 1 0
2239	sk3		ath0	read	sf	stats

2241	sk6		ath0	write	mcs	rate	108
2241	sk6		ath0	write	sf	reset	
2241	sk3		ath0	write	sf	reset	
2241	sk6		ath0	write	sf	extra_data	mcs_rate=54
2243	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 50 1500 2 1000 true 1 0
2249	sk3		ath0	read	sf	stats


# Probe link 6 - 4
2251	sk6		ath0	write	mcs	rate	12
2251	sk6		ath0	write	sf	reset	
2251	sk4		ath0	write	sf	reset	
2251	sk6		ath0	write	sf	extra_data	mcs_rate=6
2253	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 50 1500 2 1000 true 1 0
2259	sk4		ath0	read	sf	stats

2261	sk6		ath0	write	mcs	rate	18
2261	sk6		ath0	write	sf	reset	
2261	sk4		ath0	write	sf	reset	
2261	sk6		ath0	write	sf	extra_data	mcs_rate=9
2263	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 50 1500 2 1000 true 1 0
2269	sk4		ath0	read	sf	stats

2271	sk6		ath0	write	mcs	rate	24
2271	sk6		ath0	write	sf	reset	
2271	sk4		ath0	write	sf	reset	
2271	sk6		ath0	write	sf	extra_data	mcs_rate=12
2273	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 50 1500 2 1000 true 1 0
2279	sk4		ath0	read	sf	stats

2281	sk6		ath0	write	mcs	rate	36
2281	sk6		ath0	write	sf	reset	
2281	sk4		ath0	write	sf	reset	
2281	sk6		ath0	write	sf	extra_data	mcs_rate=18
2283	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 50 1500 2 1000 true 1 0
2289	sk4		ath0	read	sf	stats

2291	sk6		ath0	write	mcs	rate	48
2291	sk6		ath0	write	sf	reset	
2291	sk4		ath0	write	sf	reset	
2291	sk6		ath0	write	sf	extra_data	mcs_rate=24
2293	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 50 1500 2 1000 true 1 0
2299	sk4		ath0	read	sf	stats

2301	sk6		ath0	write	mcs	rate	72
2301	sk6		ath0	write	sf	reset	
2301	sk4		ath0	write	sf	reset	
2301	sk6		ath0	write	sf	extra_data	mcs_rate=36
2303	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 50 1500 2 1000 true 1 0
2309	sk4		ath0	read	sf	stats

2311	sk6		ath0	write	mcs	rate	96
2311	sk6		ath0	write	sf	reset	
2311	sk4		ath0	write	sf	reset	
2311	sk6		ath0	write	sf	extra_data	mcs_rate=48
2313	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 50 1500 2 1000 true 1 0
2319	sk4		ath0	read	sf	stats

2321	sk6		ath0	write	mcs	rate	108
2321	sk6		ath0	write	sf	reset	
2321	sk4		ath0	write	sf	reset	
2321	sk6		ath0	write	sf	extra_data	mcs_rate=54
2323	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 50 1500 2 1000 true 1 0
2329	sk4		ath0	read	sf	stats


# Probe link 6 - 5
2331	sk6		ath0	write	mcs	rate	12
2331	sk6		ath0	write	sf	reset	
2331	sk5		ath0	write	sf	reset	
2331	sk6		ath0	write	sf	extra_data	mcs_rate=6
2333	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 50 1500 2 1000 true 1 0
2339	sk5		ath0	read	sf	stats

2341	sk6		ath0	write	mcs	rate	18
2341	sk6		ath0	write	sf	reset	
2341	sk5		ath0	write	sf	reset	
2341	sk6		ath0	write	sf	extra_data	mcs_rate=9
2343	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 50 1500 2 1000 true 1 0
2349	sk5		ath0	read	sf	stats

2351	sk6		ath0	write	mcs	rate	24
2351	sk6		ath0	write	sf	reset	
2351	sk5		ath0	write	sf	reset	
2351	sk6		ath0	write	sf	extra_data	mcs_rate=12
2353	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 50 1500 2 1000 true 1 0
2359	sk5		ath0	read	sf	stats

2361	sk6		ath0	write	mcs	rate	36
2361	sk6		ath0	write	sf	reset	
2361	sk5		ath0	write	sf	reset	
2361	sk6		ath0	write	sf	extra_data	mcs_rate=18
2363	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 50 1500 2 1000 true 1 0
2369	sk5		ath0	read	sf	stats

2371	sk6		ath0	write	mcs	rate	48
2371	sk6		ath0	write	sf	reset	
2371	sk5		ath0	write	sf	reset	
2371	sk6		ath0	write	sf	extra_data	mcs_rate=24
2373	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 50 1500 2 1000 true 1 0
2379	sk5		ath0	read	sf	stats

2381	sk6		ath0	write	mcs	rate	72
2381	sk6		ath0	write	sf	reset	
2381	sk5		ath0	write	sf	reset	
2381	sk6		ath0	write	sf	extra_data	mcs_rate=36
2383	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 50 1500 2 1000 true 1 0
2389	sk5		ath0	read	sf	stats

2391	sk6		ath0	write	mcs	rate	96
2391	sk6		ath0	write	sf	reset	
2391	sk5		ath0	write	sf	reset	
2391	sk6		ath0	write	sf	extra_data	mcs_rate=48
2393	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 50 1500 2 1000 true 1 0
2399	sk5		ath0	read	sf	stats

2401	sk6		ath0	write	mcs	rate	108
2401	sk6		ath0	write	sf	reset	
2401	sk5		ath0	write	sf	reset	
2401	sk6		ath0	write	sf	extra_data	mcs_rate=54
2403	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 50 1500 2 1000 true 1 0
2409	sk5		ath0	read	sf	stats


