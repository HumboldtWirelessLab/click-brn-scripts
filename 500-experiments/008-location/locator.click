#define DEBUGLEVEL 2

#define RAWDUMP

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

wifidevice
  -> Discard;

ps::BRN2PacketSource(SIZE 18 , INTERVAL 10, MAXSEQ 500000, BURST 5, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> rate::SetTXRates(RATE0 12, TRIES0 1, TRIES1 0, TRIES2 0, TRIES3 0)
  -> wifioutq::NotifierQueue(1000)
  -> wifidevice;
