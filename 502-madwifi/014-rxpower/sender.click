BRNAddressInfo(my_wlan NODEDEVICE:eth);

BRN2PacketSource(SIZE 150, INTERVAL 200, MAXSEQ 500000, BURST 1, ACTIVE true)
 -> EtherEncap(0x8088, my_wlan, FF-FF-FF-FF-FF-FF)
 -> WifiEncap(0x00, 0:0:0:0:0:0)
 -> SetTXRate(RATE 2)
 -> SetTXPower(VAR_CLICK_POWER)
 -> __WIFIENCAP__
 -> wlan_out_queue :: NotifierQueue(100);
 -> TORAWDEVICE(NODEDEVICE);
