#define DEBUGLEVEL 2
//#define RAWDEV_DEBUG 1

//#define CST cst

#if WIFITYPE == 802

#if NODEDEVICE == wlan1
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:11.0/stats/channel_utility"
#else
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:10.0/stats/channel_utility"
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

wifidevice
  -> Discard;

ps::BRN2PacketSource(SIZE 2200, INTERVAL 10, MAXSEQ 500000, BURST 40, ACTIVE false)
  -> cnt2::Counter()
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)

  -> rate::SetTXRates( RATE0 15, TRIES0 1, MCS0 true, FEC0 1 )
  //-> rate::SetTXRates( RATE0 108, TRIES0 1, MCS0 false )

  -> wifioutq::NotifierQueue(1000)
  -> cnt::Counter()
  -> wifidevice;


Script(
  wait 1,
  write ps.active true
);

Script(
 wait 1,
 read cnt.count,
 loop
);
