BRNAddressInfo(my_ip eth0:ip);

arp_tab :: ARPTable();
rev_arp_tap :: ReverseARPTable();
toTunnel::Null();
toResolvTunnel::Null();

raws::RawSocket(TYPE UDP, PORT 10000 )
-> IPClassifier(dst udp port 10000)
//-> IPClassifier(src udp port 10000)
-> Print("------------------Receive packet from ap")


-> CheckIPHeader()
-> IPPrint("From Tunnel")
-> StripIPHeader()
-> Strip(8)
-> Print("Store tunnel endpoint")
-> StoreTunnelEndpoint(REVERSEARPTABLE rev_arp_tap, DEBUG 4)



-> Print("Store SRC Client IP-MAC")
-> StoreIPEthernet(arp_tab)
-> bc_clf::Classifier( 0/ffffffffffff,
                       0/000102030405,
                              - );

bc_clf[0]
-> service_clf::Classifier( 12/0806,
                             12/0800 23/11 36/0043,
                             - );


service_clf[0]
-> Print("ARP-Request (Gateway)")
-> ar::ARPResponder(192.168.100.1 00-01-02-03-04-05)
-> Print("ARP-Replay (Gateway)")
-> toTunnel;

service_clf[1]
-> Print("DHCP-Request")
-> Discard;

service_clf[2]
-> Discard;


FromHost(tap0, DST 192.168.100.0/24, ETHER 00-01-02-03-04-05)
 -> fh_bc_clf::Classifier( 0/ffffffffffff,  - )
 -> fh_service_clf::Classifier( 12/0806,   - )
 -> parp::Print("ARP-Request (Kernel) -> Fake reply")
 -> far::ARPResponder(192.168.100.0/24 00-01-02-03-04-06)
 -> Print("ARP-Replay (Kernel) - Faked")
 -> th::ToHost(tap0);

 fh_service_clf[1] -> Discard;

 fh_bc_clf[1]
 -> Print("Unicats from Tap (Net)")
 -> uni_service_clf::Classifier( 12/0806,  - )
 -> parp;

 uni_service_clf[1]
 -> BRN2EtherDecap()
 -> CheckIPHeader(OFFSET 0)
 -> IPPrint("Unicast from tap")
 -> toResolvTunnel;



 bc_clf[1]
 -> Print("For the Gateway (Net)")
 -> ip_clf::Classifier(12/0800)
// -> SetPacketType(HOST)
 -> th;

 bc_clf[2]
 -> Discard();


toResolvTunnel
-> Print("Resolv Ethernet from Client")
-> resolve :: ResolveEthernet( 00:01:02:03:04:05, arp_tab)
-> valid_clf::Classifier( 0/ffffffffffff, - )
-> Discard;
valid_clf[1]
-> Print("Send Ethernetframe to tunnel")

-> toTunnel
-> Print("Restore tunnel endpoint")
-> UDPIPEncap(SRC my_ip, SPORT 10000, DST 127.0.0.1, DPORT 10000)
-> RestoreTunnelEndpoint(REVERSEARPTABLE rev_arp_tap, DEBUG 4)
-> SetIPChecksum()
-> CheckIPHeader(VERBOSE true)
-> IPPrint("To Tunnel")
-> Print("Send")
-> wifioutq::NotifierQueue(1000)
-> Print("push send")
-> raws;


Script (
  write resolve.debug 4
);

