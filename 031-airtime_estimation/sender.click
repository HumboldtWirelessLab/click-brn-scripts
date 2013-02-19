#define DEBUGLEVEL 2
#define CST cst

#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

rawdevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

rawdevice
  -> BRN2PrintWifi("Feedback", TIMESTAMP true)
  -> Discard;

rate::SetTXRates(RATE0 22, RATE1 2, RATE2 0, RATE3 0, TRIES0 3, TRIES1 3, TRIES2 0, TRIES3 0)
-> wifioutq::NotifierQueue(50)
-> rawdevice;

BRN2PacketSource(SIZE 1450, INTERVAL 30, MAXSEQ 500000, BURST 1, ACTIVE true)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> WifiSeq()
  -> Discard;
//  -> rate;

BRN2PacketSource(SIZE 1450, INTERVAL 30, MAXSEQ 500000, BURST 1, ACTIVE true)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:02)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> WifiSeq()
//  -> Discard;
  -> rate;

Script(
 wait 3,
 read rawdevice/cst.stats,
 wait 3,
 read rawdevice/cst.stats
);
  
  