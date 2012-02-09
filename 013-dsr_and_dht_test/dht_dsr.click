#define DEBUGLEVEL 2

//#define WIFIDEV_LINKSTAT_DEBUG
//#define ENABLE_DSR_DEBUG

//#define SETCHANNEL

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "dht/dht.click"
#include "routing/routing.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE true, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITY id, ROUTECACHE rc, STALE 500, MIN_LINK_METRIC_IN_ROUTE 9998);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

routing::ROUTING(ID id, ETTHERADDRESS deviceaddress, LT lt, METRIC device_wifi/etx_metric, LINKSTAT device_wifi/link_stat);

dht::DHT(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 30000, UPDATEINT 3000, DEBUG 2);

//dhtstoragetest :: DHTStorageTest( DHTSTORAGE dht/dhtstorage/dhtstorage, STARTTIME 175000, INTERVAL 1000, COUNTKEYS 10, WRITE false, RETRIES 1, REPLICA 0, DEBUG 2);

#ifndef SIMULATION
sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);
#endif

device_wifi
-> Label_brnether::Null()
-> BRN2EtherDecap()
-> brn_clf::Classifier(    0/BRN_PORT_ROUTING,  //BrnDSR
                           0/BRN_PORT_DHTROUTING,  //DHT-Routing
                           0/BRN_PORT_DHTSTORAGE ); //DHT-Storage
                                    
device_wifi[1] -> Label_brnether;
device_wifi[2] -> Discard;

routing[0] -> [0]device_wifi;
routing[1] -> [1]device_wifi;
routing[2] -> Label_brnether;
routing[3] -> Discard;

brn_clf[0] -> [1]routing;
Idle -> [2]routing;
Idle -> [3]routing;

brn_clf[1] -> [0]dht;
brn_clf[2] -> [1]dht;

dht[0] -> [0]device_wifi;
dht[1] -> [0]routing;

Script(
wait 119,
wait 119,
read dht/dht/dhtrouting.routing_info
);

Script(
wait 10,
read device_wifi/wifidevice/cst.stats,
loop
);
