#define DEBUGLEVEL 2
//#define RAWDEV_DEBUG 1

//#define USE_PCAP

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

Idle
-> ath_op::Ath2Operation(DEVICE wireless, READCONFIG false, DEBUG 2)
-> Discard;

wifidevice
  //-> PrintWifi("Feedback", TIMESTAMP true)
  -> Discard;

rate::SetTXRates(RATE0 108, TRIES0 1, TRIES1 0, TRIES2 0, TRIES3 0)
//rate::SetTXRates(RATE0 108, RATE1 11, RATE2 4, RATE3 2, TRIES0 2, TRIES1 2, TRIES2 2, TRIES3 2)
  -> SetTXPower(13)
  -> wifioutq::NotifierQueue(50)
//  -> PrintWifi("Sender", TIMESTAMP true)
  -> wifidevice;

BRN2PacketSource(SIZE 100, INTERVAL 10000, MAXSEQ 500000, BURST 1, ACTIVE false)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  //-> PrintWifi("Sender", TIMESTAMP true)
  -> rate;

BRN2PacketSource(SIZE 100, INTERVAL 10000, MAXSEQ 500000, BURST 1, ACTIVE true)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, 00:0f:00:00:00:02)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
 // -> PrintWifi("Sender", TIMESTAMP true)
  -> rate;

BRN2PacketSource(SIZE 100, INTERVAL 1000, MAXSEQ 500000, BURST 1, ACTIVE false)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:03)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> PrintWifi("Sender", TIMESTAMP true)
  -> rate;
