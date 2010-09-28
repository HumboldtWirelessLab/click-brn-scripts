#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/rawdev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

rawdevice::RAWDEV(DEVNAME NODEDEVICE, DEVICE wireless);

rawdevice
  -> PrintWifi("Feedback", TIMESTAMP true)
//  -> Print("Feedback")
  -> Discard;

rate::SetTXRates(RATE0 11, RATE1 4, RATE2 2, RATE3 2, TRIES0 1, TRIES1 2, TRIES2 1, TRIES3 1)
-> wifioutq::NotifierQueue(50)
-> rawdevice;

BRN2PacketSource(100, 1000, 30000, 14, 2, 16)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> PrintWifi("Sender", TIMESTAMP true)
  -> rate;

BRN2PacketSource(100, 1000, 30000, 14, 2, 16)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:02)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
//  -> PrintWifi("Sender", TIMESTAMP true)
  -> rate;

BRN2PacketSource(100, 1000, 30000, 14, 2, 16)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:03)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
//  -> PrintWifi("Sender", TIMESTAMP true)
  -> rate;
