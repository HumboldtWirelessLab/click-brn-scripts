#define DEBUGLEVEL 2

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME "NODENAME", DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);
rxc::BrnRXCorrelation(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat);
rxcstats::BrnRXCorrelationStats(RXCORRELATION rxc, NOTELP 10);

Idle
-> device_wifi
-> Discard();

Idle -> [1] device_wifi;
                                    
device_wifi[1] -> /*4/ Print("BRN-In") ->/4*/Discard;
device_wifi[2] -> /*4/Print("BRN-In")->/4*/ Discard;

Script(
  wait 25,
  read rxc.info,
  read rxcstats.singleper,
  read rxcstats.pairper,
  wait 25,
  read rxc.info,
  read rxcstats.singleper,
  read rxcstats.pairper,
  wait 25,
  read rxc.info,
  read rxcstats.singleper,
  read rxcstats.pairper
);
