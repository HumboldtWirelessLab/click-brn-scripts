#define DEBUGLEVEL 2

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

//#define USE_RTS_CTS

#define RAWDUMP

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS", DEBUG 4);

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

Idle()
  -> sf::BRN2SimpleFlow(FLOW "deviceaddress 00:00:00:00:00:01 25 15 0 4500 true 1 0", DEBUG 2)  //multi receivers: FLOW "deviceaddress 00:00:00:00:00:01,FF:FF:FF:FF:FF:FF 12 1500 0 ...."
  -> BRN2EtherEncap(USEANNO true)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTimestamp()
  -> SetTXRate(RATE 2, TRIES 1)
  -> SetTXPower(24)
  -> SetRTS(false)
  -> wifioutq::NotifierQueue(100)
  -> SetTimestamp()
  -> BRN2PrintWifi("Sender (NODENAME)", TIMESTAMP true)
  -> wifidevice
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
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
//  -> discard;           //Feedback verwerfen oder
  -> WifiDecap            //Feedback auspacken
  -> BRN2EtherDecap()     //..
  -> BRN2Decap()          //und simpleflow geben, sodass die Stats erneuert werden koennen
  -> [1]sf;

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

Script(
//  write wifidevice/tosq.test,
  wait 3,
  write wifidevice/rawdev/pullstats.reset 0,
  wait 1,
  read wifidevice/rawdev/pullstats.idletime,
  wait 1,
  read sys_info.systeminfo,
  read id.version,
  read wireless.deviceinfo,
  read wifidevice/cst.stats,
  read sf.stats
);
