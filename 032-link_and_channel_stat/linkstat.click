#define DEBUGLEVEL 2

#define CST cst

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(wireless);

rc::Brn2RouteCache(ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 15000);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

//sys_info::SystemInfo(NODEIDENTITY id);

device_wifi
-> Discard;

device_wifi[1]
-> Discard;

device_wifi[2] 
-> Discard;


ps::BRN2PacketSource(SIZE 1450, INTERVAL 25, MAXSEQ 500000, BURST 1, ACTIVE false)
  -> EtherEncap(0x8088, deviceaddress, FF:FF:FF:FF:FF:FF )
  -> SetTXRate(2)
  -> power::SetTXPower(15)
  -> [0]device_wifi;

Idle
->[1]device_wifi;

Script(
  write id.nodename NODENAME,
  wait 110,
  read device_wifi/link_stat.bcast_stats
);
