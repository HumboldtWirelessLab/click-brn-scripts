#define DEBUGLEVEL 2
#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

wifioutq::NotifierQueue(1000)
 -> wifidevice
 -> Discard;

BRN2PacketSource(SIZE 68, INTERVAL 20, MAXSEQ 500000, BURST 1, PACKETCOUNT 1000, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRates( RATE0 2, TRIES0 1 )
  -> wifioutq;

BRN2PacketSource(SIZE 68, INTERVAL 20, MAXSEQ 500000, BURST 1, PACKETCOUNT 1000, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRates( RATE0 0, TRIES0 1, MCS0 true, BW0 0 )
  -> wifioutq;

BRN2PacketSource(SIZE 68, INTERVAL 20, MAXSEQ 500000, BURST 1, PACKETCOUNT 1000, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRates( RATE0 0, TRIES0 1, MCS0 true, BW0 1 )
  -> wifioutq;

BRN2PacketSource(SIZE 68, INTERVAL 20, MAXSEQ 500000, BURST 1, PACKETCOUNT 1000, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRates( RATE0 8, TRIES0 1, MCS0 true, BW0 0 )
  -> wifioutq;

BRN2PacketSource(SIZE 68, INTERVAL 20, MAXSEQ 500000, BURST 1, PACKETCOUNT 1000, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRates( RATE0 8, TRIES0 1, MCS0 true, BW0 1 )
  -> wifioutq;
