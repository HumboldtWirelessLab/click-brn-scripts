#TIME	NODE(S)		DEVICE	MODE	ELEMENT	HANDLER		VALUE

# Flows:
# ======
  0 sk1  ath0 write sf add_flow sk1:eth  sk2:eth 50 1500 0 120000 true
#0 sk2  ath0 write sf add_flow sk2:eth  sk1:eth 50 1500 0 120000 true
  0 sk3  ath0 write sf add_flow sk3:eth  sk2:eth 50 1500 0 120000 true
  0 sk4  ath0 write sf add_flow sk4:eth  sk2:eth 50 1500 0 120000 true
  0 sk5  ath0 write sf add_flow sk5:eth  sk2:eth 50 1500 0 120000 true


# SimpleFlow Stats:
#==================
	120 sk1 ath0 read sf stats
  120 sk2 ath0 read sf stats
	120 sk3 ath0 read sf stats
  120 sk4 ath0 read sf stats
  120 sk5 ath0 read sf stats


# Cooperative ChannelStats:
#==========================
  120 sk1 ath0 read device_wifi/cocst stats
  120 sk2 ath0 read device_wifi/cocst stats
  120 sk3 ath0 read device_wifi/cocst stats
  120 sk4 ath0 read device_wifi/cocst stats
  120 sk5 ath0 read device_wifi/cocst stats


# TOS to Queue Mapper Stats:
#===========================
  120 sk1 ath0 read device_wifi/wifidevice/tosq stats
  120 sk2 ath0 read device_wifi/wifidevice/tosq stats
  120 sk3 ath0 read device_wifi/wifidevice/tosq stats
  120 sk4 ath0 read device_wifi/wifidevice/tosq stats
  120 sk5 ath0 read device_wifi/wifidevice/tosq stats

