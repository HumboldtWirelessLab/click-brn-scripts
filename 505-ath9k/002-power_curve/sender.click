#define DEBUGLEVEL 2

#if WIFITYPE == 802

#if DEVICENUMBER == 0
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:11.0/stats/channel_utility"
#else
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:12.0/stats/channel_utility"
#endif

#else
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"
#endif

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"


BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

cst::ChannelStats(DEVICE wireless, STATS_DURATION 1000, PROCFILE CST_PROCFILE, PROCINTERVAL 1000, NEIGHBOUR_STATS true, FULL_STATS false, SAVE_DURATION 1000 );

wifioutq::NotifierQueue(1000)
 -> wifidevice
 -> Discard;

BRN2PacketSource(SIZE 12, INTERVAL 20, MAXSEQ 500000, BURST 1, PACKETCOUNT 1000, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRates( RATE0 2, TRIES0 1 )
  -> wifioutq;

BRN2PacketSource(SIZE 12, INTERVAL 20, MAXSEQ 500000, BURST 1, PACKETCOUNT 1000, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRates( RATE0 12, TRIES0 1 )
  -> wifioutq;

BRN2PacketSource(SIZE 12, INTERVAL 20, MAXSEQ 500000, BURST 1, PACKETCOUNT 1000, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRates( RATE0 0, TRIES0 1, MCS0 true, BW0 0 )
  -> wifioutq;

BRN2PacketSource(SIZE 12, INTERVAL 20, MAXSEQ 500000, BURST 1, PACKETCOUNT 1000, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRates( RATE0 0, TRIES0 1, MCS0 true, BW0 1 )
  -> wifioutq;

BRN2PacketSource(SIZE 12, INTERVAL 20, MAXSEQ 500000, BURST 1, PACKETCOUNT 1000, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRates( RATE0 8, TRIES0 1, MCS0 true, BW0 0 )
  -> wifioutq;

BRN2PacketSource(SIZE 12, INTERVAL 20, MAXSEQ 500000, BURST 1, PACKETCOUNT 1000, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRates( RATE0 8, TRIES0 1, MCS0 true, BW0 1 )
  -> wifioutq;

Idle -> cst -> Discard;

Script(
  wait 10,
  read cst.stats_xml
);
