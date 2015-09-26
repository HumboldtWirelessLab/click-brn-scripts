#define DEBUGLEVEL 2

//#define COMP_DEBUG

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

rawdevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);
pc::PacketCompression(CMODE 0, DEBUG 2);
pdc::PacketDecompression(CMODE 0, DEBUG 2);

rawdevice
#ifdef COMP_DEBUG
  -> Print("RECEIVE",60, TIMESTAMP true)
#endif
  -> WifiDecap()
  -> comp_clf::Classifier(12/abcd, -)
  -> BRN2EtherDecap()
//-> BRN2Decap()
  -> pdc
#ifdef COMP_DEBUG
  -> Print("Decomp")
#endif
  -> cnt_rx_dec::Counter()
  -> BRN2EtherDecap()
  -> BRN2Decap()
  -> sf::BRN2SimpleFlow()
  -> Discard;
 
pc
#ifdef COMP_DEBUG
  -> Print("Compression")
#endif
  -> Discard;

Idle
  -> rawdevice;
  
Idle
  -> pc;  

comp_clf[1]
  -> cnt_rx_dec;
  
pc[1]
#ifdef COMP_DEBUG
  -> Print("Compression Error")
#endif
  -> Discard;

pdc[1]
  -> Print("Decompression Error")
  -> Discard;
  
Script(
  wait  7,
  read  sf.stats,
  read  cnt_rx_dec.count,
  read  cnt_rx_dec.byte_count
);
