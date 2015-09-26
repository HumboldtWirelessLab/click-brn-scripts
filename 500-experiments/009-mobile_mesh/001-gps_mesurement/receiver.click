#define DEBUGLEVEL 2

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

Idle
  -> wifidevice::RAWDEV(DEVNAME NODEDEVICE, DEVICE wireless)
  -> maxl :: CheckLength(92)[1]
  -> copter::Classifier(86/54e6fc90e086, -)
//  -> Print("Raw",100)
  -> ToDump("RESULTDIR/gps_tracker_NODENAME.NODEDEVICE.dump");

maxl[0]
-> Discard;

copter[1]
-> Discard;