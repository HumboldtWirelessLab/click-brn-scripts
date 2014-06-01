#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE

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


# Get RSSI
10.0	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 200 2 90 true 1 0
10.1	sk1		ath0	write	sf	reset
10.1	sk2		ath0	read	device_wifi/wifidevice/cst	stats

11.0	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 200 2 90 true 1 0
11.1	sk1		ath0	write	sf	reset
11.1	sk3		ath0	read	device_wifi/wifidevice/cst	stats

12.0	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 200 2 90 true 1 0
12.1	sk2		ath0	write	sf	reset
12.1	sk1		ath0	read	device_wifi/wifidevice/cst	stats

13.0	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 200 2 90 true 1 0
13.1	sk2		ath0	write	sf	reset
13.1	sk3		ath0	read	device_wifi/wifidevice/cst	stats

14.0	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 200 2 90 true 1 0
14.1	sk3		ath0	write	sf	reset
14.1	sk1		ath0	read	device_wifi/wifidevice/cst	stats

15.0	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 200 2 90 true 1 0
15.1	sk3		ath0	write	sf	reset
15.1	sk2		ath0	read	device_wifi/wifidevice/cst	stats


# Probing with multiple rates for all variations
# Probe link 1 - 2
21	sk1		ath0	write	mcs	rate	12
21	sk1		ath0	read	mcs	rate	
21	sk1		ath0	write	sf	reset	
23	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0 mcs_rate=6
29	sk1		ath0	read	sf	stats

31	sk1		ath0	write	mcs	rate	18
31	sk1		ath0	read	mcs	rate	
31	sk1		ath0	write	sf	reset	
33	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0 mcs_rate=9
39	sk1		ath0	read	sf	stats

41	sk1		ath0	write	mcs	rate	24
41	sk1		ath0	read	mcs	rate	
41	sk1		ath0	write	sf	reset	
43	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0 mcs_rate=12
49	sk1		ath0	read	sf	stats

51	sk1		ath0	write	mcs	rate	36
51	sk1		ath0	read	mcs	rate	
51	sk1		ath0	write	sf	reset	
53	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0 mcs_rate=18
59	sk1		ath0	read	sf	stats

61	sk1		ath0	write	mcs	rate	48
61	sk1		ath0	read	mcs	rate	
61	sk1		ath0	write	sf	reset	
63	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0 mcs_rate=24
69	sk1		ath0	read	sf	stats

71	sk1		ath0	write	mcs	rate	72
71	sk1		ath0	read	mcs	rate	
71	sk1		ath0	write	sf	reset	
73	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0 mcs_rate=36
79	sk1		ath0	read	sf	stats

81	sk1		ath0	write	mcs	rate	96
81	sk1		ath0	read	mcs	rate	
81	sk1		ath0	write	sf	reset	
83	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0 mcs_rate=48
89	sk1		ath0	read	sf	stats

91	sk1		ath0	write	mcs	rate	108
91	sk1		ath0	read	mcs	rate	
91	sk1		ath0	write	sf	reset	
93	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0 mcs_rate=54
99	sk1		ath0	read	sf	stats


# Probe link 1 - 3
101	sk1		ath0	write	mcs	rate	12
101	sk1		ath0	read	mcs	rate	
101	sk1		ath0	write	sf	reset	
103	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0 mcs_rate=6
109	sk1		ath0	read	sf	stats

111	sk1		ath0	write	mcs	rate	18
111	sk1		ath0	read	mcs	rate	
111	sk1		ath0	write	sf	reset	
113	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0 mcs_rate=9
119	sk1		ath0	read	sf	stats

121	sk1		ath0	write	mcs	rate	24
121	sk1		ath0	read	mcs	rate	
121	sk1		ath0	write	sf	reset	
123	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0 mcs_rate=12
129	sk1		ath0	read	sf	stats

131	sk1		ath0	write	mcs	rate	36
131	sk1		ath0	read	mcs	rate	
131	sk1		ath0	write	sf	reset	
133	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0 mcs_rate=18
139	sk1		ath0	read	sf	stats

141	sk1		ath0	write	mcs	rate	48
141	sk1		ath0	read	mcs	rate	
141	sk1		ath0	write	sf	reset	
143	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0 mcs_rate=24
149	sk1		ath0	read	sf	stats

151	sk1		ath0	write	mcs	rate	72
151	sk1		ath0	read	mcs	rate	
151	sk1		ath0	write	sf	reset	
153	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0 mcs_rate=36
159	sk1		ath0	read	sf	stats

161	sk1		ath0	write	mcs	rate	96
161	sk1		ath0	read	mcs	rate	
161	sk1		ath0	write	sf	reset	
163	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0 mcs_rate=48
169	sk1		ath0	read	sf	stats

171	sk1		ath0	write	mcs	rate	108
171	sk1		ath0	read	mcs	rate	
171	sk1		ath0	write	sf	reset	
173	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0 mcs_rate=54
179	sk1		ath0	read	sf	stats


# Probe link 2 - 1
181	sk2		ath0	write	mcs	rate	12
181	sk2		ath0	read	mcs	rate	
181	sk2		ath0	write	sf	reset	
183	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0 mcs_rate=6
189	sk2		ath0	read	sf	stats

191	sk2		ath0	write	mcs	rate	18
191	sk2		ath0	read	mcs	rate	
191	sk2		ath0	write	sf	reset	
193	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0 mcs_rate=9
199	sk2		ath0	read	sf	stats

201	sk2		ath0	write	mcs	rate	24
201	sk2		ath0	read	mcs	rate	
201	sk2		ath0	write	sf	reset	
203	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0 mcs_rate=12
209	sk2		ath0	read	sf	stats

211	sk2		ath0	write	mcs	rate	36
211	sk2		ath0	read	mcs	rate	
211	sk2		ath0	write	sf	reset	
213	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0 mcs_rate=18
219	sk2		ath0	read	sf	stats

221	sk2		ath0	write	mcs	rate	48
221	sk2		ath0	read	mcs	rate	
221	sk2		ath0	write	sf	reset	
223	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0 mcs_rate=24
229	sk2		ath0	read	sf	stats

231	sk2		ath0	write	mcs	rate	72
231	sk2		ath0	read	mcs	rate	
231	sk2		ath0	write	sf	reset	
233	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0 mcs_rate=36
239	sk2		ath0	read	sf	stats

241	sk2		ath0	write	mcs	rate	96
241	sk2		ath0	read	mcs	rate	
241	sk2		ath0	write	sf	reset	
243	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0 mcs_rate=48
249	sk2		ath0	read	sf	stats

251	sk2		ath0	write	mcs	rate	108
251	sk2		ath0	read	mcs	rate	
251	sk2		ath0	write	sf	reset	
253	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0 mcs_rate=54
259	sk2		ath0	read	sf	stats


# Probe link 2 - 3
261	sk2		ath0	write	mcs	rate	12
261	sk2		ath0	read	mcs	rate	
261	sk2		ath0	write	sf	reset	
263	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0 mcs_rate=6
269	sk2		ath0	read	sf	stats

271	sk2		ath0	write	mcs	rate	18
271	sk2		ath0	read	mcs	rate	
271	sk2		ath0	write	sf	reset	
273	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0 mcs_rate=9
279	sk2		ath0	read	sf	stats

281	sk2		ath0	write	mcs	rate	24
281	sk2		ath0	read	mcs	rate	
281	sk2		ath0	write	sf	reset	
283	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0 mcs_rate=12
289	sk2		ath0	read	sf	stats

291	sk2		ath0	write	mcs	rate	36
291	sk2		ath0	read	mcs	rate	
291	sk2		ath0	write	sf	reset	
293	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0 mcs_rate=18
299	sk2		ath0	read	sf	stats

301	sk2		ath0	write	mcs	rate	48
301	sk2		ath0	read	mcs	rate	
301	sk2		ath0	write	sf	reset	
303	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0 mcs_rate=24
309	sk2		ath0	read	sf	stats

311	sk2		ath0	write	mcs	rate	72
311	sk2		ath0	read	mcs	rate	
311	sk2		ath0	write	sf	reset	
313	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0 mcs_rate=36
319	sk2		ath0	read	sf	stats

321	sk2		ath0	write	mcs	rate	96
321	sk2		ath0	read	mcs	rate	
321	sk2		ath0	write	sf	reset	
323	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0 mcs_rate=48
329	sk2		ath0	read	sf	stats

331	sk2		ath0	write	mcs	rate	108
331	sk2		ath0	read	mcs	rate	
331	sk2		ath0	write	sf	reset	
333	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0 mcs_rate=54
339	sk2		ath0	read	sf	stats


# Probe link 3 - 1
341	sk3		ath0	write	mcs	rate	12
341	sk3		ath0	read	mcs	rate	
341	sk3		ath0	write	sf	reset	
343	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0 mcs_rate=6
349	sk3		ath0	read	sf	stats

351	sk3		ath0	write	mcs	rate	18
351	sk3		ath0	read	mcs	rate	
351	sk3		ath0	write	sf	reset	
353	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0 mcs_rate=9
359	sk3		ath0	read	sf	stats

361	sk3		ath0	write	mcs	rate	24
361	sk3		ath0	read	mcs	rate	
361	sk3		ath0	write	sf	reset	
363	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0 mcs_rate=12
369	sk3		ath0	read	sf	stats

371	sk3		ath0	write	mcs	rate	36
371	sk3		ath0	read	mcs	rate	
371	sk3		ath0	write	sf	reset	
373	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0 mcs_rate=18
379	sk3		ath0	read	sf	stats

381	sk3		ath0	write	mcs	rate	48
381	sk3		ath0	read	mcs	rate	
381	sk3		ath0	write	sf	reset	
383	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0 mcs_rate=24
389	sk3		ath0	read	sf	stats

391	sk3		ath0	write	mcs	rate	72
391	sk3		ath0	read	mcs	rate	
391	sk3		ath0	write	sf	reset	
393	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0 mcs_rate=36
399	sk3		ath0	read	sf	stats

401	sk3		ath0	write	mcs	rate	96
401	sk3		ath0	read	mcs	rate	
401	sk3		ath0	write	sf	reset	
403	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0 mcs_rate=48
409	sk3		ath0	read	sf	stats

411	sk3		ath0	write	mcs	rate	108
411	sk3		ath0	read	mcs	rate	
411	sk3		ath0	write	sf	reset	
413	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0 mcs_rate=54
419	sk3		ath0	read	sf	stats


# Probe link 3 - 2
421	sk3		ath0	write	mcs	rate	12
421	sk3		ath0	read	mcs	rate	
421	sk3		ath0	write	sf	reset	
423	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0 mcs_rate=6
429	sk3		ath0	read	sf	stats

431	sk3		ath0	write	mcs	rate	18
431	sk3		ath0	read	mcs	rate	
431	sk3		ath0	write	sf	reset	
433	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0 mcs_rate=9
439	sk3		ath0	read	sf	stats

441	sk3		ath0	write	mcs	rate	24
441	sk3		ath0	read	mcs	rate	
441	sk3		ath0	write	sf	reset	
443	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0 mcs_rate=12
449	sk3		ath0	read	sf	stats

451	sk3		ath0	write	mcs	rate	36
451	sk3		ath0	read	mcs	rate	
451	sk3		ath0	write	sf	reset	
453	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0 mcs_rate=18
459	sk3		ath0	read	sf	stats

461	sk3		ath0	write	mcs	rate	48
461	sk3		ath0	read	mcs	rate	
461	sk3		ath0	write	sf	reset	
463	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0 mcs_rate=24
469	sk3		ath0	read	sf	stats

471	sk3		ath0	write	mcs	rate	72
471	sk3		ath0	read	mcs	rate	
471	sk3		ath0	write	sf	reset	
473	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0 mcs_rate=36
479	sk3		ath0	read	sf	stats

481	sk3		ath0	write	mcs	rate	96
481	sk3		ath0	read	mcs	rate	
481	sk3		ath0	write	sf	reset	
483	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0 mcs_rate=48
489	sk3		ath0	read	sf	stats

491	sk3		ath0	write	mcs	rate	108
491	sk3		ath0	read	mcs	rate	
491	sk3		ath0	write	sf	reset	
493	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0 mcs_rate=54
499	sk3		ath0	read	sf	stats


