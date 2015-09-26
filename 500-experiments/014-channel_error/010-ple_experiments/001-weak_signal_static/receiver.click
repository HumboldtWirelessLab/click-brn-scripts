#define DEBUGLEVEL 2

#define RAWDUMP
#define CERR
#define CST cst
#define CST_PROCFILE foo
#define COLLINFO
#define USE_RTS_CTS
#define PLE
#define PLE_COCST

// include unter helper/measurement/etc/click

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"
#include "device/wifidev_linkstat.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);
lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);
device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

Idle
  -> SetTimestamp()
  -> [0]device_wifi
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
  -> BRN2PrintWifi("OKPacket", TIMESTAMP true)
  -> discard::Discard;

Idle -> [1]device_wifi;
device_wifi[1] -> /* Print("BRN-In") -> */ BRN2EtherDecap() -> discard;
device_wifi[2] -> discard;

gps::GPS();
mob::Mobility();

error_clf[1]
  -> BRN2PrintWifi("CRCerror", TIMESTAMP true)
  -> discard;

error_clf[2]
  -> BRN2PrintWifi("PHYerror", TIMESTAMP true)
  -> discard;

error_clf[3]
  -> BRN2PrintWifi("FIFOerror", TIMESTAMP true)
  -> discard;

error_clf[4]
  -> BRN2PrintWifi("DECRYPTerror", TIMESTAMP true)
  -> discard;

error_clf[5]
  -> BRN2PrintWifi("MICerror", TIMESTAMP true)
  -> discard;

error_clf[6]
  -> BRN2PrintWifi("ZEROerror", TIMESTAMP true)
  -> discard;

error_clf[7]
  -> BRN2PrintWifi("UNKNOWNerror", TIMESTAMP true)
  -> discard;

filter_tx[1]
  -> BRN2PrintWifi("TXFeedback", TIMESTAMP true)
  -> discard;

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

Script(
 wait 1,
 read device_wifi/wifidevice/ple.stats,
 loop
);

