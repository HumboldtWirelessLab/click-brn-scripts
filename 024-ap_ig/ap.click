#define DEBUGLEVEL 2
//#define IG_ENABLE

#include "brn/brn.click"
#include "device/wifidev_ap.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME "NODENAME", DEVICES wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 15000);

device_wifi::WIFIDEV_AP(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", CHANNEL 9, LT lt);

device_wifi
-> BRN2EtherDecap()
-> Discard;

device_wifi[1] -> BRN2EtherDecap() -> Discard;
device_wifi[2] -> Discard;
device_wifi[3] -> Discard;
device_wifi[4] -> Discard;
device_wifi[5] -> Discard;

Idle
-> [0]device_wifi;

Idle
-> [1]device_wifi;

Script(
   wait 1,
//   write device_wifi/qc.flow_insert 1000 2000 1500 1,
   wait 5,
//   read device_wifi/qc.flow_stats,
   wait 1,
//   write device_wifi/qc.flow_insert 1000 2000 100 1,
   wait 5,
//   read device_wifi/qc.flow_stats,
);
