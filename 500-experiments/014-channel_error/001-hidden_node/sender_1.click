#define DEBUGLEVEL 2

#define RAWDUMP
#define CST
#define CST_PROCFILE foo
#define CERR
#define USE_RTS_CTS
#define PLE

// include unter helper/measurement/etc/click

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"
#include "device/wifidev_linkstat.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS", CWMIN CWMINPARAM, CWMAX CWMAXPARAM, AIFS AIFSPARAM);

//wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);
lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

ps::BRN2PacketSource(SIZE 1460, INTERVAL 20, MAXSEQ 500000, BURST 1, ACTIVE true)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:03)
//  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> BRN2PrintWifi("Sender", TIMESTAMP true)
//  -> SetTXRates(RATE0 2, TRIES0 1, TRIES1 0, TRIES2 0, TRIES3 0)
  -> SetTXPower(13)
  -> rdq::RandomDelayQueue(MINDELAY 30, MAXDELAY 200, DIFFDELAY 10, TIMESTAMPANNOS false)
//  -> wifidevice
  -> [0]device_wifi
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
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

