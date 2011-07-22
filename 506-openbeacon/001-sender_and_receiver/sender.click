#define DEBUGLEVEL 2

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

ps::BRN2PacketSource(SIZE 8, INTERVAL 1000, MAXSEQ 500000, BURST 1, PACKETCOUNT 10, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:32:63)
  -> SetTXRate(RATE 2)
  -> SetTXPower(0)
  -> BRN2SetChannel(CHANNEL 82)
  -> SetTimestamp()
//  -> Print("TxPreQueue",TIMESTAMP true)
  -> wifioutq::NotifierQueue(1000)
  -> SetTimestamp()
  -> Print("TxPostQueue",TIMESTAMP true)
  -> wifidevice
  -> Print("RxEcho", TIMESTAMP true)
  -> Discard;
