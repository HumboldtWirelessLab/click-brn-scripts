#define DEBUGLEVEL 2

#define LINKPROBE_PERIOD   1000
#define LINKPROBE_TAU      50000
#define LINKPROBE_PROBES   "2 200 24"

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME "NODENAME", DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);

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
  wait 100,
  read lt.links,
  read device_wifi/link_stat.bcast_stats,
);
