#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/rawdev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

rawdevice::RAWDEV(DEVNAME NODEDEVICE, DEVICE wireless);

rawdevice
  -> t::Tee()
  -> __WIFIDECAP__
  -> cst::ChannelStats(DEBUG true)
  -> Print("RECEIVE",60)
  -> WifiDupeFilter()
  -> BRN2PrintWifi("Receive-Wifi", TIMESTAMP true)
  -> Discard;

t[1]
 -> ToDump("NODENAME.NODEDEVICE.dump");

Idle
  -> rawdevice;

Script(
 wait 6,
 read cst.stats,
 read cst.busy,
 read cst.stats_short
);
