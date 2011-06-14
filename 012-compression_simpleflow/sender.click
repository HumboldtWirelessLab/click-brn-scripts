#define DEBUGLEVEL 2

//#define COMP_DEBUG

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

rawdevice::RAWDEV(DEVNAME NODEDEVICE, DEVICE wireless);

pc::PacketCompression(CMODE 0, DEBUG 4);

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
  -> rawdevice;

pc[1]
#ifdef COMP_DEBUG
  -> Print("Decomp-out")
#endif
  -> Discard;

pc[2]
  -> Print("Compression Error (Compression not worthwhile)")
  -> cnt_tx_comp;

pc[3]
#ifdef COMP_DEBUG
  -> Print("Decompression Error")
#endif
  -> Discard;

Idle
  -> [1]pc;
  
Script(
  write sf.add_flow 00:00:00:00:00:01 00:00:00:00:00:02 10 1000 2 100 true,
  wait  6,
  write sf.add_flow 00:00:00:00:00:01 00:00:00:00:00:02 10 1000 2 100 false,
  read  sf.stats,
  read  cnt_tx_comp.count,
  read  cnt_tx_comp.byte_count
);
