#define DEBUGLEVEL 2

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
//  -> BRN2PrintWifi("Sender (NODENAME)", TIMESTAMP true)
  -> wifidevice
  -> filter_tx :: FilterTX()
  -> discard::Discard;

ps[1] -> Discard;

filter_tx[1]
  -> discard;
