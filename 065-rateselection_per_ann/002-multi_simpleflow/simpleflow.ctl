#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE

# Find hidden nodes by sending from each node to each other
2.0	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 3000 2 90 true 1 0
2.0	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 3000 2 90 true 1 0
2.0	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 3000 2 90 true 1 0
2.0	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 3000 2 90 true 1 0
2.0	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 3000 2 90 true 1 0
2.0	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 3000 2 90 true 1 0
3.0	sk1		ath0	read	sf	stats
3.0	sk2		ath0	read	sf	stats
3.0	sk3		ath0	read	sf	stats
3.1	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
3.1	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
3.1	sk3		ath0	read	device_wifi/wifidevice/hnd	stats


# Get RSSI
10.0	sk1		ath0	read	device_wifi/link_stat bcast_stats
10.0	sk2		ath0	read	device_wifi/link_stat bcast_stats
10.0	sk3		ath0	read	device_wifi/link_stat bcast_stats


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


# Probe link 2 - 1
171	sk2		ath0	write	mcs	rate	12
171	sk2		ath0	write	sf	reset	
171	sk1		ath0	write	sf	reset	
171	sk2		ath0	write	sf	extra_data	mcs_rate=6
173	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
179	sk1		ath0	read	sf	stats

181	sk2		ath0	write	mcs	rate	18
181	sk2		ath0	write	sf	reset	
181	sk1		ath0	write	sf	reset	
181	sk2		ath0	write	sf	extra_data	mcs_rate=9
183	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
189	sk1		ath0	read	sf	stats

191	sk2		ath0	write	mcs	rate	24
191	sk2		ath0	write	sf	reset	
191	sk1		ath0	write	sf	reset	
191	sk2		ath0	write	sf	extra_data	mcs_rate=12
193	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
199	sk1		ath0	read	sf	stats

201	sk2		ath0	write	mcs	rate	36
201	sk2		ath0	write	sf	reset	
201	sk1		ath0	write	sf	reset	
201	sk2		ath0	write	sf	extra_data	mcs_rate=18
203	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
209	sk1		ath0	read	sf	stats

211	sk2		ath0	write	mcs	rate	48
211	sk2		ath0	write	sf	reset	
211	sk1		ath0	write	sf	reset	
211	sk2		ath0	write	sf	extra_data	mcs_rate=24
213	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
219	sk1		ath0	read	sf	stats

221	sk2		ath0	write	mcs	rate	72
221	sk2		ath0	write	sf	reset	
221	sk1		ath0	write	sf	reset	
221	sk2		ath0	write	sf	extra_data	mcs_rate=36
223	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
229	sk1		ath0	read	sf	stats

231	sk2		ath0	write	mcs	rate	96
231	sk2		ath0	write	sf	reset	
231	sk1		ath0	write	sf	reset	
231	sk2		ath0	write	sf	extra_data	mcs_rate=48
233	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
239	sk1		ath0	read	sf	stats

241	sk2		ath0	write	mcs	rate	108
241	sk2		ath0	write	sf	reset	
241	sk1		ath0	write	sf	reset	
241	sk2		ath0	write	sf	extra_data	mcs_rate=54
243	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
249	sk1		ath0	read	sf	stats


# Probe link 2 - 3
251	sk2		ath0	write	mcs	rate	12
251	sk2		ath0	write	sf	reset	
251	sk3		ath0	write	sf	reset	
251	sk2		ath0	write	sf	extra_data	mcs_rate=6
253	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
259	sk3		ath0	read	sf	stats

261	sk2		ath0	write	mcs	rate	18
261	sk2		ath0	write	sf	reset	
261	sk3		ath0	write	sf	reset	
261	sk2		ath0	write	sf	extra_data	mcs_rate=9
263	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
269	sk3		ath0	read	sf	stats

271	sk2		ath0	write	mcs	rate	24
271	sk2		ath0	write	sf	reset	
271	sk3		ath0	write	sf	reset	
271	sk2		ath0	write	sf	extra_data	mcs_rate=12
273	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
279	sk3		ath0	read	sf	stats

281	sk2		ath0	write	mcs	rate	36
281	sk2		ath0	write	sf	reset	
281	sk3		ath0	write	sf	reset	
281	sk2		ath0	write	sf	extra_data	mcs_rate=18
283	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
289	sk3		ath0	read	sf	stats

291	sk2		ath0	write	mcs	rate	48
291	sk2		ath0	write	sf	reset	
291	sk3		ath0	write	sf	reset	
291	sk2		ath0	write	sf	extra_data	mcs_rate=24
293	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
299	sk3		ath0	read	sf	stats

301	sk2		ath0	write	mcs	rate	72
301	sk2		ath0	write	sf	reset	
301	sk3		ath0	write	sf	reset	
301	sk2		ath0	write	sf	extra_data	mcs_rate=36
303	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
309	sk3		ath0	read	sf	stats

311	sk2		ath0	write	mcs	rate	96
311	sk2		ath0	write	sf	reset	
311	sk3		ath0	write	sf	reset	
311	sk2		ath0	write	sf	extra_data	mcs_rate=48
313	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
319	sk3		ath0	read	sf	stats

321	sk2		ath0	write	mcs	rate	108
321	sk2		ath0	write	sf	reset	
321	sk3		ath0	write	sf	reset	
321	sk2		ath0	write	sf	extra_data	mcs_rate=54
323	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
329	sk3		ath0	read	sf	stats


# Probe link 3 - 1
331	sk3		ath0	write	mcs	rate	12
331	sk3		ath0	write	sf	reset	
331	sk1		ath0	write	sf	reset	
331	sk3		ath0	write	sf	extra_data	mcs_rate=6
333	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
339	sk1		ath0	read	sf	stats

341	sk3		ath0	write	mcs	rate	18
341	sk3		ath0	write	sf	reset	
341	sk1		ath0	write	sf	reset	
341	sk3		ath0	write	sf	extra_data	mcs_rate=9
343	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
349	sk1		ath0	read	sf	stats

351	sk3		ath0	write	mcs	rate	24
351	sk3		ath0	write	sf	reset	
351	sk1		ath0	write	sf	reset	
351	sk3		ath0	write	sf	extra_data	mcs_rate=12
353	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
359	sk1		ath0	read	sf	stats

361	sk3		ath0	write	mcs	rate	36
361	sk3		ath0	write	sf	reset	
361	sk1		ath0	write	sf	reset	
361	sk3		ath0	write	sf	extra_data	mcs_rate=18
363	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
369	sk1		ath0	read	sf	stats

371	sk3		ath0	write	mcs	rate	48
371	sk3		ath0	write	sf	reset	
371	sk1		ath0	write	sf	reset	
371	sk3		ath0	write	sf	extra_data	mcs_rate=24
373	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
379	sk1		ath0	read	sf	stats

381	sk3		ath0	write	mcs	rate	72
381	sk3		ath0	write	sf	reset	
381	sk1		ath0	write	sf	reset	
381	sk3		ath0	write	sf	extra_data	mcs_rate=36
383	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
389	sk1		ath0	read	sf	stats

391	sk3		ath0	write	mcs	rate	96
391	sk3		ath0	write	sf	reset	
391	sk1		ath0	write	sf	reset	
391	sk3		ath0	write	sf	extra_data	mcs_rate=48
393	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
399	sk1		ath0	read	sf	stats

401	sk3		ath0	write	mcs	rate	108
401	sk3		ath0	write	sf	reset	
401	sk1		ath0	write	sf	reset	
401	sk3		ath0	write	sf	extra_data	mcs_rate=54
403	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
409	sk1		ath0	read	sf	stats


# Probe link 3 - 2
411	sk3		ath0	write	mcs	rate	12
411	sk3		ath0	write	sf	reset	
411	sk2		ath0	write	sf	reset	
411	sk3		ath0	write	sf	extra_data	mcs_rate=6
413	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
419	sk2		ath0	read	sf	stats

421	sk3		ath0	write	mcs	rate	18
421	sk3		ath0	write	sf	reset	
421	sk2		ath0	write	sf	reset	
421	sk3		ath0	write	sf	extra_data	mcs_rate=9
423	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
429	sk2		ath0	read	sf	stats

431	sk3		ath0	write	mcs	rate	24
431	sk3		ath0	write	sf	reset	
431	sk2		ath0	write	sf	reset	
431	sk3		ath0	write	sf	extra_data	mcs_rate=12
433	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
439	sk2		ath0	read	sf	stats

441	sk3		ath0	write	mcs	rate	36
441	sk3		ath0	write	sf	reset	
441	sk2		ath0	write	sf	reset	
441	sk3		ath0	write	sf	extra_data	mcs_rate=18
443	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
449	sk2		ath0	read	sf	stats

451	sk3		ath0	write	mcs	rate	48
451	sk3		ath0	write	sf	reset	
451	sk2		ath0	write	sf	reset	
451	sk3		ath0	write	sf	extra_data	mcs_rate=24
453	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
459	sk2		ath0	read	sf	stats

461	sk3		ath0	write	mcs	rate	72
461	sk3		ath0	write	sf	reset	
461	sk2		ath0	write	sf	reset	
461	sk3		ath0	write	sf	extra_data	mcs_rate=36
463	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
469	sk2		ath0	read	sf	stats

471	sk3		ath0	write	mcs	rate	96
471	sk3		ath0	write	sf	reset	
471	sk2		ath0	write	sf	reset	
471	sk3		ath0	write	sf	extra_data	mcs_rate=48
473	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
479	sk2		ath0	read	sf	stats

481	sk3		ath0	write	mcs	rate	108
481	sk3		ath0	write	sf	reset	
481	sk2		ath0	write	sf	reset	
481	sk3		ath0	write	sf	extra_data	mcs_rate=54
483	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
489	sk2		ath0	read	sf	stats


