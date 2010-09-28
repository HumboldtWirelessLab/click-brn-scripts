#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/simdev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

rawdevice::RAWDEV(DEVNAME NODEDEVICE, DEVICE wireless);

rawdevice
 // -> Print("RECEIVE",60)
  -> PrintWifi("Receive-Wifi")
  -> Discard;

Idle
  -> rawdevice;
