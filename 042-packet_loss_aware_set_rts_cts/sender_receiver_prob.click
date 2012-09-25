#define DEBUGLEVEL 2

#define CST cst
#ifndef SIMULATION
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"
#else
#define CST_PROCFILE "RESULTDIR/../cst"
#endif


#define USE_RTS_CTS
#define RAWDUMP
// include unter helper/measurement/etc/click





#include "brn/helper.inc"
#include "brn/brn.click"
//#include "device/wifidev_linkstat.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

ps::BRN2PacketSource(SIZE 18, INTERVAL 500, MAXSEQ 500000, BURST 1, ACTIVE true)
  //-> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:01)
  -> wenc::WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRates(RATE0 2, TRIES0 1, TRIES1 0, TRIES2 0, TRIES3 0)
  -> SetTXPower(13)
  -> BRN2PrintWifi("Sender (NODENAME TX)", TIMESTAMP true)
  -> wifioutq::NotifierQueue(1000)
  -> wifidevice
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
  -> discard::Discard;

ps2::BRN2PacketSource(SIZE 18, INTERVAL 500, MAXSEQ 500000, BURST 1, ACTIVE true)
  //-> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:03)
-> wenc;

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
  read wifidevice/cst.stats_xml,
  wait 1,
  read wifidevice/cst.stats_xml,
  wait 1,
  read wifidevice/cst.stats_xml
);
