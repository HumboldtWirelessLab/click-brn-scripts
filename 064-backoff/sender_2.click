#define DEBUGLEVEL 2

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

//#define USE_RTS_CTS

#define RAWDUMP

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS", DEBUG 4);

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

Idle()
  -> sf::BRN2SimpleFlow(FLOW "deviceaddress 00:00:00:00:00:02 12 1500 0 2000 true 1 0", DEBUG 2)
  -> BRN2EtherEncap(USEANNO true)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRate(RATE 2, TRIES 7)
  -> SetTXPower(24)
  -> SetRTS(false)
  -> wifioutq::NotifierQueue(200)
  -> AgeFilter(MAXAGE 0)
  -> SetTimestamp()
  -> BRN2PrintWifi("Sender2 (NODENAME)", TIMESTAMP true)
  -> wifidevice
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
//  -> BRN2PrintWifi("OKPacket", TIMESTAMP true)
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
//  -> BRN2PrintWifi("TXFeedback", TIMESTAMP true)
  -> WifiDecap            //Feedback auspacken
  -> BRN2EtherDecap()     //..
  -> BRN2Decap()          //und simpleflow geben, sodass die Stats erneuert werden koennen
  -> [1]sf;

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

Script(
  wait 0,
//  read wireless.deviceinfo,
  write wireless.backoff 8 512 0 16 1024 0 32 2048 0 64 2048 0,
  read wireless.deviceinfo,
  wait 2,
  write wifioutq.reset

);
