#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/rawdev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

rawdevice::RAWDEV(DEVNAME NODEDEVICE, DEVICE wireless);

rawdevice
  -> t::Tee()
  -> __WIFIDECAP__
  -> ate::AirTimeEstimation(DEBUG true)
  -> Print("RECEIVE",60)
  -> WifiDupeFilter()
  -> PrintWifi("Receive-Wifi", TIMESTAMP true)
  -> Discard;

t[1]
 -> ToDump("NODENAME.NODEDEVICE.dump");

Idle
  -> rawdevice;

Script(
 wait 6,
 read ate.stats
);
