#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/simdev.click"
#include "device/wifidev_ig.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITIY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 15000);

device_wifi::WIFIDEV_IG(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

device_wifi
-> BRN2EtherDecap()
-> Discard;

device_wifi[1] -> BRN2EtherDecap() -> Discard;
device_wifi[2] -> Discard;

Idle
-> [0]device_wifi;

Idle
-> [1]device_wifi;

Script(
   wait 1,
   write device_wifi/qc.flow_insert 1000 2000 1500 1,
   wait 5,
   read device_wifi/qc.flow_stats,
   wait 1,
   write device_wifi/qc.flow_insert 1000 2000 100 1,
   wait 5,
   read device_wifi/qc.flow_stats,
);
