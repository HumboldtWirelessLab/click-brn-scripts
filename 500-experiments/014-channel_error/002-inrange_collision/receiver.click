#define DEBUGLEVEL 2

#define RAWDUMP
#define CERR
#define CST
#define CST_PROCFILE foo
#define USE_RTS_CTS
#define PLE

// include unter helper/measurement/etc/click

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"
#include "device/wifidev_linkstat.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
// wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);
lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);
device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

Idle
  -> SetTimestamp()
  -> [0]device_wifi
  -> wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless)
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
//  -> Print("NODENAME RX")
  -> discard::Discard;

Idle -> [1]device_wifi;

device_wifi[1] -> /* Print("BRN-In") -> */ BRN2EtherDecap() -> discard;
device_wifi[2] -> discard;

error_clf[1]
  -> discard;

error_clf[2]
  -> discard;

error_clf[3]
  -> discard;

error_clf[4]
  -> discard;

error_clf[5]
  -> discard;

error_clf[6]
  -> discard;

error_clf[7]
  -> discard;

filter_tx[1]
  -> discard;
  
Script(
 wait 1,
 //read wifidevice/ced.stats
 //read wifidevice/ple.stats,
 read wifidevice/ced.stats,
 read device_wifi/wifidevice/ple.stats,
 read device_wifi/cocst.stats,
 loop
);
