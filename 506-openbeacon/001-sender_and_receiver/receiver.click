#define DEBUGLEVEL 2

#define RAWDEV_DEBUG

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

//  em::EtherMirror()
 Idle()
  -> SetTXRate(RATE 2)
  -> SetTXPower(0)
  -> BRN2SetChannel(CHANNEL 82)
  -> SetTimestamp()
  -> Print("TxPreQueue", TIMESTAMP true)
  -> wifioutq::NotifierQueue(1000)
  -> SetTimestamp()
  -> Print("TxPostQueue", TIMESTAMP true)
  -> wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless)
  -> Print("RX", TIMESTAMP true)
  -> Discard;
//  -> em;
