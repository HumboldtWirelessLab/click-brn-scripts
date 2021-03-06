#define DEBUGLEVEL 2

#define CST cst

#define LINKPROBE_PERIOD                                         5000
#define LINKPROBE_TAU                                          250000

#ifdef SIMULATION
#define LINKPROBE_PROBES "2 100 24"
#else
//#define LINKPROBE_PROBES "2 100 24 2 1000 24 12 100 24 12 1000 24 22 100 24 22 1000 24"
#define LINKPROBE_PROBES "2 200 24 11 200 24 12 200 24 24 200 24 48 200 24 72 200 24 108 200 24"
#endif

#define DISABLE_LP_POWER

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME "NODENAME", DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

com::BrnCompoundHandler(HANDLER "device_wifi/link_stat.probes lt.links device_wifi/link_stat.bcast_stats device_wifi/wifidevice/cst.stats", UPDATEMODE 0, RECORDMODE 0, COMPRESSIONLIMIT 200000, DEBUG 2);

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
//  read device_wifi/link_stat.probes,
  wait 300,
  read lt.links,
//  wait 5,
//  read device_wifi/link_stat.bcast_stats,
//  wait 5,
//  read device_wifi/wifidevice/cst.stats
);
