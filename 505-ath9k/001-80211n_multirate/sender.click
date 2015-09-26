#define DEBUGLEVEL 2
//#define RAWDEV_DEBUG 1

//#define USE_PCAP

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

wifidevice
  //-> PrintWifi("Feedback", TIMESTAMP true)
  -> Discard;


BRN2PacketSource(SIZE 100, INTERVAL 1000, MAXSEQ 500000, BURST 1, ACTIVE true)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  //-> PrintWifi("Sender", TIMESTAMP true)
 
  //-> rate::SetTXRates(RATE0 108, TRIES0 1, MCS false)
  -> rate::SetTXRates(RATE0 8, TRIES0 1, TRIES1 0, TRIES2 0, TRIES3 0, MCS true) //MCS
  
  
  -> SetTXPower(13)
  -> wifioutq::NotifierQueue(50)
  //-> PrintWifi("Sender", TIMESTAMP true)
  -> wifidevice;
