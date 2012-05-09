#define DEBUGLEVEL 2

#define CST cst

#if DEVICENUMBER == 0
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:11.0/stats/channel_utility"
#else
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:12.0/stats/channel_utility"
#endif

#define NOATHOPERATION
//#define RAWDUMP

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

Idle
  -> wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless)
  -> Discard;
/*
Idle
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
#ifdef EXTRAOUT
  -> Print("FOOOOOOO")
#endif
  -> BRN2PrintWifi("OKPacket", TIMESTAMP true)
  -> discard::Discard;

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
*/