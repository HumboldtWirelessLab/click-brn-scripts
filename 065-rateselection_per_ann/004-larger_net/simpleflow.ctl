#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE

# Setup jammer
1	sk8 	ath0	write	sj	cca		-10 -5 10
1	sk8 	ath0	write	sj	jammer		true
# Find hidden nodes by sending from each node to each other
2.0	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 200 2 90 true 1 0
2.1	sk1		ath0	read	sf	stats
2.2	sk1		ath0	write	sf	reset
2.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
2.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
2.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
2.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
2.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
2.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

3.0	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 200 2 90 true 1 0
3.1	sk1		ath0	read	sf	stats
3.2	sk1		ath0	write	sf	reset
3.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
3.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
3.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
3.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
3.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
3.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

4.0	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 50 200 2 90 true 1 0
4.1	sk1		ath0	read	sf	stats
4.2	sk1		ath0	write	sf	reset
4.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
4.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
4.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
4.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
4.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
4.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

5.0	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 50 200 2 90 true 1 0
5.1	sk1		ath0	read	sf	stats
5.2	sk1		ath0	write	sf	reset
5.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
5.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
5.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
5.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
5.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
5.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

6.0	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 50 200 2 90 true 1 0
6.1	sk1		ath0	read	sf	stats
6.2	sk1		ath0	write	sf	reset
6.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
6.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
6.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
6.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
6.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
6.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

7.0	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 200 2 90 true 1 0
7.1	sk2		ath0	read	sf	stats
7.2	sk2		ath0	write	sf	reset
7.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
7.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
7.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
7.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
7.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
7.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

8.0	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 200 2 90 true 1 0
8.1	sk2		ath0	read	sf	stats
8.2	sk2		ath0	write	sf	reset
8.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
8.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
8.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
8.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
8.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
8.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

9.0	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 50 200 2 90 true 1 0
9.1	sk2		ath0	read	sf	stats
9.2	sk2		ath0	write	sf	reset
9.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
9.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
9.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
9.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
9.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
9.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

10.0	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 50 200 2 90 true 1 0
10.1	sk2		ath0	read	sf	stats
10.2	sk2		ath0	write	sf	reset
10.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
10.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
10.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
10.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
10.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
10.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

11.0	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 50 200 2 90 true 1 0
11.1	sk2		ath0	read	sf	stats
11.2	sk2		ath0	write	sf	reset
11.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
11.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
11.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
11.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
11.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
11.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

12.0	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 200 2 90 true 1 0
12.1	sk3		ath0	read	sf	stats
12.2	sk3		ath0	write	sf	reset
12.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
12.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
12.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
12.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
12.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
12.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

13.0	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 200 2 90 true 1 0
13.1	sk3		ath0	read	sf	stats
13.2	sk3		ath0	write	sf	reset
13.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
13.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
13.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
13.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
13.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
13.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

14.0	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 50 200 2 90 true 1 0
14.1	sk3		ath0	read	sf	stats
14.2	sk3		ath0	write	sf	reset
14.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
14.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
14.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
14.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
14.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
14.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

15.0	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 50 200 2 90 true 1 0
15.1	sk3		ath0	read	sf	stats
15.2	sk3		ath0	write	sf	reset
15.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
15.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
15.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
15.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
15.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
15.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

16.0	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 50 200 2 90 true 1 0
16.1	sk3		ath0	read	sf	stats
16.2	sk3		ath0	write	sf	reset
16.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
16.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
16.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
16.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
16.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
16.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

17.0	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 50 200 2 90 true 1 0
17.1	sk4		ath0	read	sf	stats
17.2	sk4		ath0	write	sf	reset
17.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
17.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
17.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
17.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
17.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
17.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

18.0	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 50 200 2 90 true 1 0
18.1	sk4		ath0	read	sf	stats
18.2	sk4		ath0	write	sf	reset
18.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
18.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
18.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
18.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
18.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
18.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

19.0	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 50 200 2 90 true 1 0
19.1	sk4		ath0	read	sf	stats
19.2	sk4		ath0	write	sf	reset
19.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
19.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
19.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
19.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
19.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
19.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

20.0	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 50 200 2 90 true 1 0
20.1	sk4		ath0	read	sf	stats
20.2	sk4		ath0	write	sf	reset
20.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
20.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
20.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
20.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
20.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
20.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

21.0	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 50 200 2 90 true 1 0
21.1	sk4		ath0	read	sf	stats
21.2	sk4		ath0	write	sf	reset
21.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
21.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
21.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
21.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
21.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
21.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

22.0	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 50 200 2 90 true 1 0
22.1	sk5		ath0	read	sf	stats
22.2	sk5		ath0	write	sf	reset
22.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
22.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
22.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
22.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
22.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
22.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

23.0	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 50 200 2 90 true 1 0
23.1	sk5		ath0	read	sf	stats
23.2	sk5		ath0	write	sf	reset
23.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
23.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
23.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
23.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
23.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
23.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

24.0	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 50 200 2 90 true 1 0
24.1	sk5		ath0	read	sf	stats
24.2	sk5		ath0	write	sf	reset
24.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
24.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
24.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
24.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
24.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
24.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

25.0	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 50 200 2 90 true 1 0
25.1	sk5		ath0	read	sf	stats
25.2	sk5		ath0	write	sf	reset
25.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
25.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
25.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
25.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
25.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
25.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

26.0	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 50 200 2 90 true 1 0
26.1	sk5		ath0	read	sf	stats
26.2	sk5		ath0	write	sf	reset
26.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
26.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
26.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
26.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
26.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
26.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

27.0	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 50 200 2 90 true 1 0
27.1	sk6		ath0	read	sf	stats
27.2	sk6		ath0	write	sf	reset
27.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
27.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
27.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
27.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
27.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
27.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

28.0	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 50 200 2 90 true 1 0
28.1	sk6		ath0	read	sf	stats
28.2	sk6		ath0	write	sf	reset
28.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
28.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
28.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
28.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
28.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
28.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

29.0	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 50 200 2 90 true 1 0
29.1	sk6		ath0	read	sf	stats
29.2	sk6		ath0	write	sf	reset
29.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
29.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
29.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
29.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
29.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
29.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

30.0	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 50 200 2 90 true 1 0
30.1	sk6		ath0	read	sf	stats
30.2	sk6		ath0	write	sf	reset
30.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
30.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
30.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
30.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
30.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
30.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats

31.0	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 50 200 2 90 true 1 0
31.1	sk6		ath0	read	sf	stats
31.2	sk6		ath0	write	sf	reset
31.2	sk1		ath0	read	device_wifi/wifidevice/hnd	stats
31.2	sk2		ath0	read	device_wifi/wifidevice/hnd	stats
31.2	sk3		ath0	read	device_wifi/wifidevice/hnd	stats
31.2	sk4		ath0	read	device_wifi/wifidevice/hnd	stats
31.2	sk5		ath0	read	device_wifi/wifidevice/hnd	stats
31.2	sk6		ath0	read	device_wifi/wifidevice/hnd	stats


# Get RSSI
40.0	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 50 200 2 90 true 1 0
40.1	sk1		ath0	write	sf	reset
40.1	sk2		ath0	read	device_wifi/wifidevice/cst	stats

41.0	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 50 200 2 90 true 1 0
41.1	sk1		ath0	write	sf	reset
41.1	sk3		ath0	read	device_wifi/wifidevice/cst	stats

42.0	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 50 200 2 90 true 1 0
42.1	sk1		ath0	write	sf	reset
42.1	sk4		ath0	read	device_wifi/wifidevice/cst	stats

43.0	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 50 200 2 90 true 1 0
43.1	sk1		ath0	write	sf	reset
43.1	sk5		ath0	read	device_wifi/wifidevice/cst	stats

44.0	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 50 200 2 90 true 1 0
44.1	sk1		ath0	write	sf	reset
44.1	sk6		ath0	read	device_wifi/wifidevice/cst	stats

45.0	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 50 200 2 90 true 1 0
45.1	sk2		ath0	write	sf	reset
45.1	sk1		ath0	read	device_wifi/wifidevice/cst	stats

46.0	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 50 200 2 90 true 1 0
46.1	sk2		ath0	write	sf	reset
46.1	sk3		ath0	read	device_wifi/wifidevice/cst	stats

47.0	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 50 200 2 90 true 1 0
47.1	sk2		ath0	write	sf	reset
47.1	sk4		ath0	read	device_wifi/wifidevice/cst	stats

48.0	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 50 200 2 90 true 1 0
48.1	sk2		ath0	write	sf	reset
48.1	sk5		ath0	read	device_wifi/wifidevice/cst	stats

49.0	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 50 200 2 90 true 1 0
49.1	sk2		ath0	write	sf	reset
49.1	sk6		ath0	read	device_wifi/wifidevice/cst	stats

50.0	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 50 200 2 90 true 1 0
50.1	sk3		ath0	write	sf	reset
50.1	sk1		ath0	read	device_wifi/wifidevice/cst	stats

51.0	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 50 200 2 90 true 1 0
51.1	sk3		ath0	write	sf	reset
51.1	sk2		ath0	read	device_wifi/wifidevice/cst	stats

52.0	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 50 200 2 90 true 1 0
52.1	sk3		ath0	write	sf	reset
52.1	sk4		ath0	read	device_wifi/wifidevice/cst	stats

53.0	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 50 200 2 90 true 1 0
53.1	sk3		ath0	write	sf	reset
53.1	sk5		ath0	read	device_wifi/wifidevice/cst	stats

54.0	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 50 200 2 90 true 1 0
54.1	sk3		ath0	write	sf	reset
54.1	sk6		ath0	read	device_wifi/wifidevice/cst	stats

55.0	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 50 200 2 90 true 1 0
55.1	sk4		ath0	write	sf	reset
55.1	sk1		ath0	read	device_wifi/wifidevice/cst	stats

56.0	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 50 200 2 90 true 1 0
56.1	sk4		ath0	write	sf	reset
56.1	sk2		ath0	read	device_wifi/wifidevice/cst	stats

57.0	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 50 200 2 90 true 1 0
57.1	sk4		ath0	write	sf	reset
57.1	sk3		ath0	read	device_wifi/wifidevice/cst	stats

58.0	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 50 200 2 90 true 1 0
58.1	sk4		ath0	write	sf	reset
58.1	sk5		ath0	read	device_wifi/wifidevice/cst	stats

59.0	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 50 200 2 90 true 1 0
59.1	sk4		ath0	write	sf	reset
59.1	sk6		ath0	read	device_wifi/wifidevice/cst	stats

60.0	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 50 200 2 90 true 1 0
60.1	sk5		ath0	write	sf	reset
60.1	sk1		ath0	read	device_wifi/wifidevice/cst	stats

61.0	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 50 200 2 90 true 1 0
61.1	sk5		ath0	write	sf	reset
61.1	sk2		ath0	read	device_wifi/wifidevice/cst	stats

62.0	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 50 200 2 90 true 1 0
62.1	sk5		ath0	write	sf	reset
62.1	sk3		ath0	read	device_wifi/wifidevice/cst	stats

63.0	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 50 200 2 90 true 1 0
63.1	sk5		ath0	write	sf	reset
63.1	sk4		ath0	read	device_wifi/wifidevice/cst	stats

64.0	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 50 200 2 90 true 1 0
64.1	sk5		ath0	write	sf	reset
64.1	sk6		ath0	read	device_wifi/wifidevice/cst	stats

65.0	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 50 200 2 90 true 1 0
65.1	sk6		ath0	write	sf	reset
65.1	sk1		ath0	read	device_wifi/wifidevice/cst	stats

66.0	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 50 200 2 90 true 1 0
66.1	sk6		ath0	write	sf	reset
66.1	sk2		ath0	read	device_wifi/wifidevice/cst	stats

67.0	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 50 200 2 90 true 1 0
67.1	sk6		ath0	write	sf	reset
67.1	sk3		ath0	read	device_wifi/wifidevice/cst	stats

68.0	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 50 200 2 90 true 1 0
68.1	sk6		ath0	write	sf	reset
68.1	sk4		ath0	read	device_wifi/wifidevice/cst	stats

69.0	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 50 200 2 90 true 1 0
69.1	sk6		ath0	write	sf	reset
69.1	sk5		ath0	read	device_wifi/wifidevice/cst	stats


# Probing with multiple rates for all variations
# Probe link 1 - 2
70.0	sk3		ath0	write	mcs	rate	36
70.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
70.0	sk4		ath0	write	mcs	rate	36
70.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
70.0	sk5		ath0	write	mcs	rate	36
70.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
70.0	sk6		ath0	write	mcs	rate	36
70.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
71	sk1		ath0	write	mcs	rate	12
71	sk1		ath0	read	mcs	rate	
71	sk1		ath0	write	sf	reset	
73	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=6
79	sk1		ath0	read	sf	stats

81	sk1		ath0	write	mcs	rate	18
81	sk1		ath0	read	mcs	rate	
81	sk1		ath0	write	sf	reset	
83	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=9
89	sk1		ath0	read	sf	stats

91	sk1		ath0	write	mcs	rate	24
91	sk1		ath0	read	mcs	rate	
91	sk1		ath0	write	sf	reset	
93	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=12
99	sk1		ath0	read	sf	stats

101	sk1		ath0	write	mcs	rate	36
101	sk1		ath0	read	mcs	rate	
101	sk1		ath0	write	sf	reset	
103	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=18
109	sk1		ath0	read	sf	stats

111	sk1		ath0	write	mcs	rate	48
111	sk1		ath0	read	mcs	rate	
111	sk1		ath0	write	sf	reset	
113	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=24
119	sk1		ath0	read	sf	stats

121	sk1		ath0	write	mcs	rate	72
121	sk1		ath0	read	mcs	rate	
121	sk1		ath0	write	sf	reset	
123	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=36
129	sk1		ath0	read	sf	stats

131	sk1		ath0	write	mcs	rate	96
131	sk1		ath0	read	mcs	rate	
131	sk1		ath0	write	sf	reset	
133	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=48
139	sk1		ath0	read	sf	stats

141	sk1		ath0	write	mcs	rate	108
141	sk1		ath0	read	mcs	rate	
141	sk1		ath0	write	sf	reset	
143	sk1		ath0	write	sf	add_flow	sk1:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=54
149	sk1		ath0	read	sf	stats


# Probe link 1 - 3
150.0	sk2		ath0	write	mcs	rate	36
150.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
150.0	sk4		ath0	write	mcs	rate	36
150.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
150.0	sk5		ath0	write	mcs	rate	36
150.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
150.0	sk6		ath0	write	mcs	rate	36
150.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
151	sk1		ath0	write	mcs	rate	12
151	sk1		ath0	read	mcs	rate	
151	sk1		ath0	write	sf	reset	
153	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=6
159	sk1		ath0	read	sf	stats

161	sk1		ath0	write	mcs	rate	18
161	sk1		ath0	read	mcs	rate	
161	sk1		ath0	write	sf	reset	
163	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=9
169	sk1		ath0	read	sf	stats

171	sk1		ath0	write	mcs	rate	24
171	sk1		ath0	read	mcs	rate	
171	sk1		ath0	write	sf	reset	
173	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=12
179	sk1		ath0	read	sf	stats

181	sk1		ath0	write	mcs	rate	36
181	sk1		ath0	read	mcs	rate	
181	sk1		ath0	write	sf	reset	
183	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=18
189	sk1		ath0	read	sf	stats

191	sk1		ath0	write	mcs	rate	48
191	sk1		ath0	read	mcs	rate	
191	sk1		ath0	write	sf	reset	
193	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=24
199	sk1		ath0	read	sf	stats

201	sk1		ath0	write	mcs	rate	72
201	sk1		ath0	read	mcs	rate	
201	sk1		ath0	write	sf	reset	
203	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=36
209	sk1		ath0	read	sf	stats

211	sk1		ath0	write	mcs	rate	96
211	sk1		ath0	read	mcs	rate	
211	sk1		ath0	write	sf	reset	
213	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=48
219	sk1		ath0	read	sf	stats

221	sk1		ath0	write	mcs	rate	108
221	sk1		ath0	read	mcs	rate	
221	sk1		ath0	write	sf	reset	
223	sk1		ath0	write	sf	add_flow	sk1:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=54
229	sk1		ath0	read	sf	stats


# Probe link 1 - 4
230.0	sk2		ath0	write	mcs	rate	36
230.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
230.0	sk3		ath0	write	mcs	rate	36
230.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
230.0	sk5		ath0	write	mcs	rate	36
230.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
230.0	sk6		ath0	write	mcs	rate	36
230.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
231	sk1		ath0	write	mcs	rate	12
231	sk1		ath0	read	mcs	rate	
231	sk1		ath0	write	sf	reset	
233	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=6
239	sk1		ath0	read	sf	stats

241	sk1		ath0	write	mcs	rate	18
241	sk1		ath0	read	mcs	rate	
241	sk1		ath0	write	sf	reset	
243	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=9
249	sk1		ath0	read	sf	stats

251	sk1		ath0	write	mcs	rate	24
251	sk1		ath0	read	mcs	rate	
251	sk1		ath0	write	sf	reset	
253	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=12
259	sk1		ath0	read	sf	stats

261	sk1		ath0	write	mcs	rate	36
261	sk1		ath0	read	mcs	rate	
261	sk1		ath0	write	sf	reset	
263	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=18
269	sk1		ath0	read	sf	stats

271	sk1		ath0	write	mcs	rate	48
271	sk1		ath0	read	mcs	rate	
271	sk1		ath0	write	sf	reset	
273	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=24
279	sk1		ath0	read	sf	stats

281	sk1		ath0	write	mcs	rate	72
281	sk1		ath0	read	mcs	rate	
281	sk1		ath0	write	sf	reset	
283	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=36
289	sk1		ath0	read	sf	stats

291	sk1		ath0	write	mcs	rate	96
291	sk1		ath0	read	mcs	rate	
291	sk1		ath0	write	sf	reset	
293	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=48
299	sk1		ath0	read	sf	stats

301	sk1		ath0	write	mcs	rate	108
301	sk1		ath0	read	mcs	rate	
301	sk1		ath0	write	sf	reset	
303	sk1		ath0	write	sf	add_flow	sk1:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=54
309	sk1		ath0	read	sf	stats


# Probe link 1 - 5
310.0	sk2		ath0	write	mcs	rate	36
310.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
310.0	sk3		ath0	write	mcs	rate	36
310.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
310.0	sk4		ath0	write	mcs	rate	36
310.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
310.0	sk6		ath0	write	mcs	rate	36
310.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
311	sk1		ath0	write	mcs	rate	12
311	sk1		ath0	read	mcs	rate	
311	sk1		ath0	write	sf	reset	
313	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=6
319	sk1		ath0	read	sf	stats

321	sk1		ath0	write	mcs	rate	18
321	sk1		ath0	read	mcs	rate	
321	sk1		ath0	write	sf	reset	
323	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=9
329	sk1		ath0	read	sf	stats

331	sk1		ath0	write	mcs	rate	24
331	sk1		ath0	read	mcs	rate	
331	sk1		ath0	write	sf	reset	
333	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=12
339	sk1		ath0	read	sf	stats

341	sk1		ath0	write	mcs	rate	36
341	sk1		ath0	read	mcs	rate	
341	sk1		ath0	write	sf	reset	
343	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=18
349	sk1		ath0	read	sf	stats

351	sk1		ath0	write	mcs	rate	48
351	sk1		ath0	read	mcs	rate	
351	sk1		ath0	write	sf	reset	
353	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=24
359	sk1		ath0	read	sf	stats

361	sk1		ath0	write	mcs	rate	72
361	sk1		ath0	read	mcs	rate	
361	sk1		ath0	write	sf	reset	
363	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=36
369	sk1		ath0	read	sf	stats

371	sk1		ath0	write	mcs	rate	96
371	sk1		ath0	read	mcs	rate	
371	sk1		ath0	write	sf	reset	
373	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=48
379	sk1		ath0	read	sf	stats

381	sk1		ath0	write	mcs	rate	108
381	sk1		ath0	read	mcs	rate	
381	sk1		ath0	write	sf	reset	
383	sk1		ath0	write	sf	add_flow	sk1:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=54
389	sk1		ath0	read	sf	stats


# Probe link 1 - 6
390.0	sk2		ath0	write	mcs	rate	36
390.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
390.0	sk3		ath0	write	mcs	rate	36
390.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
390.0	sk4		ath0	write	mcs	rate	36
390.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
390.0	sk5		ath0	write	mcs	rate	36
390.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
391	sk1		ath0	write	mcs	rate	12
391	sk1		ath0	read	mcs	rate	
391	sk1		ath0	write	sf	reset	
393	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=6
399	sk1		ath0	read	sf	stats

401	sk1		ath0	write	mcs	rate	18
401	sk1		ath0	read	mcs	rate	
401	sk1		ath0	write	sf	reset	
403	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=9
409	sk1		ath0	read	sf	stats

411	sk1		ath0	write	mcs	rate	24
411	sk1		ath0	read	mcs	rate	
411	sk1		ath0	write	sf	reset	
413	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=12
419	sk1		ath0	read	sf	stats

421	sk1		ath0	write	mcs	rate	36
421	sk1		ath0	read	mcs	rate	
421	sk1		ath0	write	sf	reset	
423	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=18
429	sk1		ath0	read	sf	stats

431	sk1		ath0	write	mcs	rate	48
431	sk1		ath0	read	mcs	rate	
431	sk1		ath0	write	sf	reset	
433	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=24
439	sk1		ath0	read	sf	stats

441	sk1		ath0	write	mcs	rate	72
441	sk1		ath0	read	mcs	rate	
441	sk1		ath0	write	sf	reset	
443	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=36
449	sk1		ath0	read	sf	stats

451	sk1		ath0	write	mcs	rate	96
451	sk1		ath0	read	mcs	rate	
451	sk1		ath0	write	sf	reset	
453	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=48
459	sk1		ath0	read	sf	stats

461	sk1		ath0	write	mcs	rate	108
461	sk1		ath0	read	mcs	rate	
461	sk1		ath0	write	sf	reset	
463	sk1		ath0	write	sf	add_flow	sk1:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=54
469	sk1		ath0	read	sf	stats


# Probe link 2 - 1
470.0	sk3		ath0	write	mcs	rate	36
470.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
470.0	sk4		ath0	write	mcs	rate	36
470.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
470.0	sk5		ath0	write	mcs	rate	36
470.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
470.0	sk6		ath0	write	mcs	rate	36
470.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
471	sk2		ath0	write	mcs	rate	12
471	sk2		ath0	read	mcs	rate	
471	sk2		ath0	write	sf	reset	
473	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=6
479	sk2		ath0	read	sf	stats

481	sk2		ath0	write	mcs	rate	18
481	sk2		ath0	read	mcs	rate	
481	sk2		ath0	write	sf	reset	
483	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=9
489	sk2		ath0	read	sf	stats

491	sk2		ath0	write	mcs	rate	24
491	sk2		ath0	read	mcs	rate	
491	sk2		ath0	write	sf	reset	
493	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=12
499	sk2		ath0	read	sf	stats

501	sk2		ath0	write	mcs	rate	36
501	sk2		ath0	read	mcs	rate	
501	sk2		ath0	write	sf	reset	
503	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=18
509	sk2		ath0	read	sf	stats

511	sk2		ath0	write	mcs	rate	48
511	sk2		ath0	read	mcs	rate	
511	sk2		ath0	write	sf	reset	
513	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=24
519	sk2		ath0	read	sf	stats

521	sk2		ath0	write	mcs	rate	72
521	sk2		ath0	read	mcs	rate	
521	sk2		ath0	write	sf	reset	
523	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=36
529	sk2		ath0	read	sf	stats

531	sk2		ath0	write	mcs	rate	96
531	sk2		ath0	read	mcs	rate	
531	sk2		ath0	write	sf	reset	
533	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=48
539	sk2		ath0	read	sf	stats

541	sk2		ath0	write	mcs	rate	108
541	sk2		ath0	read	mcs	rate	
541	sk2		ath0	write	sf	reset	
543	sk2		ath0	write	sf	add_flow	sk2:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=54
549	sk2		ath0	read	sf	stats


# Probe link 2 - 3
550.0	sk1		ath0	write	mcs	rate	36
550.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
550.0	sk4		ath0	write	mcs	rate	36
550.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
550.0	sk5		ath0	write	mcs	rate	36
550.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
550.0	sk6		ath0	write	mcs	rate	36
550.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
551	sk2		ath0	write	mcs	rate	12
551	sk2		ath0	read	mcs	rate	
551	sk2		ath0	write	sf	reset	
553	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=6
559	sk2		ath0	read	sf	stats

561	sk2		ath0	write	mcs	rate	18
561	sk2		ath0	read	mcs	rate	
561	sk2		ath0	write	sf	reset	
563	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=9
569	sk2		ath0	read	sf	stats

571	sk2		ath0	write	mcs	rate	24
571	sk2		ath0	read	mcs	rate	
571	sk2		ath0	write	sf	reset	
573	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=12
579	sk2		ath0	read	sf	stats

581	sk2		ath0	write	mcs	rate	36
581	sk2		ath0	read	mcs	rate	
581	sk2		ath0	write	sf	reset	
583	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=18
589	sk2		ath0	read	sf	stats

591	sk2		ath0	write	mcs	rate	48
591	sk2		ath0	read	mcs	rate	
591	sk2		ath0	write	sf	reset	
593	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=24
599	sk2		ath0	read	sf	stats

601	sk2		ath0	write	mcs	rate	72
601	sk2		ath0	read	mcs	rate	
601	sk2		ath0	write	sf	reset	
603	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=36
609	sk2		ath0	read	sf	stats

611	sk2		ath0	write	mcs	rate	96
611	sk2		ath0	read	mcs	rate	
611	sk2		ath0	write	sf	reset	
613	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=48
619	sk2		ath0	read	sf	stats

621	sk2		ath0	write	mcs	rate	108
621	sk2		ath0	read	mcs	rate	
621	sk2		ath0	write	sf	reset	
623	sk2		ath0	write	sf	add_flow	sk2:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=54
629	sk2		ath0	read	sf	stats


# Probe link 2 - 4
630.0	sk1		ath0	write	mcs	rate	36
630.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
630.0	sk3		ath0	write	mcs	rate	36
630.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
630.0	sk5		ath0	write	mcs	rate	36
630.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
630.0	sk6		ath0	write	mcs	rate	36
630.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
631	sk2		ath0	write	mcs	rate	12
631	sk2		ath0	read	mcs	rate	
631	sk2		ath0	write	sf	reset	
633	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=6
639	sk2		ath0	read	sf	stats

641	sk2		ath0	write	mcs	rate	18
641	sk2		ath0	read	mcs	rate	
641	sk2		ath0	write	sf	reset	
643	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=9
649	sk2		ath0	read	sf	stats

651	sk2		ath0	write	mcs	rate	24
651	sk2		ath0	read	mcs	rate	
651	sk2		ath0	write	sf	reset	
653	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=12
659	sk2		ath0	read	sf	stats

661	sk2		ath0	write	mcs	rate	36
661	sk2		ath0	read	mcs	rate	
661	sk2		ath0	write	sf	reset	
663	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=18
669	sk2		ath0	read	sf	stats

671	sk2		ath0	write	mcs	rate	48
671	sk2		ath0	read	mcs	rate	
671	sk2		ath0	write	sf	reset	
673	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=24
679	sk2		ath0	read	sf	stats

681	sk2		ath0	write	mcs	rate	72
681	sk2		ath0	read	mcs	rate	
681	sk2		ath0	write	sf	reset	
683	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=36
689	sk2		ath0	read	sf	stats

691	sk2		ath0	write	mcs	rate	96
691	sk2		ath0	read	mcs	rate	
691	sk2		ath0	write	sf	reset	
693	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=48
699	sk2		ath0	read	sf	stats

701	sk2		ath0	write	mcs	rate	108
701	sk2		ath0	read	mcs	rate	
701	sk2		ath0	write	sf	reset	
703	sk2		ath0	write	sf	add_flow	sk2:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=54
709	sk2		ath0	read	sf	stats


# Probe link 2 - 5
710.0	sk1		ath0	write	mcs	rate	36
710.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
710.0	sk3		ath0	write	mcs	rate	36
710.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
710.0	sk4		ath0	write	mcs	rate	36
710.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
710.0	sk6		ath0	write	mcs	rate	36
710.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
711	sk2		ath0	write	mcs	rate	12
711	sk2		ath0	read	mcs	rate	
711	sk2		ath0	write	sf	reset	
713	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=6
719	sk2		ath0	read	sf	stats

721	sk2		ath0	write	mcs	rate	18
721	sk2		ath0	read	mcs	rate	
721	sk2		ath0	write	sf	reset	
723	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=9
729	sk2		ath0	read	sf	stats

731	sk2		ath0	write	mcs	rate	24
731	sk2		ath0	read	mcs	rate	
731	sk2		ath0	write	sf	reset	
733	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=12
739	sk2		ath0	read	sf	stats

741	sk2		ath0	write	mcs	rate	36
741	sk2		ath0	read	mcs	rate	
741	sk2		ath0	write	sf	reset	
743	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=18
749	sk2		ath0	read	sf	stats

751	sk2		ath0	write	mcs	rate	48
751	sk2		ath0	read	mcs	rate	
751	sk2		ath0	write	sf	reset	
753	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=24
759	sk2		ath0	read	sf	stats

761	sk2		ath0	write	mcs	rate	72
761	sk2		ath0	read	mcs	rate	
761	sk2		ath0	write	sf	reset	
763	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=36
769	sk2		ath0	read	sf	stats

771	sk2		ath0	write	mcs	rate	96
771	sk2		ath0	read	mcs	rate	
771	sk2		ath0	write	sf	reset	
773	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=48
779	sk2		ath0	read	sf	stats

781	sk2		ath0	write	mcs	rate	108
781	sk2		ath0	read	mcs	rate	
781	sk2		ath0	write	sf	reset	
783	sk2		ath0	write	sf	add_flow	sk2:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=54
789	sk2		ath0	read	sf	stats


# Probe link 2 - 6
790.0	sk1		ath0	write	mcs	rate	36
790.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
790.0	sk3		ath0	write	mcs	rate	36
790.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
790.0	sk4		ath0	write	mcs	rate	36
790.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
790.0	sk5		ath0	write	mcs	rate	36
790.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
791	sk2		ath0	write	mcs	rate	12
791	sk2		ath0	read	mcs	rate	
791	sk2		ath0	write	sf	reset	
793	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=6
799	sk2		ath0	read	sf	stats

801	sk2		ath0	write	mcs	rate	18
801	sk2		ath0	read	mcs	rate	
801	sk2		ath0	write	sf	reset	
803	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=9
809	sk2		ath0	read	sf	stats

811	sk2		ath0	write	mcs	rate	24
811	sk2		ath0	read	mcs	rate	
811	sk2		ath0	write	sf	reset	
813	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=12
819	sk2		ath0	read	sf	stats

821	sk2		ath0	write	mcs	rate	36
821	sk2		ath0	read	mcs	rate	
821	sk2		ath0	write	sf	reset	
823	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=18
829	sk2		ath0	read	sf	stats

831	sk2		ath0	write	mcs	rate	48
831	sk2		ath0	read	mcs	rate	
831	sk2		ath0	write	sf	reset	
833	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=24
839	sk2		ath0	read	sf	stats

841	sk2		ath0	write	mcs	rate	72
841	sk2		ath0	read	mcs	rate	
841	sk2		ath0	write	sf	reset	
843	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=36
849	sk2		ath0	read	sf	stats

851	sk2		ath0	write	mcs	rate	96
851	sk2		ath0	read	mcs	rate	
851	sk2		ath0	write	sf	reset	
853	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=48
859	sk2		ath0	read	sf	stats

861	sk2		ath0	write	mcs	rate	108
861	sk2		ath0	read	mcs	rate	
861	sk2		ath0	write	sf	reset	
863	sk2		ath0	write	sf	add_flow	sk2:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=54
869	sk2		ath0	read	sf	stats


# Probe link 3 - 1
870.0	sk2		ath0	write	mcs	rate	36
870.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
870.0	sk4		ath0	write	mcs	rate	36
870.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
870.0	sk5		ath0	write	mcs	rate	36
870.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
870.0	sk6		ath0	write	mcs	rate	36
870.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
871	sk3		ath0	write	mcs	rate	12
871	sk3		ath0	read	mcs	rate	
871	sk3		ath0	write	sf	reset	
873	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=6
879	sk3		ath0	read	sf	stats

881	sk3		ath0	write	mcs	rate	18
881	sk3		ath0	read	mcs	rate	
881	sk3		ath0	write	sf	reset	
883	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=9
889	sk3		ath0	read	sf	stats

891	sk3		ath0	write	mcs	rate	24
891	sk3		ath0	read	mcs	rate	
891	sk3		ath0	write	sf	reset	
893	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=12
899	sk3		ath0	read	sf	stats

901	sk3		ath0	write	mcs	rate	36
901	sk3		ath0	read	mcs	rate	
901	sk3		ath0	write	sf	reset	
903	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=18
909	sk3		ath0	read	sf	stats

911	sk3		ath0	write	mcs	rate	48
911	sk3		ath0	read	mcs	rate	
911	sk3		ath0	write	sf	reset	
913	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=24
919	sk3		ath0	read	sf	stats

921	sk3		ath0	write	mcs	rate	72
921	sk3		ath0	read	mcs	rate	
921	sk3		ath0	write	sf	reset	
923	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=36
929	sk3		ath0	read	sf	stats

931	sk3		ath0	write	mcs	rate	96
931	sk3		ath0	read	mcs	rate	
931	sk3		ath0	write	sf	reset	
933	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=48
939	sk3		ath0	read	sf	stats

941	sk3		ath0	write	mcs	rate	108
941	sk3		ath0	read	mcs	rate	
941	sk3		ath0	write	sf	reset	
943	sk3		ath0	write	sf	add_flow	sk3:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=54
949	sk3		ath0	read	sf	stats


# Probe link 3 - 2
950.0	sk1		ath0	write	mcs	rate	36
950.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
950.0	sk4		ath0	write	mcs	rate	36
950.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
950.0	sk5		ath0	write	mcs	rate	36
950.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
950.0	sk6		ath0	write	mcs	rate	36
950.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
951	sk3		ath0	write	mcs	rate	12
951	sk3		ath0	read	mcs	rate	
951	sk3		ath0	write	sf	reset	
953	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=6
959	sk3		ath0	read	sf	stats

961	sk3		ath0	write	mcs	rate	18
961	sk3		ath0	read	mcs	rate	
961	sk3		ath0	write	sf	reset	
963	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=9
969	sk3		ath0	read	sf	stats

971	sk3		ath0	write	mcs	rate	24
971	sk3		ath0	read	mcs	rate	
971	sk3		ath0	write	sf	reset	
973	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=12
979	sk3		ath0	read	sf	stats

981	sk3		ath0	write	mcs	rate	36
981	sk3		ath0	read	mcs	rate	
981	sk3		ath0	write	sf	reset	
983	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=18
989	sk3		ath0	read	sf	stats

991	sk3		ath0	write	mcs	rate	48
991	sk3		ath0	read	mcs	rate	
991	sk3		ath0	write	sf	reset	
993	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=24
999	sk3		ath0	read	sf	stats

1001	sk3		ath0	write	mcs	rate	72
1001	sk3		ath0	read	mcs	rate	
1001	sk3		ath0	write	sf	reset	
1003	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=36
1009	sk3		ath0	read	sf	stats

1011	sk3		ath0	write	mcs	rate	96
1011	sk3		ath0	read	mcs	rate	
1011	sk3		ath0	write	sf	reset	
1013	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=48
1019	sk3		ath0	read	sf	stats

1021	sk3		ath0	write	mcs	rate	108
1021	sk3		ath0	read	mcs	rate	
1021	sk3		ath0	write	sf	reset	
1023	sk3		ath0	write	sf	add_flow	sk3:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=54
1029	sk3		ath0	read	sf	stats


# Probe link 3 - 4
1030.0	sk1		ath0	write	mcs	rate	36
1030.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
1030.0	sk2		ath0	write	mcs	rate	36
1030.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
1030.0	sk5		ath0	write	mcs	rate	36
1030.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
1030.0	sk6		ath0	write	mcs	rate	36
1030.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
1031	sk3		ath0	write	mcs	rate	12
1031	sk3		ath0	read	mcs	rate	
1031	sk3		ath0	write	sf	reset	
1033	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=6
1039	sk3		ath0	read	sf	stats

1041	sk3		ath0	write	mcs	rate	18
1041	sk3		ath0	read	mcs	rate	
1041	sk3		ath0	write	sf	reset	
1043	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=9
1049	sk3		ath0	read	sf	stats

1051	sk3		ath0	write	mcs	rate	24
1051	sk3		ath0	read	mcs	rate	
1051	sk3		ath0	write	sf	reset	
1053	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=12
1059	sk3		ath0	read	sf	stats

1061	sk3		ath0	write	mcs	rate	36
1061	sk3		ath0	read	mcs	rate	
1061	sk3		ath0	write	sf	reset	
1063	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=18
1069	sk3		ath0	read	sf	stats

1071	sk3		ath0	write	mcs	rate	48
1071	sk3		ath0	read	mcs	rate	
1071	sk3		ath0	write	sf	reset	
1073	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=24
1079	sk3		ath0	read	sf	stats

1081	sk3		ath0	write	mcs	rate	72
1081	sk3		ath0	read	mcs	rate	
1081	sk3		ath0	write	sf	reset	
1083	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=36
1089	sk3		ath0	read	sf	stats

1091	sk3		ath0	write	mcs	rate	96
1091	sk3		ath0	read	mcs	rate	
1091	sk3		ath0	write	sf	reset	
1093	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=48
1099	sk3		ath0	read	sf	stats

1101	sk3		ath0	write	mcs	rate	108
1101	sk3		ath0	read	mcs	rate	
1101	sk3		ath0	write	sf	reset	
1103	sk3		ath0	write	sf	add_flow	sk3:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=54
1109	sk3		ath0	read	sf	stats


# Probe link 3 - 5
1110.0	sk1		ath0	write	mcs	rate	36
1110.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
1110.0	sk2		ath0	write	mcs	rate	36
1110.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
1110.0	sk4		ath0	write	mcs	rate	36
1110.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
1110.0	sk6		ath0	write	mcs	rate	36
1110.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
1111	sk3		ath0	write	mcs	rate	12
1111	sk3		ath0	read	mcs	rate	
1111	sk3		ath0	write	sf	reset	
1113	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=6
1119	sk3		ath0	read	sf	stats

1121	sk3		ath0	write	mcs	rate	18
1121	sk3		ath0	read	mcs	rate	
1121	sk3		ath0	write	sf	reset	
1123	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=9
1129	sk3		ath0	read	sf	stats

1131	sk3		ath0	write	mcs	rate	24
1131	sk3		ath0	read	mcs	rate	
1131	sk3		ath0	write	sf	reset	
1133	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=12
1139	sk3		ath0	read	sf	stats

1141	sk3		ath0	write	mcs	rate	36
1141	sk3		ath0	read	mcs	rate	
1141	sk3		ath0	write	sf	reset	
1143	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=18
1149	sk3		ath0	read	sf	stats

1151	sk3		ath0	write	mcs	rate	48
1151	sk3		ath0	read	mcs	rate	
1151	sk3		ath0	write	sf	reset	
1153	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=24
1159	sk3		ath0	read	sf	stats

1161	sk3		ath0	write	mcs	rate	72
1161	sk3		ath0	read	mcs	rate	
1161	sk3		ath0	write	sf	reset	
1163	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=36
1169	sk3		ath0	read	sf	stats

1171	sk3		ath0	write	mcs	rate	96
1171	sk3		ath0	read	mcs	rate	
1171	sk3		ath0	write	sf	reset	
1173	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=48
1179	sk3		ath0	read	sf	stats

1181	sk3		ath0	write	mcs	rate	108
1181	sk3		ath0	read	mcs	rate	
1181	sk3		ath0	write	sf	reset	
1183	sk3		ath0	write	sf	add_flow	sk3:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=54
1189	sk3		ath0	read	sf	stats


# Probe link 3 - 6
1190.0	sk1		ath0	write	mcs	rate	36
1190.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
1190.0	sk2		ath0	write	mcs	rate	36
1190.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
1190.0	sk4		ath0	write	mcs	rate	36
1190.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
1190.0	sk5		ath0	write	mcs	rate	36
1190.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
1191	sk3		ath0	write	mcs	rate	12
1191	sk3		ath0	read	mcs	rate	
1191	sk3		ath0	write	sf	reset	
1193	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=6
1199	sk3		ath0	read	sf	stats

1201	sk3		ath0	write	mcs	rate	18
1201	sk3		ath0	read	mcs	rate	
1201	sk3		ath0	write	sf	reset	
1203	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=9
1209	sk3		ath0	read	sf	stats

1211	sk3		ath0	write	mcs	rate	24
1211	sk3		ath0	read	mcs	rate	
1211	sk3		ath0	write	sf	reset	
1213	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=12
1219	sk3		ath0	read	sf	stats

1221	sk3		ath0	write	mcs	rate	36
1221	sk3		ath0	read	mcs	rate	
1221	sk3		ath0	write	sf	reset	
1223	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=18
1229	sk3		ath0	read	sf	stats

1231	sk3		ath0	write	mcs	rate	48
1231	sk3		ath0	read	mcs	rate	
1231	sk3		ath0	write	sf	reset	
1233	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=24
1239	sk3		ath0	read	sf	stats

1241	sk3		ath0	write	mcs	rate	72
1241	sk3		ath0	read	mcs	rate	
1241	sk3		ath0	write	sf	reset	
1243	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=36
1249	sk3		ath0	read	sf	stats

1251	sk3		ath0	write	mcs	rate	96
1251	sk3		ath0	read	mcs	rate	
1251	sk3		ath0	write	sf	reset	
1253	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=48
1259	sk3		ath0	read	sf	stats

1261	sk3		ath0	write	mcs	rate	108
1261	sk3		ath0	read	mcs	rate	
1261	sk3		ath0	write	sf	reset	
1263	sk3		ath0	write	sf	add_flow	sk3:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=54
1269	sk3		ath0	read	sf	stats


# Probe link 4 - 1
1270.0	sk2		ath0	write	mcs	rate	36
1270.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
1270.0	sk3		ath0	write	mcs	rate	36
1270.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
1270.0	sk5		ath0	write	mcs	rate	36
1270.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
1270.0	sk6		ath0	write	mcs	rate	36
1270.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
1271	sk4		ath0	write	mcs	rate	12
1271	sk4		ath0	read	mcs	rate	
1271	sk4		ath0	write	sf	reset	
1273	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=6
1279	sk4		ath0	read	sf	stats

1281	sk4		ath0	write	mcs	rate	18
1281	sk4		ath0	read	mcs	rate	
1281	sk4		ath0	write	sf	reset	
1283	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=9
1289	sk4		ath0	read	sf	stats

1291	sk4		ath0	write	mcs	rate	24
1291	sk4		ath0	read	mcs	rate	
1291	sk4		ath0	write	sf	reset	
1293	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=12
1299	sk4		ath0	read	sf	stats

1301	sk4		ath0	write	mcs	rate	36
1301	sk4		ath0	read	mcs	rate	
1301	sk4		ath0	write	sf	reset	
1303	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=18
1309	sk4		ath0	read	sf	stats

1311	sk4		ath0	write	mcs	rate	48
1311	sk4		ath0	read	mcs	rate	
1311	sk4		ath0	write	sf	reset	
1313	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=24
1319	sk4		ath0	read	sf	stats

1321	sk4		ath0	write	mcs	rate	72
1321	sk4		ath0	read	mcs	rate	
1321	sk4		ath0	write	sf	reset	
1323	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=36
1329	sk4		ath0	read	sf	stats

1331	sk4		ath0	write	mcs	rate	96
1331	sk4		ath0	read	mcs	rate	
1331	sk4		ath0	write	sf	reset	
1333	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=48
1339	sk4		ath0	read	sf	stats

1341	sk4		ath0	write	mcs	rate	108
1341	sk4		ath0	read	mcs	rate	
1341	sk4		ath0	write	sf	reset	
1343	sk4		ath0	write	sf	add_flow	sk4:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=54
1349	sk4		ath0	read	sf	stats


# Probe link 4 - 2
1350.0	sk1		ath0	write	mcs	rate	36
1350.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
1350.0	sk3		ath0	write	mcs	rate	36
1350.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
1350.0	sk5		ath0	write	mcs	rate	36
1350.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
1350.0	sk6		ath0	write	mcs	rate	36
1350.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
1351	sk4		ath0	write	mcs	rate	12
1351	sk4		ath0	read	mcs	rate	
1351	sk4		ath0	write	sf	reset	
1353	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=6
1359	sk4		ath0	read	sf	stats

1361	sk4		ath0	write	mcs	rate	18
1361	sk4		ath0	read	mcs	rate	
1361	sk4		ath0	write	sf	reset	
1363	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=9
1369	sk4		ath0	read	sf	stats

1371	sk4		ath0	write	mcs	rate	24
1371	sk4		ath0	read	mcs	rate	
1371	sk4		ath0	write	sf	reset	
1373	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=12
1379	sk4		ath0	read	sf	stats

1381	sk4		ath0	write	mcs	rate	36
1381	sk4		ath0	read	mcs	rate	
1381	sk4		ath0	write	sf	reset	
1383	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=18
1389	sk4		ath0	read	sf	stats

1391	sk4		ath0	write	mcs	rate	48
1391	sk4		ath0	read	mcs	rate	
1391	sk4		ath0	write	sf	reset	
1393	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=24
1399	sk4		ath0	read	sf	stats

1401	sk4		ath0	write	mcs	rate	72
1401	sk4		ath0	read	mcs	rate	
1401	sk4		ath0	write	sf	reset	
1403	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=36
1409	sk4		ath0	read	sf	stats

1411	sk4		ath0	write	mcs	rate	96
1411	sk4		ath0	read	mcs	rate	
1411	sk4		ath0	write	sf	reset	
1413	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=48
1419	sk4		ath0	read	sf	stats

1421	sk4		ath0	write	mcs	rate	108
1421	sk4		ath0	read	mcs	rate	
1421	sk4		ath0	write	sf	reset	
1423	sk4		ath0	write	sf	add_flow	sk4:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=54
1429	sk4		ath0	read	sf	stats


# Probe link 4 - 3
1430.0	sk1		ath0	write	mcs	rate	36
1430.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
1430.0	sk2		ath0	write	mcs	rate	36
1430.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
1430.0	sk5		ath0	write	mcs	rate	36
1430.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
1430.0	sk6		ath0	write	mcs	rate	36
1430.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
1431	sk4		ath0	write	mcs	rate	12
1431	sk4		ath0	read	mcs	rate	
1431	sk4		ath0	write	sf	reset	
1433	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=6
1439	sk4		ath0	read	sf	stats

1441	sk4		ath0	write	mcs	rate	18
1441	sk4		ath0	read	mcs	rate	
1441	sk4		ath0	write	sf	reset	
1443	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=9
1449	sk4		ath0	read	sf	stats

1451	sk4		ath0	write	mcs	rate	24
1451	sk4		ath0	read	mcs	rate	
1451	sk4		ath0	write	sf	reset	
1453	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=12
1459	sk4		ath0	read	sf	stats

1461	sk4		ath0	write	mcs	rate	36
1461	sk4		ath0	read	mcs	rate	
1461	sk4		ath0	write	sf	reset	
1463	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=18
1469	sk4		ath0	read	sf	stats

1471	sk4		ath0	write	mcs	rate	48
1471	sk4		ath0	read	mcs	rate	
1471	sk4		ath0	write	sf	reset	
1473	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=24
1479	sk4		ath0	read	sf	stats

1481	sk4		ath0	write	mcs	rate	72
1481	sk4		ath0	read	mcs	rate	
1481	sk4		ath0	write	sf	reset	
1483	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=36
1489	sk4		ath0	read	sf	stats

1491	sk4		ath0	write	mcs	rate	96
1491	sk4		ath0	read	mcs	rate	
1491	sk4		ath0	write	sf	reset	
1493	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=48
1499	sk4		ath0	read	sf	stats

1501	sk4		ath0	write	mcs	rate	108
1501	sk4		ath0	read	mcs	rate	
1501	sk4		ath0	write	sf	reset	
1503	sk4		ath0	write	sf	add_flow	sk4:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=54
1509	sk4		ath0	read	sf	stats


# Probe link 4 - 5
1510.0	sk1		ath0	write	mcs	rate	36
1510.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
1510.0	sk2		ath0	write	mcs	rate	36
1510.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
1510.0	sk3		ath0	write	mcs	rate	36
1510.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
1510.0	sk6		ath0	write	mcs	rate	36
1510.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
1511	sk4		ath0	write	mcs	rate	12
1511	sk4		ath0	read	mcs	rate	
1511	sk4		ath0	write	sf	reset	
1513	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=6
1519	sk4		ath0	read	sf	stats

1521	sk4		ath0	write	mcs	rate	18
1521	sk4		ath0	read	mcs	rate	
1521	sk4		ath0	write	sf	reset	
1523	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=9
1529	sk4		ath0	read	sf	stats

1531	sk4		ath0	write	mcs	rate	24
1531	sk4		ath0	read	mcs	rate	
1531	sk4		ath0	write	sf	reset	
1533	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=12
1539	sk4		ath0	read	sf	stats

1541	sk4		ath0	write	mcs	rate	36
1541	sk4		ath0	read	mcs	rate	
1541	sk4		ath0	write	sf	reset	
1543	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=18
1549	sk4		ath0	read	sf	stats

1551	sk4		ath0	write	mcs	rate	48
1551	sk4		ath0	read	mcs	rate	
1551	sk4		ath0	write	sf	reset	
1553	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=24
1559	sk4		ath0	read	sf	stats

1561	sk4		ath0	write	mcs	rate	72
1561	sk4		ath0	read	mcs	rate	
1561	sk4		ath0	write	sf	reset	
1563	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=36
1569	sk4		ath0	read	sf	stats

1571	sk4		ath0	write	mcs	rate	96
1571	sk4		ath0	read	mcs	rate	
1571	sk4		ath0	write	sf	reset	
1573	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=48
1579	sk4		ath0	read	sf	stats

1581	sk4		ath0	write	mcs	rate	108
1581	sk4		ath0	read	mcs	rate	
1581	sk4		ath0	write	sf	reset	
1583	sk4		ath0	write	sf	add_flow	sk4:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=54
1589	sk4		ath0	read	sf	stats


# Probe link 4 - 6
1590.0	sk1		ath0	write	mcs	rate	36
1590.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
1590.0	sk2		ath0	write	mcs	rate	36
1590.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
1590.0	sk3		ath0	write	mcs	rate	36
1590.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
1590.0	sk5		ath0	write	mcs	rate	36
1590.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
1591	sk4		ath0	write	mcs	rate	12
1591	sk4		ath0	read	mcs	rate	
1591	sk4		ath0	write	sf	reset	
1593	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=6
1599	sk4		ath0	read	sf	stats

1601	sk4		ath0	write	mcs	rate	18
1601	sk4		ath0	read	mcs	rate	
1601	sk4		ath0	write	sf	reset	
1603	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=9
1609	sk4		ath0	read	sf	stats

1611	sk4		ath0	write	mcs	rate	24
1611	sk4		ath0	read	mcs	rate	
1611	sk4		ath0	write	sf	reset	
1613	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=12
1619	sk4		ath0	read	sf	stats

1621	sk4		ath0	write	mcs	rate	36
1621	sk4		ath0	read	mcs	rate	
1621	sk4		ath0	write	sf	reset	
1623	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=18
1629	sk4		ath0	read	sf	stats

1631	sk4		ath0	write	mcs	rate	48
1631	sk4		ath0	read	mcs	rate	
1631	sk4		ath0	write	sf	reset	
1633	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=24
1639	sk4		ath0	read	sf	stats

1641	sk4		ath0	write	mcs	rate	72
1641	sk4		ath0	read	mcs	rate	
1641	sk4		ath0	write	sf	reset	
1643	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=36
1649	sk4		ath0	read	sf	stats

1651	sk4		ath0	write	mcs	rate	96
1651	sk4		ath0	read	mcs	rate	
1651	sk4		ath0	write	sf	reset	
1653	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=48
1659	sk4		ath0	read	sf	stats

1661	sk4		ath0	write	mcs	rate	108
1661	sk4		ath0	read	mcs	rate	
1661	sk4		ath0	write	sf	reset	
1663	sk4		ath0	write	sf	add_flow	sk4:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=54
1669	sk4		ath0	read	sf	stats


# Probe link 5 - 1
1670.0	sk2		ath0	write	mcs	rate	36
1670.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
1670.0	sk3		ath0	write	mcs	rate	36
1670.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
1670.0	sk4		ath0	write	mcs	rate	36
1670.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
1670.0	sk6		ath0	write	mcs	rate	36
1670.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
1671	sk5		ath0	write	mcs	rate	12
1671	sk5		ath0	read	mcs	rate	
1671	sk5		ath0	write	sf	reset	
1673	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=6
1679	sk5		ath0	read	sf	stats

1681	sk5		ath0	write	mcs	rate	18
1681	sk5		ath0	read	mcs	rate	
1681	sk5		ath0	write	sf	reset	
1683	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=9
1689	sk5		ath0	read	sf	stats

1691	sk5		ath0	write	mcs	rate	24
1691	sk5		ath0	read	mcs	rate	
1691	sk5		ath0	write	sf	reset	
1693	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=12
1699	sk5		ath0	read	sf	stats

1701	sk5		ath0	write	mcs	rate	36
1701	sk5		ath0	read	mcs	rate	
1701	sk5		ath0	write	sf	reset	
1703	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=18
1709	sk5		ath0	read	sf	stats

1711	sk5		ath0	write	mcs	rate	48
1711	sk5		ath0	read	mcs	rate	
1711	sk5		ath0	write	sf	reset	
1713	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=24
1719	sk5		ath0	read	sf	stats

1721	sk5		ath0	write	mcs	rate	72
1721	sk5		ath0	read	mcs	rate	
1721	sk5		ath0	write	sf	reset	
1723	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=36
1729	sk5		ath0	read	sf	stats

1731	sk5		ath0	write	mcs	rate	96
1731	sk5		ath0	read	mcs	rate	
1731	sk5		ath0	write	sf	reset	
1733	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=48
1739	sk5		ath0	read	sf	stats

1741	sk5		ath0	write	mcs	rate	108
1741	sk5		ath0	read	mcs	rate	
1741	sk5		ath0	write	sf	reset	
1743	sk5		ath0	write	sf	add_flow	sk5:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=54
1749	sk5		ath0	read	sf	stats


# Probe link 5 - 2
1750.0	sk1		ath0	write	mcs	rate	36
1750.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
1750.0	sk3		ath0	write	mcs	rate	36
1750.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
1750.0	sk4		ath0	write	mcs	rate	36
1750.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
1750.0	sk6		ath0	write	mcs	rate	36
1750.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
1751	sk5		ath0	write	mcs	rate	12
1751	sk5		ath0	read	mcs	rate	
1751	sk5		ath0	write	sf	reset	
1753	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=6
1759	sk5		ath0	read	sf	stats

1761	sk5		ath0	write	mcs	rate	18
1761	sk5		ath0	read	mcs	rate	
1761	sk5		ath0	write	sf	reset	
1763	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=9
1769	sk5		ath0	read	sf	stats

1771	sk5		ath0	write	mcs	rate	24
1771	sk5		ath0	read	mcs	rate	
1771	sk5		ath0	write	sf	reset	
1773	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=12
1779	sk5		ath0	read	sf	stats

1781	sk5		ath0	write	mcs	rate	36
1781	sk5		ath0	read	mcs	rate	
1781	sk5		ath0	write	sf	reset	
1783	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=18
1789	sk5		ath0	read	sf	stats

1791	sk5		ath0	write	mcs	rate	48
1791	sk5		ath0	read	mcs	rate	
1791	sk5		ath0	write	sf	reset	
1793	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=24
1799	sk5		ath0	read	sf	stats

1801	sk5		ath0	write	mcs	rate	72
1801	sk5		ath0	read	mcs	rate	
1801	sk5		ath0	write	sf	reset	
1803	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=36
1809	sk5		ath0	read	sf	stats

1811	sk5		ath0	write	mcs	rate	96
1811	sk5		ath0	read	mcs	rate	
1811	sk5		ath0	write	sf	reset	
1813	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=48
1819	sk5		ath0	read	sf	stats

1821	sk5		ath0	write	mcs	rate	108
1821	sk5		ath0	read	mcs	rate	
1821	sk5		ath0	write	sf	reset	
1823	sk5		ath0	write	sf	add_flow	sk5:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=54
1829	sk5		ath0	read	sf	stats


# Probe link 5 - 3
1830.0	sk1		ath0	write	mcs	rate	36
1830.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
1830.0	sk2		ath0	write	mcs	rate	36
1830.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
1830.0	sk4		ath0	write	mcs	rate	36
1830.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
1830.0	sk6		ath0	write	mcs	rate	36
1830.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
1831	sk5		ath0	write	mcs	rate	12
1831	sk5		ath0	read	mcs	rate	
1831	sk5		ath0	write	sf	reset	
1833	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=6
1839	sk5		ath0	read	sf	stats

1841	sk5		ath0	write	mcs	rate	18
1841	sk5		ath0	read	mcs	rate	
1841	sk5		ath0	write	sf	reset	
1843	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=9
1849	sk5		ath0	read	sf	stats

1851	sk5		ath0	write	mcs	rate	24
1851	sk5		ath0	read	mcs	rate	
1851	sk5		ath0	write	sf	reset	
1853	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=12
1859	sk5		ath0	read	sf	stats

1861	sk5		ath0	write	mcs	rate	36
1861	sk5		ath0	read	mcs	rate	
1861	sk5		ath0	write	sf	reset	
1863	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=18
1869	sk5		ath0	read	sf	stats

1871	sk5		ath0	write	mcs	rate	48
1871	sk5		ath0	read	mcs	rate	
1871	sk5		ath0	write	sf	reset	
1873	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=24
1879	sk5		ath0	read	sf	stats

1881	sk5		ath0	write	mcs	rate	72
1881	sk5		ath0	read	mcs	rate	
1881	sk5		ath0	write	sf	reset	
1883	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=36
1889	sk5		ath0	read	sf	stats

1891	sk5		ath0	write	mcs	rate	96
1891	sk5		ath0	read	mcs	rate	
1891	sk5		ath0	write	sf	reset	
1893	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=48
1899	sk5		ath0	read	sf	stats

1901	sk5		ath0	write	mcs	rate	108
1901	sk5		ath0	read	mcs	rate	
1901	sk5		ath0	write	sf	reset	
1903	sk5		ath0	write	sf	add_flow	sk5:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=54
1909	sk5		ath0	read	sf	stats


# Probe link 5 - 4
1910.0	sk1		ath0	write	mcs	rate	36
1910.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
1910.0	sk2		ath0	write	mcs	rate	36
1910.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
1910.0	sk3		ath0	write	mcs	rate	36
1910.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
1910.0	sk6		ath0	write	mcs	rate	36
1910.1	sk6		ath0	write	sf	add_flow	sk6:eth sk7:eth 50 1500 2 80 true 1 0
1911	sk5		ath0	write	mcs	rate	12
1911	sk5		ath0	read	mcs	rate	
1911	sk5		ath0	write	sf	reset	
1913	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=6
1919	sk5		ath0	read	sf	stats

1921	sk5		ath0	write	mcs	rate	18
1921	sk5		ath0	read	mcs	rate	
1921	sk5		ath0	write	sf	reset	
1923	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=9
1929	sk5		ath0	read	sf	stats

1931	sk5		ath0	write	mcs	rate	24
1931	sk5		ath0	read	mcs	rate	
1931	sk5		ath0	write	sf	reset	
1933	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=12
1939	sk5		ath0	read	sf	stats

1941	sk5		ath0	write	mcs	rate	36
1941	sk5		ath0	read	mcs	rate	
1941	sk5		ath0	write	sf	reset	
1943	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=18
1949	sk5		ath0	read	sf	stats

1951	sk5		ath0	write	mcs	rate	48
1951	sk5		ath0	read	mcs	rate	
1951	sk5		ath0	write	sf	reset	
1953	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=24
1959	sk5		ath0	read	sf	stats

1961	sk5		ath0	write	mcs	rate	72
1961	sk5		ath0	read	mcs	rate	
1961	sk5		ath0	write	sf	reset	
1963	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=36
1969	sk5		ath0	read	sf	stats

1971	sk5		ath0	write	mcs	rate	96
1971	sk5		ath0	read	mcs	rate	
1971	sk5		ath0	write	sf	reset	
1973	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=48
1979	sk5		ath0	read	sf	stats

1981	sk5		ath0	write	mcs	rate	108
1981	sk5		ath0	read	mcs	rate	
1981	sk5		ath0	write	sf	reset	
1983	sk5		ath0	write	sf	add_flow	sk5:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=54
1989	sk5		ath0	read	sf	stats


# Probe link 5 - 6
1990.0	sk1		ath0	write	mcs	rate	36
1990.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
1990.0	sk2		ath0	write	mcs	rate	36
1990.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
1990.0	sk3		ath0	write	mcs	rate	36
1990.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
1990.0	sk4		ath0	write	mcs	rate	36
1990.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
1991	sk5		ath0	write	mcs	rate	12
1991	sk5		ath0	read	mcs	rate	
1991	sk5		ath0	write	sf	reset	
1993	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=6
1999	sk5		ath0	read	sf	stats

2001	sk5		ath0	write	mcs	rate	18
2001	sk5		ath0	read	mcs	rate	
2001	sk5		ath0	write	sf	reset	
2003	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=9
2009	sk5		ath0	read	sf	stats

2011	sk5		ath0	write	mcs	rate	24
2011	sk5		ath0	read	mcs	rate	
2011	sk5		ath0	write	sf	reset	
2013	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=12
2019	sk5		ath0	read	sf	stats

2021	sk5		ath0	write	mcs	rate	36
2021	sk5		ath0	read	mcs	rate	
2021	sk5		ath0	write	sf	reset	
2023	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=18
2029	sk5		ath0	read	sf	stats

2031	sk5		ath0	write	mcs	rate	48
2031	sk5		ath0	read	mcs	rate	
2031	sk5		ath0	write	sf	reset	
2033	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=24
2039	sk5		ath0	read	sf	stats

2041	sk5		ath0	write	mcs	rate	72
2041	sk5		ath0	read	mcs	rate	
2041	sk5		ath0	write	sf	reset	
2043	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=36
2049	sk5		ath0	read	sf	stats

2051	sk5		ath0	write	mcs	rate	96
2051	sk5		ath0	read	mcs	rate	
2051	sk5		ath0	write	sf	reset	
2053	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=48
2059	sk5		ath0	read	sf	stats

2061	sk5		ath0	write	mcs	rate	108
2061	sk5		ath0	read	mcs	rate	
2061	sk5		ath0	write	sf	reset	
2063	sk5		ath0	write	sf	add_flow	sk5:eth sk6:eth 0 1500 2 1000 true 1 0 mcs_rate=54
2069	sk5		ath0	read	sf	stats


# Probe link 6 - 1
2070.0	sk2		ath0	write	mcs	rate	36
2070.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
2070.0	sk3		ath0	write	mcs	rate	36
2070.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
2070.0	sk4		ath0	write	mcs	rate	36
2070.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
2070.0	sk5		ath0	write	mcs	rate	36
2070.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
2071	sk6		ath0	write	mcs	rate	12
2071	sk6		ath0	read	mcs	rate	
2071	sk6		ath0	write	sf	reset	
2073	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=6
2079	sk6		ath0	read	sf	stats

2081	sk6		ath0	write	mcs	rate	18
2081	sk6		ath0	read	mcs	rate	
2081	sk6		ath0	write	sf	reset	
2083	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=9
2089	sk6		ath0	read	sf	stats

2091	sk6		ath0	write	mcs	rate	24
2091	sk6		ath0	read	mcs	rate	
2091	sk6		ath0	write	sf	reset	
2093	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=12
2099	sk6		ath0	read	sf	stats

2101	sk6		ath0	write	mcs	rate	36
2101	sk6		ath0	read	mcs	rate	
2101	sk6		ath0	write	sf	reset	
2103	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=18
2109	sk6		ath0	read	sf	stats

2111	sk6		ath0	write	mcs	rate	48
2111	sk6		ath0	read	mcs	rate	
2111	sk6		ath0	write	sf	reset	
2113	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=24
2119	sk6		ath0	read	sf	stats

2121	sk6		ath0	write	mcs	rate	72
2121	sk6		ath0	read	mcs	rate	
2121	sk6		ath0	write	sf	reset	
2123	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=36
2129	sk6		ath0	read	sf	stats

2131	sk6		ath0	write	mcs	rate	96
2131	sk6		ath0	read	mcs	rate	
2131	sk6		ath0	write	sf	reset	
2133	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=48
2139	sk6		ath0	read	sf	stats

2141	sk6		ath0	write	mcs	rate	108
2141	sk6		ath0	read	mcs	rate	
2141	sk6		ath0	write	sf	reset	
2143	sk6		ath0	write	sf	add_flow	sk6:eth sk1:eth 0 1500 2 1000 true 1 0 mcs_rate=54
2149	sk6		ath0	read	sf	stats


# Probe link 6 - 2
2150.0	sk1		ath0	write	mcs	rate	36
2150.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
2150.0	sk3		ath0	write	mcs	rate	36
2150.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
2150.0	sk4		ath0	write	mcs	rate	36
2150.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
2150.0	sk5		ath0	write	mcs	rate	36
2150.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
2151	sk6		ath0	write	mcs	rate	12
2151	sk6		ath0	read	mcs	rate	
2151	sk6		ath0	write	sf	reset	
2153	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=6
2159	sk6		ath0	read	sf	stats

2161	sk6		ath0	write	mcs	rate	18
2161	sk6		ath0	read	mcs	rate	
2161	sk6		ath0	write	sf	reset	
2163	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=9
2169	sk6		ath0	read	sf	stats

2171	sk6		ath0	write	mcs	rate	24
2171	sk6		ath0	read	mcs	rate	
2171	sk6		ath0	write	sf	reset	
2173	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=12
2179	sk6		ath0	read	sf	stats

2181	sk6		ath0	write	mcs	rate	36
2181	sk6		ath0	read	mcs	rate	
2181	sk6		ath0	write	sf	reset	
2183	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=18
2189	sk6		ath0	read	sf	stats

2191	sk6		ath0	write	mcs	rate	48
2191	sk6		ath0	read	mcs	rate	
2191	sk6		ath0	write	sf	reset	
2193	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=24
2199	sk6		ath0	read	sf	stats

2201	sk6		ath0	write	mcs	rate	72
2201	sk6		ath0	read	mcs	rate	
2201	sk6		ath0	write	sf	reset	
2203	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=36
2209	sk6		ath0	read	sf	stats

2211	sk6		ath0	write	mcs	rate	96
2211	sk6		ath0	read	mcs	rate	
2211	sk6		ath0	write	sf	reset	
2213	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=48
2219	sk6		ath0	read	sf	stats

2221	sk6		ath0	write	mcs	rate	108
2221	sk6		ath0	read	mcs	rate	
2221	sk6		ath0	write	sf	reset	
2223	sk6		ath0	write	sf	add_flow	sk6:eth sk2:eth 0 1500 2 1000 true 1 0 mcs_rate=54
2229	sk6		ath0	read	sf	stats


# Probe link 6 - 3
2230.0	sk1		ath0	write	mcs	rate	36
2230.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
2230.0	sk2		ath0	write	mcs	rate	36
2230.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
2230.0	sk4		ath0	write	mcs	rate	36
2230.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
2230.0	sk5		ath0	write	mcs	rate	36
2230.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
2231	sk6		ath0	write	mcs	rate	12
2231	sk6		ath0	read	mcs	rate	
2231	sk6		ath0	write	sf	reset	
2233	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=6
2239	sk6		ath0	read	sf	stats

2241	sk6		ath0	write	mcs	rate	18
2241	sk6		ath0	read	mcs	rate	
2241	sk6		ath0	write	sf	reset	
2243	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=9
2249	sk6		ath0	read	sf	stats

2251	sk6		ath0	write	mcs	rate	24
2251	sk6		ath0	read	mcs	rate	
2251	sk6		ath0	write	sf	reset	
2253	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=12
2259	sk6		ath0	read	sf	stats

2261	sk6		ath0	write	mcs	rate	36
2261	sk6		ath0	read	mcs	rate	
2261	sk6		ath0	write	sf	reset	
2263	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=18
2269	sk6		ath0	read	sf	stats

2271	sk6		ath0	write	mcs	rate	48
2271	sk6		ath0	read	mcs	rate	
2271	sk6		ath0	write	sf	reset	
2273	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=24
2279	sk6		ath0	read	sf	stats

2281	sk6		ath0	write	mcs	rate	72
2281	sk6		ath0	read	mcs	rate	
2281	sk6		ath0	write	sf	reset	
2283	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=36
2289	sk6		ath0	read	sf	stats

2291	sk6		ath0	write	mcs	rate	96
2291	sk6		ath0	read	mcs	rate	
2291	sk6		ath0	write	sf	reset	
2293	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=48
2299	sk6		ath0	read	sf	stats

2301	sk6		ath0	write	mcs	rate	108
2301	sk6		ath0	read	mcs	rate	
2301	sk6		ath0	write	sf	reset	
2303	sk6		ath0	write	sf	add_flow	sk6:eth sk3:eth 0 1500 2 1000 true 1 0 mcs_rate=54
2309	sk6		ath0	read	sf	stats


# Probe link 6 - 4
2310.0	sk1		ath0	write	mcs	rate	36
2310.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
2310.0	sk2		ath0	write	mcs	rate	36
2310.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
2310.0	sk3		ath0	write	mcs	rate	36
2310.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
2310.0	sk5		ath0	write	mcs	rate	36
2310.1	sk5		ath0	write	sf	add_flow	sk5:eth sk7:eth 50 1500 2 80 true 1 0
2311	sk6		ath0	write	mcs	rate	12
2311	sk6		ath0	read	mcs	rate	
2311	sk6		ath0	write	sf	reset	
2313	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=6
2319	sk6		ath0	read	sf	stats

2321	sk6		ath0	write	mcs	rate	18
2321	sk6		ath0	read	mcs	rate	
2321	sk6		ath0	write	sf	reset	
2323	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=9
2329	sk6		ath0	read	sf	stats

2331	sk6		ath0	write	mcs	rate	24
2331	sk6		ath0	read	mcs	rate	
2331	sk6		ath0	write	sf	reset	
2333	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=12
2339	sk6		ath0	read	sf	stats

2341	sk6		ath0	write	mcs	rate	36
2341	sk6		ath0	read	mcs	rate	
2341	sk6		ath0	write	sf	reset	
2343	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=18
2349	sk6		ath0	read	sf	stats

2351	sk6		ath0	write	mcs	rate	48
2351	sk6		ath0	read	mcs	rate	
2351	sk6		ath0	write	sf	reset	
2353	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=24
2359	sk6		ath0	read	sf	stats

2361	sk6		ath0	write	mcs	rate	72
2361	sk6		ath0	read	mcs	rate	
2361	sk6		ath0	write	sf	reset	
2363	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=36
2369	sk6		ath0	read	sf	stats

2371	sk6		ath0	write	mcs	rate	96
2371	sk6		ath0	read	mcs	rate	
2371	sk6		ath0	write	sf	reset	
2373	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=48
2379	sk6		ath0	read	sf	stats

2381	sk6		ath0	write	mcs	rate	108
2381	sk6		ath0	read	mcs	rate	
2381	sk6		ath0	write	sf	reset	
2383	sk6		ath0	write	sf	add_flow	sk6:eth sk4:eth 0 1500 2 1000 true 1 0 mcs_rate=54
2389	sk6		ath0	read	sf	stats


# Probe link 6 - 5
2390.0	sk1		ath0	write	mcs	rate	36
2390.1	sk1		ath0	write	sf	add_flow	sk1:eth sk7:eth 50 1500 2 80 true 1 0
2390.0	sk2		ath0	write	mcs	rate	36
2390.1	sk2		ath0	write	sf	add_flow	sk2:eth sk7:eth 50 1500 2 80 true 1 0
2390.0	sk3		ath0	write	mcs	rate	36
2390.1	sk3		ath0	write	sf	add_flow	sk3:eth sk7:eth 50 1500 2 80 true 1 0
2390.0	sk4		ath0	write	mcs	rate	36
2390.1	sk4		ath0	write	sf	add_flow	sk4:eth sk7:eth 50 1500 2 80 true 1 0
2391	sk6		ath0	write	mcs	rate	12
2391	sk6		ath0	read	mcs	rate	
2391	sk6		ath0	write	sf	reset	
2393	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=6
2399	sk6		ath0	read	sf	stats

2401	sk6		ath0	write	mcs	rate	18
2401	sk6		ath0	read	mcs	rate	
2401	sk6		ath0	write	sf	reset	
2403	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=9
2409	sk6		ath0	read	sf	stats

2411	sk6		ath0	write	mcs	rate	24
2411	sk6		ath0	read	mcs	rate	
2411	sk6		ath0	write	sf	reset	
2413	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=12
2419	sk6		ath0	read	sf	stats

2421	sk6		ath0	write	mcs	rate	36
2421	sk6		ath0	read	mcs	rate	
2421	sk6		ath0	write	sf	reset	
2423	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=18
2429	sk6		ath0	read	sf	stats

2431	sk6		ath0	write	mcs	rate	48
2431	sk6		ath0	read	mcs	rate	
2431	sk6		ath0	write	sf	reset	
2433	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=24
2439	sk6		ath0	read	sf	stats

2441	sk6		ath0	write	mcs	rate	72
2441	sk6		ath0	read	mcs	rate	
2441	sk6		ath0	write	sf	reset	
2443	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=36
2449	sk6		ath0	read	sf	stats

2451	sk6		ath0	write	mcs	rate	96
2451	sk6		ath0	read	mcs	rate	
2451	sk6		ath0	write	sf	reset	
2453	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=48
2459	sk6		ath0	read	sf	stats

2461	sk6		ath0	write	mcs	rate	108
2461	sk6		ath0	read	mcs	rate	
2461	sk6		ath0	write	sf	reset	
2463	sk6		ath0	write	sf	add_flow	sk6:eth sk5:eth 0 1500 2 1000 true 1 0 mcs_rate=54
2469	sk6		ath0	read	sf	stats


