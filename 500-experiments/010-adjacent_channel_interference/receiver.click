#define DEBUGLEVEL 2

#include "performance.click"

//#define ENABLE_PCAP
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

Idle()
  -> wifidevice
  -> cnt::Counter()
//  -> tdraw :: ToDump("RESULTDIR/NODENAME.NODEDEVICE.raw.dump", SNAPLEN 7500);
  -> Discard;

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

Script(
  wait 10,
  write cnt.reset,
  wait 10,
  read cnt.bit_rate,
  read cnt.count,
  read cnt.byte_count,
  read wifidevice/cst.stats_xml,
  wait 2,
  read wifidevice/cst.stats_xml,
  wait 1,
  read sys_info.systeminfo
);
