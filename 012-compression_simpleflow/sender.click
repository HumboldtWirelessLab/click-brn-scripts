#define DEBUGLEVEL 2

//#define COMP_DEBUG

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

rawdevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

pc::PacketCompression(CMODE 0, DEBUG 4);
pdc::PacketDecompression(CMODE 0, DEBUG 4);

rawdevice
  -> Discard;
Idle
  -> sf::BRN2SimpleFlow(CLEARPACKET true)
  -> BRN2EtherEncap(USEANNO true)
#ifdef COMP_DEBUG
  -> Print("ETHER-out")
#endif
  -> pc
  -> EtherEncap( 0xabcd, 00:00:00:00:00:01, 00:00:00:00:00:02 )
#ifdef COMP_DEBUG
  -> Print("COMP-out")
#endif
  -> cnt_tx_comp::Counter()
  -> wifien::WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRate(RATE 2, TRIES 1)
  -> rawdevice;

pdc
#ifdef COMP_DEBUG
  -> Print("Decomp-out")
#endif
  -> Discard;

pc[1]
  -> Print("Compression Error (Compression not worthwhile)")
  -> cnt_tx_comp;

pdc[1]
#ifdef COMP_DEBUG
  -> Print("Decompression Error")
#endif
  -> Discard;

Idle
  -> pdc;
  
Script(
  write sf.add_flow 00:00:00:00:00:01 00:00:00:00:00:02 10 1000 2 1000 true,
  wait  6,
  write sf.add_flow 00:00:00:00:00:01 00:00:00:00:00:02 10 1000 2 1000 false,
  read  sf.stats,
  read  cnt_tx_comp.count,
  read  cnt_tx_comp.byte_count
);
