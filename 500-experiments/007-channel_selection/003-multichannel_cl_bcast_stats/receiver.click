#define DEBUGLEVEL 2

//#define RAWDUMP
#define NOPCAP

#define CST cst

#if WIFITYPE == 803

#if DEVICENUMBER == 0
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:11.0/stats/channel_utility"
#else
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:12.0/stats/channel_utility"
#endif

#else

#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#endif


#define LINKPROBE_PERIOD   2000
#define LINKPROBE_TAU      100000
#define LINKPROBE_PROBES   "2 1000 0 4 1000 0 11 1000 0 22 1000 0 48 1000 0 72 1000 0 108 1000 0"

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

Idle
-> device_wifi
-> Discard;

Idle
->[1]device_wifi[1]
-> Discard;

device_wifi[2]
-> Discard;


#ifndef SIMULATION
sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);
Script(
  wait 10,
  read sys_info.systeminfo,
  loop
);
#endif

Script(
  wait 10,
  read device_wifi/wifidevice/cst.stats,
  loop
);

Script(
  read device_wifi/link_stat.probes,
  wait 120,
  read device_wifi/link_stat.bcast_stats,
);
