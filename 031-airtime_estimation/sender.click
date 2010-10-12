#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/rawdev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

rawdevice::RAWDEV(DEVNAME NODEDEVICE, DEVICE wireless);

rawdevice
//  -> PrintWifi("Feedback", TIMESTAMP true)
  -> __WIFIDECAP__
  -> Print("Feedback",60)
  -> ate::AirTimeEstimation(DEBUG true)
  -> Discard;

//rate::SetTXRates(RATE0 11, RATE1 4, RATE2 2, RATE3 2, TRIES0 1, TRIES1 2, TRIES2 1, TRIES3 1)
rate::SetTXRates(RATE0 22, RATE1 2, RATE2 0, RATE3 0, TRIES0 3, TRIES1 3, TRIES2 0, TRIES3 0)
-> __WIFIENCAP__
-> wifioutq::NotifierQueue(50)
-> rawdevice;

BRN2PacketSource(SIZE 1450, INTERVAL 30, MAXSEQ 500000, BURST 1)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> WifiSeq()
//  -> PrintWifi("Sender", TIMESTAMP true)
  -> Discard;
//  -> rate;

BRN2PacketSource(SIZE 1450, INTERVAL 30, MAXSEQ 500000, BURST 1)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:02)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> WifiSeq()
//  -> PrintWifi("Sender", TIMESTAMP true)
//  -> Discard;
  -> rate;

BRN2PacketSource(100, 1000, 30000, 14, 2, 16)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:03)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> WifiSeq()
//  -> PrintWifi("Sender", TIMESTAMP true)
  -> Discard;
//  -> rate;

Script(
 wait 6,
 read ate.stats
);
  
  