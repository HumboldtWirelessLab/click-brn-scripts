#define DEBUGLEVEL 2

//#define NOPCAP

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

FROMRAWDEVICE(NODEDEVICE)
  -> cnt::Counter()
  //-> tdraw :: ToDump("RESULTDIR/NODENAME.NODEDEVICE.raw.dump", SNAPLEN 7500);
  -> Discard;

Script(
  wait 10,
  write cnt.reset,
  wait 10,
  read cnt.bit_rate,
);
