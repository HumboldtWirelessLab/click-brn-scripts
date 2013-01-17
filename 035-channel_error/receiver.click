#define DEBUGLEVEL 2

#define RAWDUMP
#define CERR
#define CST cst

// include unter helper/measurement/etc/click

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
  -> Print("NODENAME RX")
  -> discard::Discard;

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
 read wifidevice/ced.stats
);