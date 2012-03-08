#define DEBUGLEVEL 2

//#define RAWDUMP

//#define WIFIDEV_LINKSTAT_DEBUG
//#define ENABLE_DSR_DEBUG

#define SETCHANNEL

#if WIFITYPE == 802
#define NOPCAP
#endif

#define CST cst

#if WIFITYPE == 802
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:11.0/stats/channel_utility"
#else
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"
#endif

/* Standard */
#define LINKPROBE_PERIOD               1000
#define LINKPROBE_TAU                100000
#define LINKPROBE_PROBES     "2 300 12 300"

/* Test RSSI */
//#define LINKPROBE_PERIOD               100
//#define LINKPROBE_TAU                 5000
//#define LINKPROBE_PROBES     "2 100 12 100"
//#define LINKPROBE_PROBES     "2 100 4 100 11 100 12 100 22 100 18 100 24 100 36 100 48 100 72 100 96 100 108 100"
//#define LINKPROBE_PROBES     "2 500 4 500 11 500 12 500 22 500 18 500 24 500 36 500 48 500 72 500 96 500 108 500"

/* Test PER */
//#define LINKPROBE_PERIOD                100
//#define LINKPROBE_TAU                100000
//#define LINKPROBE_PROBES       "2 100 12 100 72 100"

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "routing/dsr.click"
#include "dht/routing/dht_dart.click"
#include "dht/routing/dht_falcon.click"
#include "dht/routing/dht_klibs.click"
#include "dht/routing/dht_omni.click"
#include "dht/storage/dht_storage.click"

/* MAIN CLICK CONFIG */

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);
routingtable::BrnRoutingTable(DEBUG 2, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE 500, TTL 10);
routingalgo::Dijkstra(NODEIDENTITY id, LINKTABLE lt, ROUTETABLE routingtable, MIN_LINK_METRIC_IN_ROUTE 6000, MAXGRAPHAGE 30000, DEBUG 2);
routingmaint::RoutingMaintenance(NODEIDENTITY id, LINKTABLE lt, ROUTETABLE routingtable, ROUTINGALGORITHM routingalgo, DEBUG 2);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

//lpr::LPRLinkProbeHandler(LINKSTAT device_wifi/link_stat, ETXMETRIC device_wifi/etx_metric);

routing::DSR(id, lt, device_wifi/etx_metric, routingmaint);

//dht::DHT_FALCON(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 120000, UPDATEINT 60000, DEBUG 2);
//dht::DHT_OMNI(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 10000, UPDATEINT 1000, DEBUG 2);
//dht::DHT_KLIBS(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 10000, UPDATEINT 1000, DEBUG 2);
//dht::DHT_DART(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 10000, UPDATEINT 1000, DEBUG 2);

//dhtstorage :: DHT_STORAGE( DHTROUTING dht/dhtrouting, DEBUG 2);
//dhtstoragetest :: DHTStorageTest( DHTSTORAGE dhtstorage/dhtstorage, STARTTIME 0, INTERVAL 1000, COUNTKEYS 0, WRITE false, RETRIES 3, REPLICA 0, DEBUG 4);

#ifndef SIMULATION
sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);
#endif
//sys_info.systeminfo

com::BrnCompoundHandler(HANDLER "wireless.deviceinfo", UPDATEMODE 0, RECORDMODE 0, RECORDSAMPLES 25, SAMPLETIME 200, DEBUG 2);

gps::GPS();

#ifndef SIMULATION
FromSocket("UDP", 127.0.0.1, 8086)
#else
Idle()
#endif
-> seismo::Seismo(GPS gps, CALCSTATS true, PRINT false);

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
//-> Print("Foo",100)
  -> brn_clf::Classifier(    0/BRN_PORT_DSR,  //BrnDSR
                             0/BRN_PORT_FLOW, //Simpleflow
                             0/BRN_PORT_DHTROUTING,  //DHT-Routing
                             0/BRN_PORT_DHTSTORAGE,  //DHT-Storage
                               -  );//other

brn_clf[0]
//-> Print("DSR-Packet")
  ->  [1]routing;

device_wifi[1] -> /*Print("BRN-In") -> */ BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;

Idle -> [2]routing;

brn_clf[1]
//-> Print("rx")
-> BRN2Decap()
-> sf::BRN2SimpleFlow(HEADROOM 192, DEBUG 4)
-> BRN2EtherEncap(USEANNO true)
-> [0]routing;

brn_clf[2]
-> BRN2Decap()
-> Discard;
Idle
//-> [0]dht[0]
-> [0]routing;

brn_clf[3]
-> BRN2Decap()
-> Discard;
Idle
//-> dhtstorage
-> [0]routing;

Idle
-> [3]routing;

brn_clf[4] -> Discard;

//dht[1] -> [0]device_wifi;

routing[0] -> toMeAfterRouting::BRN2ToThisNode(NODEIDENTITY id);
routing[1] -> SetEtherAddr(SRC deviceaddress) -> [0]device_wifi;

toMeAfterRouting[0] -> /*Print("Routing-out: For ME",100) ->*/ Label_brnether; 
toMeAfterRouting[1] -> /*Print("Routing-out: Broadcast") ->*/ Discard;
toMeAfterRouting[2] -> /*Print("Routing-out: Foreign/Client") ->*/ [1]device_wifi;
