#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

wifidevice
 // -> Print("RECEIVE",60)
 // -> PrintWifi("Receive-Wifi", TIMESTAMP true)
  -> Discard;

Idle
  -> wifidevice;
