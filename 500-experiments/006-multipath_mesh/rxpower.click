BRNAddressInfo(my_wlan NODEDEVICE:eth);

FROMRAWDEVICE(NODEDEVICE)
 -> tdraw :: ToDump("RESULTDIR/NODENAME.NODEDEVICE.dump");

BRN2PacketSource(SIZE 20, INTERVAL 200, MAXSEQ 500000, BURST 1, ACTIVE true)
 -> EtherEncap(0x8088, my_wlan, FF-FF-FF-FF-FF-FF)
 -> WifiEncap(0x00, 0:0:0:0:0:0)
 -> SetTXRate(RATE 2)
// -> SetTXPower(61)
 -> __WIFIENCAP__
 -> wlan_out_queue :: NotifierQueue(100)
 -> TORAWDEVICE(NODEDEVICE);
