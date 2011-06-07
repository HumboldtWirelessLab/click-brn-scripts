#define DEBUGLEVEL 2

//#define NOPCAP

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

//wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

/*wifidevice
  -> t :: Tee()
  -> tdraw :: ToDump("RESULTDIR/NODENAME.NODEDEVICE.raw.dump");
*/

FROMRAWDEVICE(NODEDEVICE)
  -> cnt::Counter()
  //-> t :: Tee()
  -> tdraw :: ToDump("RESULTDIR/NODENAME.NODEDEVICE.raw.dump", SNAPLEN 7500);

  //t[1]
  //-> __WIFIDECAP__  
  //-> Print("RECEIVE",60)
  //-> PrintWifi("Receive-Wifi", TIMESTAMP true)
  //-> Discard;

//Idle
//  -> wifidevice;

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

Script(
/*  write id.version 000102030405060708090a0b0c0d0e0f 0f0e0d0c0b0a09080706050403020100,
  read id.devinfo,
  read id.version,
  read wireless.deviceinfo,*/
  wait 10,
  write cnt.reset,
  wait 10,
  read cnt.bit_rate,
  read cnt.count,
  read cnt.byte_count
);
