#define DEBUGLEVEL 2

//#define RAWDUMP
#define BRNFEEDBACK
//#define USEHAWK                  //Linkprobes enthalten nur Finger 
//#define FIRSTDST true            // Vor Weiterleiten zum Finger nach einer dirketen Route pruefen
//#define BETTERFINGER true       //besseren Finger suchen(benoetigt SUCCFORWARD)
//#define SUCC_HINT		//wenn neuer predecessor, dem alten mitteilen
//#define SUCCFORWARD_WITH_HINT   //SUCC_HINT + SUCCFORWARD
//#define SUCCFORWARD         //bis zum neuen Successor weiterleiten

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "dht/routing/dht_falcon.click"
#include "dht/storage/dht_storage.click"
#include "routing/hawk.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 0);
//routingtable::BrnRoutingTable(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
//routingalgo::Dijkstra(NODEIDENTITY id, LINKTABLE lt, MIN_LINK_METRIC_IN_ROUTE 6000, MAXGRAPHAGE 30000, DEBUG 4);
//routingmaint::RoutingMaintenance(NODEIDENTITY id, LINKTABLE lt, ROUTETABLE routingtable, ROUTINGALGORITHM routingalgo, DEBUG 2);

device_wifi::WIFIDEV(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

dht::DHT_FALCON(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 30000, UPDATEINT 5000, DEBUG 2);
dhtstorage::DHT_STORAGE( DHTROUTING dht/dhtrouting, DEBUG 2 );
routing::HAWK(id, dht/dhtroutingtable, dhtstorage/dhtstorage, dht/dhtrouting, lt, dht/dhtlprh, dht, DEBUG 0);

device_wifi
-> Label_brnether::Null()
-> BRN2EtherDecap()
-> brn_clf::Classifier(    0/BRN_PORT_DHTROUTING,  //DHT-Routing
                           0/BRN_PORT_DHTSTORAGE,  //DHT-Storage
                           0/BRN_PORT_HAWK,        //Hawk
                           0/BRN_PORT_FLOW,        //SimpleFlow
                             -  );//other

device_wifi[1] -> /*Print("BRN-In") -> */ BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;

brn_clf[0]
//-> Print("Routing-Packet",100)
-> BRN2Decap()
-> [0]dht[0]
-> dht_r_all::Counter()
//-> Print("out Routing-Packet")
-> [0]routing;

brn_clf[1]
//-> Print("Storage-Packet")
-> BRN2Decap()
-> dhtstorage
-> dht_s::Counter()
//-> Print("Storage-Packet-out")
-> [0]routing;

brn_clf[2] -> [1]routing;

brn_clf[4] -> Discard;

dht[1]
//-> Print("routing-Packet-out")
-> dht_r_neighbour::Counter()
-> [0]device_wifi;

brn_clf[3]
-> BRN2Decap()
-> sf::BRN2SimpleFlow(ROUTINGPEEK routing/routing_peek,LT lt, DEBUG 0)
-> BRN2EtherEncap()
-> [0]routing;

routing[0] -> Print("NODENAME:Try to send") -> [0]device_wifi;
routing[1] -> Label_brnether;

Idle 
->[1]device_wifi;

Idle -> [2]routing;
Idle -> [3]routing;
Idle -> [4]routing;

device_wifi[3] -> ff::FilterFailures() -> Discard;
ff[1] -> Print("NODENAME:TXFAILED",100) -> Discard;

Script(
wait 50,
read lt.links,
wait 50,
read lt.links,
wait 460,
//read dht/dhtrouting.routing.info,  
//wait 260,
wait 48,
  read lt.links,
  wait 2,
  read dht/dhtrouting.routing_info,
// wait 9, 
//  read dht/dhtrouting.routing_info,
//  wait 18,
  //read dht/dhtrouting.routing_info,
wait 1,
  read  sf.stats,
  wait 1, 
  read  routing/rt.tableinfo

);
