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

//#define NOPCAP
#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"


AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

cst::ChannelStats(DEVICE wireless, STATS_DURATION 1000, PROCFILE CST_PROCFILE, PROCINTERVAL 1000, NEIGHBOUR_STATS true, FULL_STATS false, SAVE_DURATION 1000 );

FROMRAWDEVICE(NODEDEVICE)
  -> tdraw :: ToDump("RESULTDIR/NODENAME.NODEDEVICE.raw.dump", SNAPLEN 7500);

Idle -> cst -> Discard;

Script(
  wait 10,
  read cst.stats_xml
);