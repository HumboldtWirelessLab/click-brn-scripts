#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/simdev.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

rawdevice::RAWDEV(DEVNAME eth0, DEVICE wireless);

pc::PacketCompression(CMODE 0, DEBUG 4);

rawdevice
  -> Discard;
Idle
  -> sf_src::BRN2SimpleFlow(SRCADDRESS 00:0f:00:00:00:00, DSTADDRESS 00:0f:00:00:01:00, RATE 100 , SIZE 500, MODE 0, DURATION 20000, ACTIVE 0, CLEARPACKET true)
  -> BRN2EtherEncap(USEANNO true)
//-> Print("ETHER-out")
  -> pc
  -> EtherEncap( 0xabcd, 00:0f:00:00:00:00, 00:0f:00:00:01:00 )
//-> Print("COMP-out")
  -> cnt::Counter()
  -> wifien::WifiEncap(0x00, 0:0:0:0:0:0)
  -> rawdevice;

pc[1]
  -> Print("Decomp-out")
  -> Discard;

pc[2]
  -> Print("Compression Error")
  -> wifien;

pc[3]
  -> Print("Decompression Error")
  -> Discard;

Idle
  -> [1]pc;
  
Script(
  write  sf_src.active 1,
  wait  10,
  read  sf_src.txflows,
  read  sf_src.rxflows,
  read  cnt.count,
  read  cnt.byte_count
);
