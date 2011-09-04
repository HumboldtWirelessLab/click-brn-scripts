#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/rawdev.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

rawdevice::RAWDEV(DEVNAME eth0, DEVICE wireless);

rawdevice
 // -> Print("RECEIVE",60)
//  -> PrintWifi("Receive-Wifi", TIMESTAMP true)
  -> Discard;

Idle
  -> rawdevice;
