#define DEBUGLEVEL 2

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#define RAWDUMP

#define USE_RTS_CTS

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS", CWMIN CWMINPARAM, CWMAX CWMAXPARAM, AIFS AIFSPARAM);

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

Idle() ->
ps::BRN2PacketSource(SIZE 1460, INTERVAL 12, MAXSEQ 500000, BURST 1, ACTIVE true, DEBUG 4)
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:01)
//-> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:05)
//  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
//  -> SetTimestamp()
//  -> BRN2PrintWifi("Sender (NODENAME)", TIMESTAMP true)
  -> SetTXRates(RATE0 2, TRIES0 1, TRIES1 0, TRIES2 0, TRIES3 0)
  -> SetTXPower(13)
  -> wifioutq::NotifierQueue(10)
  -> SetTimestamp()
  -> BRN2PrintWifi("Sender (NODENAME)", TIMESTAMP true)
  -> wifidevice
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
  -> BRN2PrintWifi("OKPacket", TIMESTAMP true)
  -> discard::Discard;

ps[1] -> Discard;



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

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

Script(
// wait 1,
//   read wifioutq.notifier_state,
  wait 5,
  read sys_info.systeminfo,
  read id.version,
  read wireless.deviceinfo,
  read wifidevice/cst.stats
);
