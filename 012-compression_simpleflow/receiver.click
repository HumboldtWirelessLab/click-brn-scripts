#define DEBUGLEVEL 2

//#define COMP_DEBUG

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

rawdevice::RAWDEV(DEVNAME NODEDEVICE, DEVICE wireless);
pc::PacketCompression(CMODE 0, DEBUG 2);

rawdevice
#ifdef COMP_DEBUG
  -> Print("RECEIVE",60, TIMESTAMP true)
#endif
  -> WifiDecap()
  -> comp_clf::Classifier(12/abcd, -)
  -> BRN2EtherDecap()
//-> BRN2Decap()
  -> [1]pc 
#ifdef COMP_DEBUG
  -> Print("Compression")
#endif
  -> Discard;

Idle
  -> rawdevice;
  
Idle
  -> [0]pc;  
  
pc[1]
#ifdef COMP_DEBUG
  -> Print("Decomp")
#endif
  -> cnt_rx_dec::Counter()
  -> BRN2EtherDecap()
  -> BRN2Decap()
  -> sf::BRN2SimpleFlow()
  -> Discard;

comp_clf[1]
  -> cnt_rx_dec;
  
pc[2]
#ifdef COMP_DEBUG
  -> Print("Compression Error")
#endif
  -> Discard;

pc[3]
  -> Print("Decompression Error")
  -> Discard;
  
Script(
  wait  7,
  read  sf.stats,
  read  cnt_rx_dec.count,
  read  cnt_rx_dec.byte_count
);
