AddressInfo(my_wlan NODEDEVICE:eth);

FROMRAWDEVICE(NODEDEVICE)
  //-> Discard;
  -> TODUMP("RESULTDIR/NODENAME.NODEDEVICE.dump");

ps::BRN2PacketSource(SIZE 1450, INTERVAL 15, MAXSEQ 500000, BURST 1, ACTIVE true)
//  -> EtherEncap(0x8088, my_wlan,  06-0B-6B-09-ED-73 )
  -> EtherEncap(0x8088, my_wlan,  FF:FF:FF:FF:FF:FF )
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRate(2)
  -> wlan_out::SetTXPower(15);

wlan_out
  -> SetPacketAnno(TOS 3)
  -> __WIFIENCAP__
  -> rawouttee :: Tee()
  -> NotifierQueue(30)
  -> outct::Counter()
  -> TORAWDEVICE(NODEDEVICE);

rawouttee[1]
  -> TODUMP("RESULTDIR/NODENAME.NODEDEVICE.out.dump");
//-> Discard;

