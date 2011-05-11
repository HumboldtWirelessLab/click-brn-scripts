#include "dht/storage/dht_storage.click"

BRNAddressInfo(my_ip eth0:ip);
BRNAddressInfo(server_eth 00-01-02-03-04-05);
BRNAddressInfo(server_ip 192.168.100.1);


arp_tab :: ARPTable();
rev_arp_tap :: ReverseARPTable();
toTunnel::Null();
toResolvTunnel::Null();

Idle -> dhtstorage::DHT_STORAGE(DEBUG 2) -> Discard;
dsnl::BRN2DHCPSubnetList();
lease_tab::BRN2DHCPLeaseTable(DEBUG 2);

dh::BRN2DHCPServer( ETHERADDRESS server_eth, ADDRESSPREFIX 192.168.100.0/24,
                    ROUTER server_ip, SERVER server_ip, DNS 192.168.4.188,
                    SERVERNAME hwl, DOMAIN hwl, DHCPSUBNETLIST dsnl, DHTSTORAGE dhtstorage/dhtstorage,
                    LEASETABLE lease_tab, DEBUG 2);

  dhcp::Null()
  -> BRN2EtherDecap()
  -> CheckIPHeader()
  -> StripIPHeader()
  -> Strip(8)
  -> dh;

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
-> ar::ARPResponder(server_ip server_eth)
-> Print("ARP-Replay (Gateway)")
-> toTunnel;

service_clf[1]
-> dhcp;

service_clf[2]
-> Discard;


FromHost(tap0, DST 192.168.100.0/24, ETHER server_eth)
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
 -> ip_clf::Classifier(12/0800,
                       12/0800 23/11 36/0043)
//-> SetPacketType(HOST)
 -> th;

 ip_clf[1]
 -> dhcp;
 
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


dh[0]
-> UDPIPEncap(server_ip, 67, 255.255.255.255, 68)
-> BRN2EtherEncap(USEANNO true)
-> toTunnel;


Script (
  write resolve.debug 4
);

