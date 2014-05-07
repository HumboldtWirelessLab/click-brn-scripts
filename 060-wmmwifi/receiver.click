#define DEBUGLEVEL 2

#define CST cst

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

Idle
  -> wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless)
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
  -> BRN2PrintWifi("OKPacket (NODENAME)", TIMESTAMP true)
  -> discard::Discard;

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

Script(
 wait 5
);
