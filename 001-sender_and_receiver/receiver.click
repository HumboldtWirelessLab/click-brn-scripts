#define DEBUGLEVEL 2

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
  -> t :: Tee()
  -> tdraw :: ToDump("RESULTDIR/NODENAME.NODEDEVICE.raw.dump");

  t[1]
  //-> __WIFIDECAP__  
  //-> Print("RECEIVE",60)
  //-> PrintWifi("Receive-Wifi", TIMESTAMP true)
  -> Discard;

//Idle
//  -> wifidevice;

Script(
  read id.devinfo,
  read wireless.deviceinfo
);
