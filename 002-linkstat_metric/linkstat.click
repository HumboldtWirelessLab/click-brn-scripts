#define DEBUGLEVEL 2

#define CST cst
#ifndef SIMULATION
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"
#else
#define CST_PROCFILE "RESULTDIR/../cst"
#endif

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME "NODENAME", DEVICES wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 15000);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

#ifndef SIMULATION
sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);
#endif

device_wifi
-> Discard;

device_wifi[1]
-> Discard;

device_wifi[2] 
-> Discard;


Idle
-> [0]device_wifi;

Idle
->[1]device_wifi;

Script(
  wait 11,
  read lt.links,
  read device_wifi/link_stat.bcast_stats,
  read device_wifi/wifidevice/cst.stats_xml	
);
