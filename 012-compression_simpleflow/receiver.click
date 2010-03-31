#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/simdev.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

rawdevice::RAWDEV(DEVNAME eth0, DEVICE wireless);
pc::PacketCompression(CMODE 0, DEBUG 4);

rawdevice
// -> Print("RECEIVE",60)
  -> WifiDecap()
  -> BRN2EtherDecap()
//-> BRN2Decap()
  -> [1]pc 
//-> Print("Comp")
  -> Discard;

Idle
  -> rawdevice;
  
Idle
  -> [0]pc;  
  
pc[2]
  -> Print("Compression Error")
  -> Discard;

pc[3]
  -> Print("Decompression Error")
  -> Discard;

Idle
  -> [0]pc;

pc[1]
//-> Print("Decomp")
  -> cnt::Counter()
  -> BRN2EtherDecap()
  -> BRN2Decap()
  -> sf_dst::BRN2SimpleFlow(SRCADDRESS 00:0f:00:00:01:00, DSTADDRESS 00:0f:00:00:00:00, RATE 100 , SIZE 500, MODE 0, DURATION 20000, ACTIVE 0)
  -> Discard;
  
Script(
  wait  10,
  read  sf_dst.txflows,
  read  sf_dst.rxflows,
  read  cnt.count,
  read  cnt.byte_count
);
