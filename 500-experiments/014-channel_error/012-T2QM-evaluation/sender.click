#define DEBUGLEVEL 2
#include "config.click"

//#define RAWDUMP

#define CST cst

//#define CST_STATS_DURATION 500

#ifndef TOS2QUEUEMAPPER_STRATEGY
#define TOS2QUEUEMAPPER_STRATEGY 0
#endif

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

Idle()
  -> sf::BRN2SimpleFlow(FLOW "deviceaddress 00:00:00:00:00:01 12 1500 0 30000 true 1 1000", FLOWSTARTRANDOM 50, DEBUG 2)
  -> BRN2EtherEncap(USEANNO true)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRate(RATE 2, TRIES 7)
  -> SetTXPower(24)
  //-> SetRTS(RTS true)
  //-> SetPacketAnno(TOS 1)
  -> wifioutq::NotifierQueue(1000)
  -> wifidevice
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
  //-> BRN2PrintWifi("RCSender NODENAME", TIMESTAMP true)
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

//filter_tx[1]
//  -> BRN2PrintWifi("TXFeedback", TIMESTAMP true)
//  -> discard;

filter_tx[1]
  -> BRN2PrintWifi("TXFeedback", TIMESTAMP true)
  -> WifiDecap()
  -> BRN2EtherDecap()
  -> BRN2Decap()
  -> [1]sf;

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

Script(
  wait 31,
  read wifidevice/tosq.stats,
  read wifidevice/tosq.BOs,
  read wifidevice/cst.stats,
  read sf.stats
  //read sys_info.systeminfo,
  //read id.version
);
