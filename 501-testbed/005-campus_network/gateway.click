
arp_tab :: ARPTable();
rev_arp_tap :: ReverseARPTable();

raws::RawSocket(TYPE UDP, PORT 10000 )
-> IPClassifier(dst udp port 10000)
-> IPClassifier(src udp port 10001)
-> Print("Receive packet from ap")

/*Tunnel-Decap*/
-> CheckIPHeader()
-> IPPrint("From Tunnel")
-> StripIPHeader()
-> Strip(8)
-> Print("Store tunnel endpoint")
-> StoreTunnelEndpoint(REVERSEARPTABLE rev_arp_tap, DEBUG 4)
/*Tunnel-Decap end*/

/* To Net */
-> Print("Store Arp")
-> StoreIPEthernet(arp_tab)
-> BRN2EtherDecap()
-> CheckIPHeader(OFFSET 0)
-> IPPrint("Post Mirror")
-> IPMirror()
-> Print("Resolv arp")
-> resolve :: ResolveEthernet( 00:01:02:03:04:04, arp_tab)
/* To Net end*/

/*Tunnel Encap*/
-> Print("Restore tunnel endpoint")
-> UDPIPEncap(SRC 192.168.3.1, SPORT 10000, DST 127.0.0.1, DPORT 10001)
-> RestoreTunnelEndpoint(REVERSEARPTABLE rev_arp_tap, DEBUG 4)
-> CheckIPHeader()
-> IPPrint("Pre Tunnel")
-> Print("Send")
/*Tunnel Encap end*/

-> wifioutq::NotifierQueue(1000)
-> raws;