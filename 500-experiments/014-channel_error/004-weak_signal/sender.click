#define DEBUGLEVEL 2

#define RAWDUMP
#define CST
#define CERR
#define USE_RTS_CTS

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");
//wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);
//lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

//device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

Idle() ->
ps::BRN2PacketSource(SIZE 1460, INTERVAL 100, MAXSEQ 500000, BURST 1, ACTIVE true)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:01)
//-> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:05)
//-> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> BRN2PrintWifi("Sender", TIMESTAMP true)
  -> SetTXRates(RATE0 2, TRIES0 1, TRIES1 0, TRIES2 0, TRIES3 0)
  -> SetTXPower(13)
  -> rdq::RandomDelayQueue(MINDELAY 20, MAXDELAY 200, DIFFDELAY 10, TIMESTAMPANNOS false)
  -> wifioutq::NotifierQueue(1000)
  -> wifidevice
  //-> [0]device_wifi
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
  -> BRN2PrintWifi("OKPacket", TIMESTAMP true)
  -> discard::Discard;

//ps[1] -> Discard;

//Idle -> [1]device_wifi;

//device_wifi[1] -> /* Print("BRN-In") -> */ BRN2EtherDecap() -> discard;
//device_wifi[2] -> discard;

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

//sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

Script(
  read gps.cart_coord,
  wait 1,
  loop
);

Script(
  wait 5,
  write mob.move 199 99 5 20
 );

