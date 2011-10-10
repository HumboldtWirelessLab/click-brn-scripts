#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "dht/routing/dht_dart.click"
#include "dht/routing/dht_falcon.click"
#include "dht/routing/dht_klibs.click"
#include "dht/routing/dht_omni.click"
#include "dht/storage/dht_storage.click"
#include "routing/dart.click"
#include "routing/dsr.click"
#include "services/gateway.click"

BRNAddressInfo(deviceaddress eth0:eth);
BRNAddressInfo(serviceaddress 00:00:00:01:23:45);

wireless::BRN2Device(DEVICENAME "eth0_1", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS", MASTERDEVICE true, SERVICEDEVICE false);
service::BRN2Device(DEVICENAME "service", ETHERADDRESS serviceaddress, DEVICETYPE "VIRTUAL", MASTERDEVICE false, SERVICEDEVICE true);

id::BRN2NodeIdentity(NAME "NODENAME", DEVICES "wireless service");

rc::Brn2RouteCache(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 15000);

device_wifi::WIFIDEV(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

dsr::DSR(id,lt,device_wifi/etx_metric);

dht::DHT_FALCON(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 30000, UPDATEINT 3000, DEBUG 2);

dhtstorage :: DHT_STORAGE( DHTROUTING dht/dhtrouting, DEBUG 2 );

brngw::Gateway( ETHER_ADDR deviceaddress, LINKTABLE lt, UPDATE_GATEWAYS_INTERVAL 3, UPDATE_DHT_INTERVAL 3,
         PREFIX 192.168.0.0/24, SERVICE_IP 192.168.0.1, DHTSTORAGE dhtstorage/dhtstorage);

device_wifi
-> Label_brnether::Null()
-> ip_clf::Classifier(12/8086,
                      12/0800,
                      -)
-> BRN2EtherDecap()
-> brn_clf::Classifier(    0/BRN_PORT_DSR,  //BrnDSR
                           0/BRN_PORT_DHTROUTING,  //DHT-Routing
                           0/BRN_PORT_DHTSTORAGE,  //DHT-Storage
                           0/BRN_PORT_GATEWAY,  //Gateway
                             -  );//other
                                    
brn_clf[0] -> [1]dsr;

device_wifi[1] -> BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;

Idle -> [2]dsr;
Idle -> [3]dsr;

brn_clf[1]
//-> Print("Routing-Packet")
-> BRN2Decap()
-> [0]dht[0]
-> dht_r_all::Counter()
//-> Print("out Routing-Packet")
-> [0]dsr;

brn_clf[2]
//-> Print("Storage-Packet")
-> BRN2Decap()
-> dhtstorage
-> dht_s::Counter()
//-> Print("Storage-Packet-out",100)
-> [0]dsr;


brn_clf[4] -> Discard;

dht[1]
//-> Print("routing-Packet-out")
-> dht_r_neighbour::Counter()
-> [0]device_wifi;

dsr[0] -> toMeAfterDsr::BRN2ToThisNode(NODEIDENTITY id);
dsr[1] -> SetEtherAddr(SRC deviceaddress) -> [0]device_wifi;

toMeAfterDsr[0] ->  Label_brnether; 
toMeAfterDsr[1] ->  Discard;
toMeAfterDsr[2] ->  [1]device_wifi;

Idle
-> sf::BRN2SimpleFlow( ACTIVE 0, HEADROOM 192 )
-> UDPIPEncap(SRC 192.168.0.4, SPORT 30000, DST 10.10.0.2, DPORT 80, CHECKSUM true)
-> EtherEncap(0x0800, deviceaddress, serviceaddress)
-> [0]brngw[0]
//-> Print("IP Frames from Gateway (W)")  //e.g. icmp error
-> BRN2EtherDecap()
-> BRN2EtherEncap()
-> aftergw::BRN2ToThisNode(NODEIDENTITY id)
-> BRN2EtherDecap()
-> StripIPHeader()
-> Strip(8)
-> Classifier( 0/BRN_PORT_FLOW )
-> BRN2Decap()
-> sf_dst::BRN2SimpleFlow()
-> Discard;

aftergw[1] -> Discard;

aftergw[2] -> [0]dsr;

brn_clf[3]
//-> Print("Back from remote gateway")
-> [1]brngw[1]
//-> Print("IP Frames to choosen Gateway")
-> [0]dsr;

brngw[2]
//-> Print("To local device")
-> IPMirror()
//-> Print("MIRROR")
-> [3]brngw[3]
//-> Print("BRN Gateway feedback packet to orginator")
-> [0]dsr;

ip_clf[1]
-> BRN2EtherDecap()
-> CheckIPHeader()
//-> Print("for the gateway")
-> [2]brngw;

ip_clf[2]
//-> Print("for the gateway")
-> Discard;
