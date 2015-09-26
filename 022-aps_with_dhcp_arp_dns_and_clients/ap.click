#ifndef DEBUGLEVEL
#define DEBUGLEVEL 1
#endif

#define LINKSTAT_ENABLE

#include "brn/brn.click"
#include "device/wifidev_ap.click"
#include "dht/routing/dht_falcon.click"
#include "dht/storage/dht_storage.click"
#include "routing/dsr.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);
routingtable::BrnRoutingTable(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
routingalgo::Dijkstra(NODEIDENTITY id, LINKTABLE lt, MIN_LINK_METRIC_IN_ROUTE 6000, MAXGRAPHAGE 30000, DEBUG 4);
routingmaint::RoutingMaintenance(NODEIDENTITY id, LINKTABLE lt, ROUTETABLE routingtable, ROUTINGALGORITHM routingalgo, DEBUG 2);

device_wifi::WIFIDEV_AP(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", CHANNEL 5, LT lt);

dsr::DSR(id, lt, device_wifi/etx_metric,routingmaint);

dht::DHT_FALCON(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 30000, UPDATEINT 2000, DEBUG 2);
dhtstorage :: DHT_STORAGE( DHTROUTING dht/dhtrouting, DEBUG 2);

dsnl::BRN2DHCPSubnetList();
  
lease_tab::BRN2DHCPLeaseTable();

dh::BRN2DHCPServer( ETHERADDRESS deviceaddress, ADDRESSPREFIX 192.168.0.0/24,
                    ROUTER 192.168.0.1, SERVER 192.168.0.1, DNS 192.168.0.1, SERVERNAME "www", DOMAIN ".bloblo.org",
                    DHCPSUBNETLIST dsnl, DHTSTORAGE dhtstorage/dhtstorage, LEASETABLE lease_tab );

arps::BRN2Arp(ROUTERIP 192.168.0.1, ROUTERETHERADDRESS deviceaddress, PREFIX 192.168.0.0/24, DHTSTORAGE dhtstorage/dhtstorage);

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
  -> brn_clf::Classifier(  0/BRN_PORT_DSR,  //BrnDSR
                           0/BRN_PORT_DHTROUTING,  //DHT-Routing
                           0/BRN_PORT_DHTSTORAGE,  //DHT-Storage
                            -  );//other
  
brn_clf[0]
  -> [1]dsr;
  
brn_clf[1]
  -> BRN2Decap()
  -> [0]dht[0]
  -> dht_r_all::Counter()
  -> [0]dsr;
  
dht[1]
  -> dht_r_neighbour::Counter()
  -> [0]device_wifi;

brn_clf[2]
  -> BRN2Decap()
  -> dhtstorage
  -> dht_s::Counter()
  -> [0]dsr;

device_wifi[1]       //broadcast and brn
  -> BRN2EtherDecap()
  -> brn_clf;
  
device_wifi[2] -> Discard; //[0]dsr;  //foreign and brn

device_wifi[3] -> Discard;  //to me no brn

device_wifi[4]            //broadcast and no brn
#if DEBUGLEVEL > 3
    -> Print("AP got client request")
#endif
    -> dhcp_arp_clf::Classifier( 12/0800,
                                 12/0806,
                                     -   )

#if DEBUGLEVEL > 3
    -> Print("AP got ip")
#endif
    -> BRN2EtherDecap()
    -> CheckIPHeader(0)
    -> ip_classifier :: IPClassifier(dst udp port 67 and src udp port 68,
                                     dst udp port 53,
                                     -)
#if DEBUGLEVEL > 3
    -> Print("Got dhcp request")
#endif
    -> Strip(28) // strip ip and udp
    -> dh
    -> UDPIPEncap(192.168.0.1, 67, 255.255.255.255, 68)
    -> EtherEncap(0x0800, deviceaddress , ff:ff:ff:ff:ff:ff)
#if DEBUGLEVEL > 3
    -> Print("DHCP reply")
#endif
    -> [1]device_wifi;

ip_classifier[1]
#if DEBUGLEVEL > 3
    -> Print("Receive DNS-request")
#endif
    -> Strip(28) // strip ip and udp
    -> bind::BRN2DNSServer(SERVERNAME ".www", DOMAIN ".bloblo.org",SERVER 192.168.0.1, DHTSTORAGE dhtstorage/dhtstorage, DEBUG 2)
    -> UDPIPEncap( 192.168.0.1 , 53 ,192.168.0.5 , 39000)
    -> CheckIPHeader()
    -> EtherEncap(0x0800, deviceaddress, /*00:00:00:00:00:02*/ ff:ff:ff:ff:ff:ff )
    -> [1]device_wifi;

bind[1] -> Discard;

ip_classifier[2]
    -> Discard;

dhcp_arp_clf[1]
#if DEBUGLEVEL > 3
    -> Print("got Arp request")
#endif
    -> arps
#if DEBUGLEVEL > 3
    -> Print("send Arp reply")
#endif
    -> [1]device_wifi;

dhcp_arp_clf[2]
    -> Discard;

device_wifi[5] //foreign and no brn
    -> [0]dsr;

dsr[0] -> toMeAfterDsr::BRN2ToThisNode(NODEIDENTITY id);
dsr[1] -> BRN2EtherEncap(SRC deviceaddress, PUSHHEADER false) -> [0]device_wifi;

toMeAfterDsr[0] -> Label_brnether; 
toMeAfterDsr[1] -> Discard;
toMeAfterDsr[2] -> [1]device_wifi;

Idle -> [2]dsr;
Idle -> [3]dsr;
Idle -> [4]dsr;

brn_clf[3] -> Discard;

Script(
  read dsnl.info,
  wait 10,
  read device_wifi/ap/assoclist.stations,
  wait 59,
  read dht/dhtrouting.routing_info,
  read lease_tab.leases
  
  //read lt.links
  //read lt.hosts
);
