#define DEBUGLEVEL 2

#define RAWDUMP
#define NEWLINKSTAT

#define CST cst

#if WIFITYPE == 802
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:11.0/stats/channel_utility"
#endif

#define LINKPROBE_PERIOD               1000
#define LINKPROBE_TAU                100000
//#define LINKPROBE_PROBES     "12 LINKPROBESIZE 18 LINKPROBESIZE 24 LINKPROBESIZE 36 LINKPROBESIZE 48 LINKPROBESIZE 72 LINKPROBESIZE 96 LINKPROBESIZE 108 LINKPROBESIZE HT20 0 LINKPROBESIZE HT20 1 LINKPROBESIZE HT20 2 LINKPROBESIZE HT20 3 LINKPROBESIZE HT20 4 LINKPROBESIZE HT20 5 LINKPROBESIZE HT20 6 LINKPROBESIZE HT20 7 LINKPROBESIZE HT20 8 LINKPROBESIZE HT20 9 LINKPROBESIZE HT20 10 LINKPROBESIZE HT20 11 LINKPROBESIZE HT20 12 LINKPROBESIZE HT20 13 LINKPROBESIZE HT20 14 LINKPROBESIZE HT20 15 LINKPROBESIZE HT40 0 LINKPROBESIZE HT40 1 LINKPROBESIZE HT40 2 LINKPROBESIZE HT40 3 LINKPROBESIZE HT40 4 LINKPROBESIZE HT40 5 LINKPROBESIZE HT40 6 LINKPROBESIZE HT40 7 LINKPROBESIZE HT40 8 LINKPROBESIZE HT40 9 LINKPROBESIZE HT40 10 LINKPROBESIZE HT40 11 LINKPROBESIZE HT40 12 LINKPROBESIZE HT40 13 LINKPROBESIZE HT40 14 LINKPROBESIZE HT40 15 LINKPROBESIZE"
//#define LINKPROBE_PROBES     "12 100 18 100 24 100 36 100 48 100 72 100 96 100 108 100 HT20 0 100 HT20 3 100 HT20 7 100 HT20 8 100 HT20 11 100 HT20 15 100 HT40 0 100 HT40 3 100 HT40 7 100 HT40 8 100 HT40 11 100 HT40 15 100"
#define LINKPROBE_PROBES     "2 100 22 100 12 100 HT20 0 100 HT20 3 100 HT20 7 100 HT20 8 100 HT20 11 100 HT20 15 100"
//"2 300 12 300 HT20 0 300"

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
  wait 120,
  read lt.links,
  read device_wifi/link_stat.bcast_stats,
  read device_wifi/wifidevice/cst.stats_xml
);

