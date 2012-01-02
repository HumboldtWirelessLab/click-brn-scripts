#define DEBUGLEVEL 2

#define RAWDUMP 1

#define CST cst

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

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);


wifioutq::NotifierQueue(2000)
  -> wifidevice
  -> Discard;


/* R A T E S */

/* 80211b */

  ps_0::BRN2PacketSource(SIZE 18, INTERVAL 10, MAXSEQ 500000, BURST 1, PACKETCOUNT 10000, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, ff-ff-ff-ff-ff-ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  //-> SetTXRates( RATE0 2, TRIES0 1, MCS0 false )
  -> SetTXRates( RATE0 12, TRIES0 1, MCS0 false )
  //-> SetTXRates( RATE0 0, TRIES0 1, MCS0 true, BW0 0, SGI0 false, GF0 false, FEC0 0, SP0 false, STBC0 false, DEBUG false )
  -> wifioutq;

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

