#define DEBUGLEVEL 2

#define RAWDEV_DEBUG

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

//  em::EtherMirror()
// Idle()
InfiniteSource(\<0000000000000000>, 5)
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:FF:FF) 
  -> SetTXRate(RATE 4)
  -> SetTXPower( 1 )
  -> BRN2SetChannel(CHANNEL 25)
  -> SetTimestamp()
  -> Print("TxPreQueue", TIMESTAMP true)
  -> wifioutq::NotifierQueue(1000)
  -> SetTimestamp()
  -> Print("TxPostQueue", TIMESTAMP true)
  -> wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless)
  -> Print("RX", TIMESTAMP true)
  -> Discard;
//  -> em;
