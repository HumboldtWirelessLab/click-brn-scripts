#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/simdev.click"
#include "device/wifidev_ap.click"
#include "dht/routing/dht_falcon.click"
#include "dht/storage/dht_storage.click"
#include "routing/dsr.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITIY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 15000, DEBUG 2);

device_wifi::WIFIDEV_AP(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", CHANNEL 5, LT lt);

dsr::DSR(id,lt,rc);

dht::DHT_FALCON(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 10000, UPDATEINT 1000, DEBUG 2);
dhtstorage :: DHT_STORAGE( DHTROUTING dht/dhtrouting, DEBUG 2);

dsnl::BRN2DHCPSubnetList();
  
dh::BRN2DHCPServer( ETHERADDRESS deviceaddress, ADDRESSPREFIX 192.168.0.0/24,
                    ROUTER 192.168.0.1, SERVER 192.168.0.1, DNS 192.168.0.1, SERVERNAME "www", DOMAIN ".bloblo.org",
                    DHCPSUBNETLIST dsnl, DHTSTORAGE dhtstorage/dhtstorage );

arps::BRN2Arp(ROUTERIP 192.168.0.1, ROUTERETHERADDRESS deviceaddress, PREFIX 192.168.0.0/24, DHTSTORAGE dhtstorage/dhtstorage);

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
//-> Print("Foo",100)
  -> brn_clf::Classifier(  0/BRN_PORT_DSR,  //BrnDSR
                           0/BRN_PORT_DHTROUTING,  //DHT-Routing
                           0/BRN_PORT_DHTSTORAGE,  //DHT-Storage
                            -  );//other
  
brn_clf[0]
  //-> Print("DSR-Packet")
  -> [1]dsr;
  
brn_clf[1]
//-> Print("Routing-Packet",100)
  -> BRN2Decap()
  -> [0]dht[0]
  -> dht_r_all::Counter()
//-> Print("out Routing-Packet")
  -> [0]dsr;
  
dht[1]
//-> Print("routing-Packet-out")
  -> dht_r_neighbour::Counter()
  -> [0]device_wifi;

brn_clf[2]
//-> Print("Storage-Packet")
  -> BRN2Decap()
  -> dhtstorage
  -> dht_s::Counter()
//-> Print("Storage-Packet-out")
  -> [0]dsr;

device_wifi[1]       //broadcast and brn
//-> Print("BRN-In")
  -> BRN2EtherDecap()
  -> brn_clf;
  
device_wifi[2] -> [0]dsr;  //foreign and brn

device_wifi[3] -> Discard;  //to me no brn

device_wifi[4]            //broadcast and no brn
    -> Print("AP got client request")
    -> dhcp_arp_clf::Classifier( 12/0800,
                                 12/0806,
                                     -   )

    -> Print("AP got ip")
    -> BRN2EtherDecap()
    -> CheckIPHeader(0)
    -> ip_classifier :: IPClassifier(dst udp port 67 and src udp port 68,
                                     dst udp port 53,
                                     -)
    -> Print("Got dhcp request")
    -> Strip(28) // strip ip and udp
    -> dh
    -> UDPIPEncap(192.168.0.1, 67, 255.255.255.255, 68)
    -> EtherEncap(0x0800, deviceaddress , ff:ff:ff:ff:ff:ff)
    -> Print("DNS reply")
    -> [1]device_wifi;

ip_classifier[1]
-> Print("Receive DNS-request")
-> Strip(28) // strip ip and udp
-> bind::BRN2DNSServer(SERVERNAME ".www", DOMAIN ".bloblo.org",SERVER 192.168.0.1, DHTSTORAGE dhtstorage/dhtstorage, DEBUG 4)
-> UDPIPEncap( 192.168.0.1 , 53 ,192.168.0.5 , 39000)
-> CheckIPHeader()
-> EtherEncap(0x0800, 00:0f:00:00:01:00,00:0f:00:00:00:00 )
-> [1]device_wifi;

bind[1] -> Discard;

ip_classifier[2]
-> Discard;

dhcp_arp_clf[1]
-> Print("got Arp request")
-> arps
-> Print("send Arp reply")
-> [1]device_wifi;

dhcp_arp_clf[2]
-> Discard;

device_wifi[5] //foreign and no brn
 -> [0]dsr;


dsr[0]
  -> toMeAfterDsr::BRN2ToThisNode(NODEIDENTITY id);
  
dsr[1] 
  //-> Print("DSR[1]-out")
  -> BRN2EtherEncap()
  -> SetEtherAddr(SRC deviceaddress)
  //-> Print("DSR-Ether-OUT")
  -> [0]device_wifi;

toMeAfterDsr[0] 
  //-> Print("DSR-out: For ME",100)
  -> Label_brnether; 
  
toMeAfterDsr[1]
  //-> Print("DSR-out: Broadcast")
  -> Discard;

toMeAfterDsr[2]
  //-> Print("DSR-out: Foreign/Client")
  -> [1]device_wifi;

Idle -> [2]dsr;
brn_clf[3] -> Discard;

Script(
  read dsnl.info,
  wait 10,
  read device_wifi/ap/assoclist.stations,
  //read lt.links
  //read lt.hosts
  
);
