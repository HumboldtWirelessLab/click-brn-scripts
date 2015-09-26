#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/rawwifidev.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

rawdevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

rawdevice
 // -> Print("RECEIVE",60)
  -> PrintWifi("Receive-Wifi")
  -> Discard;

Idle
  -> rawdevice;
