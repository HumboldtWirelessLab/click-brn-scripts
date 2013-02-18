#define DEBUGLEVEL 2
#define CST cst

#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

rawdevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

rawdevice
  -> BRN2PrintWifi("Receive-Wifi", TIMESTAMP true)
  -> Discard;

Idle
  -> rawdevice;

Script(
 wait 3,
 read rawdevice/cst.stats,
 wait 3,
 read rawdevice/cst.stats
);
