#define DEBUGLEVEL 2

//#define RAWDUMP

#define CST cst

#define CST_PROCINTERVAL 1000
#define CST_SAVE_DURATION 1000
#define CST_STATS_DURATION 1000

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

wifidevice
  -> Discard;

ps::BRN2PacketSource(SIZE 18 , INTERVAL 25, MAXSEQ 500000, BURST 1, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> rate::SetTXRates(RATE0 12, TRIES0 1, TRIES1 0, TRIES2 0, TRIES3 0)
  -> wifioutq::NotifierQueue(1000)
  -> wifidevice;
