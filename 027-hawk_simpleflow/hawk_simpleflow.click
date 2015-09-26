 #define USEHAWK                  //Linkprobes enthalten nur Finger
 #define FIRSTDST true            // Vor Weiterleiten zum Finger nach einer dirketen Route pruefen
 //#define BETTERFINGER true       //besseren Finger suchen(benoetigt SUCCFORWARD)
 #define SUCC_HINT		//wenn neuer predecessor, dem alten mitteilen
 //#define SUCCFORWARD_WITH_HINT   //SUCC_HINT + SUCCFORWARD
 //#define SUCCFORWARD         //bis zum neuen Successor weiterleiten
 #define USEMETRIC
 #define PM_ROUNDS 3
 //#define LPS 1
 #define UINTERVALL 2000
 #define LINKPROBE_PERIOD 3000
 #define SUCCPING 2


#define ROUTINGHAWK
#define ROUTING_PERFORMANCE_CNT /* muss ganz nach oben*/

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "dht/routing/dht_falcon.click"
//#include "dht/storage/dht_storage.click"
#include "routing/hawk.click"
#include "dht/dht.click"
#include "routing/routing.click"

AddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 0);

//routingtable::BrnRoutingTable(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
//routingalgo::Dijkstra(NODEIDENTITY id, LINKTABLE lt, MIN_LINK_METRIC_IN_ROUTE 6000, MAXGRAPHAGE 30000, DEBUG 4);
//routingmaint::RoutingMaintenance(NODEIDENTITY id, LINKTABLE lt, ROUTETABLE routingtable, ROUTINGALGORITHM routingalgo, DEBUG 2);

device_wifi::WIFIDEV(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

//dht::DHT_FALCON(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 30000, UPDATEINT 5000, DEBUG 2);
//dhtstorage::DHT_STORAGE( DHTROUTING dht/dhtrouting, DEBUG 2 );
//routing::HAWK(id, dht/dhtroutingtable, dhtstorage/dhtstorage, dht/dhtrouting, lt, dht/dhtlprh, dht, DEBUG 0);
dht::DHT(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 100000, UPDATEINT UINTERVALL, DEBUG 2);
routing::ROUTING(ID id, ETHERADDRESS deviceaddress, LT lt, METRIC device_wifi/etx_metric, LINKSTAT device_wifi/link_stat, DHT dht);

#ifdef ROUTING_PERFORMANCE_CNT
  routing_pkt_cnt::BrnCompoundHandler(HANDLER "routing/routing_in_cnt_mecl.count routing/routing_in_cnt_brn.count routing/routing_in_cnt_passive.count routing/routing_out_cnt_brn.count routing/routing_out_cnt_cl.count routing/routing_out_cnt_me.count routing/routing_out_cnt_bcast.count");
  routing_byte_cnt::BrnCompoundHandler(HANDLER "routing/routing_in_cnt_mecl.byte_count routing/routing_in_cnt_brn.byte_count routing/routing_in_cnt_passive.byte_count routing/routing_out_cnt_brn.byte_count routing/routing_out_cnt_cl.byte_count routing/routing_out_cnt_me.byte_count routing/routing_out_cnt_bcast.byte_count");
#endif


device_wifi
-> Label_brnether::Null()
-> BRN2EtherDecap()
-> brn_clf::Classifier(    0/BRN_PORT_DHTROUTING,  //DHT-Routing
                           0/BRN_PORT_DHTSTORAGE,  //DHT-Storage
                           0/BRN_PORT_HAWK,        //Hawk
                           0/BRN_PORT_FLOW,        //SimpleFlow
                             -  );//other

device_wifi[1] -> Label_brnether;
device_wifi[2] -> Discard;


brn_clf[0] -> [0]dht;
brn_clf[1] -> [1]dht;
brn_clf[2] -> [1]routing;
brn_clf[4] -> Discard;

dht[0] -> Print("pack to routing")-> [0]routing;
dht[1]
-> Print("routing-Packet-out")
//-> dht_r_neighbour::Counter()
-> [0]routing;

brn_clf[3]
-> BRN2Decap()

-> sf::BRN2SimpleFlow(HEADROOM 192, ROUTINGPEEK routing/routing/routing_peek,LINKTABLE lt, DEBUG 4)
-> BRN2EtherEncap(USEANNO true)
-> [0]routing;

//Idle -> [1]device_wifi;
routing[0] -> Print("NODENAME:Try to send") -> Label_brnether;
routing[1] -> Print("NODENAME: r1 out:") -> [0]device_wifi;
routing[2] -> [1]device_wifi;
routing[3] -> Discard;


Idle -> [2]routing;
Idle -> [3]routing;
Idle -> [4]routing;

//device_wifi[3] -> ff::FilterFailures() -> Discard;
//ff[1] -> Print("NODENAME:TXFAILED",100) -> Discard;

Script(

wait 100,
read lt.links,
read routing_pkt_cnt.read,
write lt.fix_linktable true,
wait 100,
read routing_pkt_cnt.read,
read lt.links,
wait 100,
read routing_pkt_cnt.read,
read lt.links,
wait 100,
read routing_pkt_cnt.read,
read lt.links,
wait 100,
read routing_pkt_cnt.read,
read lt.links,
wait 100,
read routing_pkt_cnt.read,
read lt.links,
wait 100,
read routing_pkt_cnt.read,
read lt.links,
wait 100,
read routing_pkt_cnt.read,
read lt.links,
wait 100,
read routing_pkt_cnt.read,
read lt.links,
wait 100,
read routing_pkt_cnt.read,
read lt.links,
wait 1,
read  dht/dhtrouting/dhtrouting.routing_info,
  wait 1, 
  read  routing/routing/rt.tableinfo,
wait 88,
  read  sf.stats
);
