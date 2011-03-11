BRNAddressInfo(my_wlan NODEDEVICE:eth);
BRNAddressInfo(my_wlan_2 ath1:eth);

FROMRAWDEVICE(NODEDEVICE)
 -> tdraw :: ToDump("RESULTDIR/NODENAME.NODEDEVICE.dump");

FROMRAWDEVICE(ath1)
 -> tdraw_2 :: ToDump("RESULTDIR/NODENAME.ath1.dump");

BRN2PacketSource(SIZE 150, INTERVAL 100, MAXSEQ 500000, BURST 1, ACTIVE true)
 -> rrs::RoundRobinSwitch()
 -> EtherEncap(0x8088, my_wlan, FF-FF-FF-FF-FF-FF)
 -> WifiEncap(0x00, 0:0:0:0:0:0)
 -> SetTXRate(RATE 2)
 -> __WIFIENCAP__
 -> wlan_out_queue :: NotifierQueue(100)
 -> TORAWDEVICE(NODEDEVICE);

 rrs[1]
 -> EtherEncap(0x8088, my_wlan_2, FF-FF-FF-FF-FF-FF)
 -> WifiEncap(0x00, 0:0:0:0:0:0)
 -> SetTXRate(RATE 2)
 -> __WIFIENCAP__
 -> wlan_out_queue_2 :: NotifierQueue(100)
 -> TORAWDEVICE(ath1);
