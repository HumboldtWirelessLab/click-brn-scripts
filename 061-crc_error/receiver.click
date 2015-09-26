#define DEBUGLEVEL 2

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

Idle
  -> wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless)
  -> RandomBitErrors(P 0.005, KIND "flip", ACTIVE true)
  -> PrintCRCError(LABEL "PrintCRC", BITS 8)
  -> BRN2CRCErrorRecory(LABEL "Recovery")
  -> BRN2PrintWifi("CRC (NODENAME)", TIMESTAMP true)
  -> discard::Discard;
