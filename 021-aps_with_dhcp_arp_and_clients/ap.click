#define DEBUGLEVEL 2
#define LINKSTAT_ENABLE

#include "brn/brn.click"
#include "device/wifidev_ap.click"
#include "dht/routing/dht_falcon.click"
#include "dht/storage/dht_storage.click"
#include "routing/dsr.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME "NODENAME", DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);
routingtable::BrnRoutingTable(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
routingalgo::Dijkstra(NODEIDENTITY id, LINKTABLE lt, MIN_LINK_METRIC_IN_ROUTE 6000, MAXGRAPHAGE 30000, DEBUG 4);
routingmaint::RoutingMaintenance(NODEIDENTITY id, LINKTABLE lt, ROUTETABLE routingtable, ROUTINGALGORITHM routingalgo, DEBUG 2);

device_wifi::WIFIDEV_AP(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", CHANNEL 5, LT lt);

dsr::DSR(id, lt, device_wifi/etx_metric,routingmaint);

dht::DHT_FALCON(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 30000, UPDATEINT 2000, DEBUG 2);
dhtstorage :: DHT_STORAGE( DHTROUTING dht/dhtrouting , DEBUG 2);

dsnl::BRN2DHCPSubnetList();
  
dh::BRN2DHCPServer( ETHERADDRESS deviceaddress, ADDRESSPREFIX 192.168.0.0/24,
                    ROUTER 192.168.0.1, SERVER 192.168.0.1, DNS 192.168.0.1, SERVERNAME foo, DOMAIN bla,
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
  
device_wifi[2] -> Discard; //[0]dsr;  //foreign and brn

device_wifi[3] -> Discard;  //to me no brn

device_wifi[4]            //broadcast and no brn
    -> dhcp_arp_clf::Classifier( 12/0800,
                                 12/0806,
                                     -   )

    -> BRN2EtherDecap()
    -> Strip(28) // strip ip and udp
    -> dh
    -> UDPIPEncap(192.168.0.1, 67, 255.255.255.255, 68)
    -> EtherEncap(0x0800, deviceaddress , ff:ff:ff:ff:ff:ff)
    -> [1]device_wifi;

dhcp_arp_clf[1]
-> arps
-> [1]device_wifi;

dhcp_arp_clf[2]
-> Discard;

device_wifi[5] //foreign and no brn
 -> [0]dsr;


dsr[0]
  -> toMeAfterDsr::BRN2ToThisNode(NODEIDENTITY id);
  
dsr[1] 
  //-> Print("DSR[1]-out")
  -> BRN2EtherEncap(SRC deviceaddress, PUSHHEADER false)
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
Idle -> [3]dsr;
Idle -> [4]dsr;
brn_clf[3] -> Discard;

Script(
  read dsnl.info,
  wait 10,
  read device_wifi/ap/assoclist.stations,
  //read lt.links
  //read lt.hosts
  
);
