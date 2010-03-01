#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/simdev.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

rawdevice::RAWDEV(DEVNAME eth0);

rawdevice
  -> Discard;

BRN2PacketSource(100, 1000, 30000, 14, 2, 16)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> PrintWifi("Sender", TIMESTAMP true)
  -> SetTXRate(2)
  -> rawdevice;
