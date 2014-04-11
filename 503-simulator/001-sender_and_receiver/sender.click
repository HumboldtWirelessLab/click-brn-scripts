#define DEBUGLEVEL 2

#define RAWDUMP

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

ps::RatedSource(\<0800>, 10, 1000)
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:01)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> BRN2PrintWifi("Sender (NODENAME)", TIMESTAMP true)
  -> SetTXRates(RATE0 2, TRIES0 1, TRIES1 0, TRIES2 0, TRIES3 0)
  -> SetTXPower(13)
  -> wifioutq::NotifierQueue(1000)
  -> wifidevice
  -> discard::Discard;

Script(
  wait 5,
  read id.version,
  read wireless.deviceinfo
);
