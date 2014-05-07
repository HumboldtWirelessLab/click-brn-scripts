#define DEBUGLEVEL 2

//#define WIFIDEV_LINKSTAT_DEBUG
#define ENABLE_DSR_DEBUG

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

gps::GPS();
seismo::Seismo(GPS gps, PRINT false, RECORD true, SHORTTAGS true, DATAFILEPREFIX "CONFIGDIR/data/result_9.txt.", DATAFILEINTERVAL 100, DEBUG 2);

longshortavg::SeismoDetectionLongShortAvg(LONGAVG 4000, SHORTAVG 100, RATIOTHRESHOLD 400, NORMALIZE 100, MAXALARM 15, ALARMTIMEDIST 550, DEBUG 2);
cooperative::SeismoDetectionCooperative(ALGORITHMS longshortavg, MERGERANGE 1000, DEBUG 3);
seismoreport::SeismoReporting(SEISMO seismo, ALGORITHMS "longshortavg cooperative", INTERVAL 100, DEBUG 3);


Idle -> [1]seismo;
Idle -> [0]seismo;

device_wifi
  -> Label_brnether::Null()
//  -> Print("RX",TIMESTAMP true)
  -> BRN2EtherDecap()
  -> brn_clf::Classifier( 0/BRN_PORT_SEISMO_COOPERATIVE, //Seismo
                                                   -  ); //other

brn_clf[0]
-> BRN2Decap()
//-> Discard; Idle()
-> cooperative
-> SetTimestamp()
//-> Print(TIMESTAMP true)
-> EtherEncap(SRC deviceaddress, DST FF-FF-FF-FF-FF-FF, ETHERTYPE 0x8086)
//-> Print(TIMESTAMP true)
-> [0]device_wifi;

brn_clf[1] -> Discard;

device_wifi[1] -> Label_brnether;
device_wifi[2] -> Discard;

Idle -> [1]device_wifi;

Script(
  wait 240,
  //  wait 4,
  read longshortavg.stats,
  read cooperative.stats
);

