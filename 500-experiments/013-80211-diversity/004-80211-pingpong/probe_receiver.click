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

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

  Idle()
  -> wifidevice
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRates( RATE0 12, TRIES0 1, MCS0 false )
  -> Discard;


