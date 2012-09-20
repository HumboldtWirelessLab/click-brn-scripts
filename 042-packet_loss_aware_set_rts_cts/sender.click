#define DEBUGLEVEL 2

#define CST cst
#ifndef SIMULATION
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"
#else
#define CST_PROCFILE "RESULTDIR/../cst"
#endif


#define USE_RTS_CTS rts_cts
#undef RAWDUMP 
// include unter helper/measurement/etc/click





#include "brn/helper.inc"
#include "brn/brn.click"
//#include "device/wifidev_linkstat.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

ps::BRN2PacketSource(SIZE VAR_SIZE, INTERVAL VAR_RATE, MAXSEQ 500000, BURST 2, ACTIVE true)
//ps::BRN2PacketSource(SIZE 1460, INTERVAL 200, MAXSEQ 500000, BURST 2, ACTIVE true)
  //-> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)//Broadcast-Address
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:02)//third value is receiver node
  -> WifiEncap(0x00, 0:0:0:0:0:0)//second value is bssid
  -> SetTXRates(RATE0 2, TRIES0 1, TRIES1 0, TRIES2 0, TRIES3 0)
  -> SetTXPower(13)
  -> BRN2PrintWifi("Sender (NODENAME TX)", TIMESTAMP true)
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

Script(
  write wifidevice/tosq.debug 1, //Debug-Handler wird von BrnElement geerbt
  write wifidevice/setrtscts.debug 1,//Debug-Handler wird von BrnElement geerbt
  write wifidevice/pli.debug 1,//Debug-Handler wird von BrnElement geerbt
  read wifidevice/cst.stats_xml,
  wait 1,
  read wifidevice/cst.stats_xml,
  wait 1,
  read wifidevice/cst.stats_xml,
  read wifidevice/pli.print

);

