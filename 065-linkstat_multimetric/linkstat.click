#define DEBUGLEVEL 2

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"
#define COOPCST

#define COOPCST_STRING device_wifi/cocst

#define CERR

#define LINKPROBE_PERIOD   1000
#define LINKPROBE_TAU      50000
#define LINKPROBE_PROBES   "2 200 24 4 200 24 11 200 24 22 200 24 48 200 24 72 200 24 108 200 24"

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME "NODENAME", DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);

ett_lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);
ett_metric :: BRNETTMetric(ett_lt);

pdr_lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);
pdr_metric :: BRNPDRMetric(pdr_lt);


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
  write device_wifi/link_stat.add_metric pdr_metric,
  write device_wifi/link_stat.add_metric ett_metric,
  read device_wifi/link_stat.probes,
  wait 50,
  read lt.links,
  read ett_lt.links,
  read pdr_lt.links
);
