#define DEBUGLEVEL 2

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "routing/broadcast.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITY id, ROUTECACHE rc, STALE 500, MIN_LINK_METRIC_IN_ROUTE 9998);

device_wifi::WIFIDEV(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

rxc::BrnRXCorrelation(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, DEBUG 1);
rxcstats::BrnRXCorrelationStats(RXCORRELATION rxc, NOTELP 32);

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
  wait 10,
  read lt.links,
  wait 10,
  read rxc.info,
  wait 25,
  read rxc.info,
  wait 25,
  read rxc.info,
  read rxcstats.singleper,
  read rxcstats.pairper,

);
