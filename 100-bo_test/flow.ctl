#TIME	NODE(S)		DEVICE	MODE	ELEMENT	HANDLER		VALUE

# SCD Flows:
# ==========

#0 sk1  ath0 write sf add_flow sk1:eth  sk2:eth 0 1500 0 60000 true
#0 sk2  ath0 write sf add_flow sk2:eth  sk1:eth 0 1500 0 60000 true
#0 sk3  ath0 write sf add_flow sk3:eth  sk1:eth 0 1500 0 60000 true
#0 sk4  ath0 write sf add_flow sk4:eth  sk1:eth 0 1500 0 60000 true
#0 sk5  ath0 write sf add_flow sk5:eth  sk1:eth 0 1500 0 60000 true
#0 sk6  ath0 write sf add_flow sk6:eth  sk1:eth 0 1500 0 60000 true
#0 sk7  ath0 write sf add_flow sk7:eth  sk1:eth 0 1500 0 60000 true
#0 sk8  ath0 write sf add_flow sk8:eth  sk1:eth 0 1500 0 60000 true
#0 sk9  ath0 write sf add_flow sk9:eth  sk1:eth 0 1500 0 60000 true
#0 sk10 ath0 write sf add_flow sk10:eth sk1:eth 0 1500 0 60000 true
#0 sk11 ath0 write sf add_flow sk11:eth sk1:eth 0 1500 0 60000 true

# HN Flows:
# =========
0 sk1  ath0 write sf add_flow sk1:eth  sk2:eth 0 1500 0 60000 true
0 sk3  ath0 write sf add_flow sk3:eth  sk2:eth 0 1500 0 60000 true


# Stats:
#=======
	60 sk1 ath0 read sf stats
	60 sk2 ath0 read sf stats
	60 sk3 ath0 read sf stats
#60 sk4 ath0 read sf stats
#60 sk5 ath0 read sf stats
#60 sk6 ath0 read sf stats
#60 sk7 ath0 read sf stats
#60 sk8 ath0 read sf stats
#60 sk9 ath0 read sf stats
#60 sk10 ath0 read sf stats
#60 sk11 ath0 read sf stats

	60 sk1 ath0 read device_wifi/cocst stats
	60 sk2 ath0 read device_wifi/cocst stats
	60 sk3 ath0 read device_wifi/cocst stats

#10 sk1 ath0 read device_wifi/wifidevice/tosq stats
#10 sk2 ath0 read device_wifi/wifidevice/tosq stats
#10 sk3 ath0 read device_wifi/wifidevice/tosq stats



