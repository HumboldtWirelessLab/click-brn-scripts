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
21	sk1		ath0	write	sf	reset	
21	sk2		ath0	write	sf	reset	
21	sk1		ath0	write	sf	extra_data	mcs_rate=6
23	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
29	sk2		ath0	read	sf	stats

31	sk1		ath0	write	mcs	rate	18
31	sk1		ath0	write	sf	reset	
31	sk2		ath0	write	sf	reset	
31	sk1		ath0	write	sf	extra_data	mcs_rate=9
33	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
39	sk2		ath0	read	sf	stats

41	sk1		ath0	write	mcs	rate	24
41	sk1		ath0	write	sf	reset	
41	sk2		ath0	write	sf	reset	
41	sk1		ath0	write	sf	extra_data	mcs_rate=12
43	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
49	sk2		ath0	read	sf	stats

51	sk1		ath0	write	mcs	rate	36
51	sk1		ath0	write	sf	reset	
51	sk2		ath0	write	sf	reset	
51	sk1		ath0	write	sf	extra_data	mcs_rate=18
53	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
59	sk2		ath0	read	sf	stats

61	sk1		ath0	write	mcs	rate	48
61	sk1		ath0	write	sf	reset	
61	sk2		ath0	write	sf	reset	
61	sk1		ath0	write	sf	extra_data	mcs_rate=24
63	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
69	sk2		ath0	read	sf	stats

71	sk1		ath0	write	mcs	rate	72
71	sk1		ath0	write	sf	reset	
71	sk2		ath0	write	sf	reset	
71	sk1		ath0	write	sf	extra_data	mcs_rate=36
73	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
79	sk2		ath0	read	sf	stats

81	sk1		ath0	write	mcs	rate	96
81	sk1		ath0	write	sf	reset	
81	sk2		ath0	write	sf	reset	
81	sk1		ath0	write	sf	extra_data	mcs_rate=48
83	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
89	sk2		ath0	read	sf	stats

91	sk1		ath0	write	mcs	rate	108
91	sk1		ath0	write	sf	reset	
91	sk2		ath0	write	sf	reset	
91	sk1		ath0	write	sf	extra_data	mcs_rate=54
93	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 1500 2 1000 true 1 0
99	sk2		ath0	read	sf	stats


# Probe link 1 - 3
101	sk1		ath0	write	mcs	rate	12
101	sk1		ath0	write	sf	reset	
101	sk3		ath0	write	sf	reset	
101	sk1		ath0	write	sf	extra_data	mcs_rate=6
103	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0
109	sk3		ath0	read	sf	stats

111	sk1		ath0	write	mcs	rate	18
111	sk1		ath0	write	sf	reset	
111	sk3		ath0	write	sf	reset	
111	sk1		ath0	write	sf	extra_data	mcs_rate=9
113	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0
119	sk3		ath0	read	sf	stats

121	sk1		ath0	write	mcs	rate	24
121	sk1		ath0	write	sf	reset	
121	sk3		ath0	write	sf	reset	
121	sk1		ath0	write	sf	extra_data	mcs_rate=12
123	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0
129	sk3		ath0	read	sf	stats

131	sk1		ath0	write	mcs	rate	36
131	sk1		ath0	write	sf	reset	
131	sk3		ath0	write	sf	reset	
131	sk1		ath0	write	sf	extra_data	mcs_rate=18
133	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0
139	sk3		ath0	read	sf	stats

141	sk1		ath0	write	mcs	rate	48
141	sk1		ath0	write	sf	reset	
141	sk3		ath0	write	sf	reset	
141	sk1		ath0	write	sf	extra_data	mcs_rate=24
143	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0
149	sk3		ath0	read	sf	stats

151	sk1		ath0	write	mcs	rate	72
151	sk1		ath0	write	sf	reset	
151	sk3		ath0	write	sf	reset	
151	sk1		ath0	write	sf	extra_data	mcs_rate=36
153	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0
159	sk3		ath0	read	sf	stats

161	sk1		ath0	write	mcs	rate	96
161	sk1		ath0	write	sf	reset	
161	sk3		ath0	write	sf	reset	
161	sk1		ath0	write	sf	extra_data	mcs_rate=48
163	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0
169	sk3		ath0	read	sf	stats

171	sk1		ath0	write	mcs	rate	108
171	sk1		ath0	write	sf	reset	
171	sk3		ath0	write	sf	reset	
171	sk1		ath0	write	sf	extra_data	mcs_rate=54
173	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 1500 2 1000 true 1 0
179	sk3		ath0	read	sf	stats


# Probe link 2 - 1
181	sk2		ath0	write	mcs	rate	12
181	sk2		ath0	write	sf	reset	
181	sk1		ath0	write	sf	reset	
181	sk2		ath0	write	sf	extra_data	mcs_rate=6
183	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
189	sk1		ath0	read	sf	stats

191	sk2		ath0	write	mcs	rate	18
191	sk2		ath0	write	sf	reset	
191	sk1		ath0	write	sf	reset	
191	sk2		ath0	write	sf	extra_data	mcs_rate=9
193	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
199	sk1		ath0	read	sf	stats

201	sk2		ath0	write	mcs	rate	24
201	sk2		ath0	write	sf	reset	
201	sk1		ath0	write	sf	reset	
201	sk2		ath0	write	sf	extra_data	mcs_rate=12
203	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
209	sk1		ath0	read	sf	stats

211	sk2		ath0	write	mcs	rate	36
211	sk2		ath0	write	sf	reset	
211	sk1		ath0	write	sf	reset	
211	sk2		ath0	write	sf	extra_data	mcs_rate=18
213	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
219	sk1		ath0	read	sf	stats

221	sk2		ath0	write	mcs	rate	48
221	sk2		ath0	write	sf	reset	
221	sk1		ath0	write	sf	reset	
221	sk2		ath0	write	sf	extra_data	mcs_rate=24
223	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
229	sk1		ath0	read	sf	stats

231	sk2		ath0	write	mcs	rate	72
231	sk2		ath0	write	sf	reset	
231	sk1		ath0	write	sf	reset	
231	sk2		ath0	write	sf	extra_data	mcs_rate=36
233	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
239	sk1		ath0	read	sf	stats

241	sk2		ath0	write	mcs	rate	96
241	sk2		ath0	write	sf	reset	
241	sk1		ath0	write	sf	reset	
241	sk2		ath0	write	sf	extra_data	mcs_rate=48
243	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
249	sk1		ath0	read	sf	stats

251	sk2		ath0	write	mcs	rate	108
251	sk2		ath0	write	sf	reset	
251	sk1		ath0	write	sf	reset	
251	sk2		ath0	write	sf	extra_data	mcs_rate=54
253	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 1500 2 1000 true 1 0
259	sk1		ath0	read	sf	stats


# Probe link 2 - 3
261	sk2		ath0	write	mcs	rate	12
261	sk2		ath0	write	sf	reset	
261	sk3		ath0	write	sf	reset	
261	sk2		ath0	write	sf	extra_data	mcs_rate=6
263	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
269	sk3		ath0	read	sf	stats

271	sk2		ath0	write	mcs	rate	18
271	sk2		ath0	write	sf	reset	
271	sk3		ath0	write	sf	reset	
271	sk2		ath0	write	sf	extra_data	mcs_rate=9
273	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
279	sk3		ath0	read	sf	stats

281	sk2		ath0	write	mcs	rate	24
281	sk2		ath0	write	sf	reset	
281	sk3		ath0	write	sf	reset	
281	sk2		ath0	write	sf	extra_data	mcs_rate=12
283	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
289	sk3		ath0	read	sf	stats

291	sk2		ath0	write	mcs	rate	36
291	sk2		ath0	write	sf	reset	
291	sk3		ath0	write	sf	reset	
291	sk2		ath0	write	sf	extra_data	mcs_rate=18
293	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
299	sk3		ath0	read	sf	stats

301	sk2		ath0	write	mcs	rate	48
301	sk2		ath0	write	sf	reset	
301	sk3		ath0	write	sf	reset	
301	sk2		ath0	write	sf	extra_data	mcs_rate=24
303	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
309	sk3		ath0	read	sf	stats

311	sk2		ath0	write	mcs	rate	72
311	sk2		ath0	write	sf	reset	
311	sk3		ath0	write	sf	reset	
311	sk2		ath0	write	sf	extra_data	mcs_rate=36
313	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
319	sk3		ath0	read	sf	stats

321	sk2		ath0	write	mcs	rate	96
321	sk2		ath0	write	sf	reset	
321	sk3		ath0	write	sf	reset	
321	sk2		ath0	write	sf	extra_data	mcs_rate=48
323	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
329	sk3		ath0	read	sf	stats

331	sk2		ath0	write	mcs	rate	108
331	sk2		ath0	write	sf	reset	
331	sk3		ath0	write	sf	reset	
331	sk2		ath0	write	sf	extra_data	mcs_rate=54
333	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 1500 2 1000 true 1 0
339	sk3		ath0	read	sf	stats


# Probe link 3 - 1
341	sk3		ath0	write	mcs	rate	12
341	sk3		ath0	write	sf	reset	
341	sk1		ath0	write	sf	reset	
341	sk3		ath0	write	sf	extra_data	mcs_rate=6
343	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
349	sk1		ath0	read	sf	stats

351	sk3		ath0	write	mcs	rate	18
351	sk3		ath0	write	sf	reset	
351	sk1		ath0	write	sf	reset	
351	sk3		ath0	write	sf	extra_data	mcs_rate=9
353	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
359	sk1		ath0	read	sf	stats

361	sk3		ath0	write	mcs	rate	24
361	sk3		ath0	write	sf	reset	
361	sk1		ath0	write	sf	reset	
361	sk3		ath0	write	sf	extra_data	mcs_rate=12
363	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
369	sk1		ath0	read	sf	stats

371	sk3		ath0	write	mcs	rate	36
371	sk3		ath0	write	sf	reset	
371	sk1		ath0	write	sf	reset	
371	sk3		ath0	write	sf	extra_data	mcs_rate=18
373	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
379	sk1		ath0	read	sf	stats

381	sk3		ath0	write	mcs	rate	48
381	sk3		ath0	write	sf	reset	
381	sk1		ath0	write	sf	reset	
381	sk3		ath0	write	sf	extra_data	mcs_rate=24
383	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
389	sk1		ath0	read	sf	stats

391	sk3		ath0	write	mcs	rate	72
391	sk3		ath0	write	sf	reset	
391	sk1		ath0	write	sf	reset	
391	sk3		ath0	write	sf	extra_data	mcs_rate=36
393	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
399	sk1		ath0	read	sf	stats

401	sk3		ath0	write	mcs	rate	96
401	sk3		ath0	write	sf	reset	
401	sk1		ath0	write	sf	reset	
401	sk3		ath0	write	sf	extra_data	mcs_rate=48
403	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
409	sk1		ath0	read	sf	stats

411	sk3		ath0	write	mcs	rate	108
411	sk3		ath0	write	sf	reset	
411	sk1		ath0	write	sf	reset	
411	sk3		ath0	write	sf	extra_data	mcs_rate=54
413	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 1500 2 1000 true 1 0
419	sk1		ath0	read	sf	stats


# Probe link 3 - 2
421	sk3		ath0	write	mcs	rate	12
421	sk3		ath0	write	sf	reset	
421	sk2		ath0	write	sf	reset	
421	sk3		ath0	write	sf	extra_data	mcs_rate=6
423	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
429	sk2		ath0	read	sf	stats

431	sk3		ath0	write	mcs	rate	18
431	sk3		ath0	write	sf	reset	
431	sk2		ath0	write	sf	reset	
431	sk3		ath0	write	sf	extra_data	mcs_rate=9
433	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
439	sk2		ath0	read	sf	stats

441	sk3		ath0	write	mcs	rate	24
441	sk3		ath0	write	sf	reset	
441	sk2		ath0	write	sf	reset	
441	sk3		ath0	write	sf	extra_data	mcs_rate=12
443	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
449	sk2		ath0	read	sf	stats

451	sk3		ath0	write	mcs	rate	36
451	sk3		ath0	write	sf	reset	
451	sk2		ath0	write	sf	reset	
451	sk3		ath0	write	sf	extra_data	mcs_rate=18
453	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
459	sk2		ath0	read	sf	stats

461	sk3		ath0	write	mcs	rate	48
461	sk3		ath0	write	sf	reset	
461	sk2		ath0	write	sf	reset	
461	sk3		ath0	write	sf	extra_data	mcs_rate=24
463	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
469	sk2		ath0	read	sf	stats

471	sk3		ath0	write	mcs	rate	72
471	sk3		ath0	write	sf	reset	
471	sk2		ath0	write	sf	reset	
471	sk3		ath0	write	sf	extra_data	mcs_rate=36
473	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
479	sk2		ath0	read	sf	stats

481	sk3		ath0	write	mcs	rate	96
481	sk3		ath0	write	sf	reset	
481	sk2		ath0	write	sf	reset	
481	sk3		ath0	write	sf	extra_data	mcs_rate=48
483	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
489	sk2		ath0	read	sf	stats

491	sk3		ath0	write	mcs	rate	108
491	sk3		ath0	write	sf	reset	
491	sk2		ath0	write	sf	reset	
491	sk3		ath0	write	sf	extra_data	mcs_rate=54
493	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 1500 2 1000 true 1 0
499	sk2		ath0	read	sf	stats


