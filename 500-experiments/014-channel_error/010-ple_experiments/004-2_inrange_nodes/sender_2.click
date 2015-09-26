#define DEBUGLEVEL 2

#define RAWDUMP
#define CST cst
#define CST_PROCFILE foo
#define CERR
#define USE_RTS_CTS
#define COLLINFO
//#define PLE


// include unter helper/measurement/etc/click

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"
#include "device/wifidev_linkstat.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

ps::BRN2PacketSource(SIZE 146, INTERVAL 10, MAXSEQ 500000, BURST 10, ACTIVE true)
//  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:01)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
//  -> BRN2PrintWifi("Sender", TIMESTAMP true)
  -> SetTXRates(RATE0 2, TRIES0 1, TRIES1 0, TRIES2 0, TRIES3 0)
  -> SetTXPower(13)
  -> SetPacketAnno(TOS 3)
  -> rdq::RandomDelayQueue(MINDELAY 20, MAXDELAY 200, DIFFDELAY 10, TIMESTAMPANNOS false)
  -> wifioutq::NotifierQueue(1000)
  -> wifidevice
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
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
  
  
