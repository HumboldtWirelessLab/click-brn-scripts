#define DEBUGLEVEL 2

//#define RAWDUMP

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

Idle
-> wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless)
-> discard::Discard;


Script(
  read wifidevice/cst.stats,
  wait 1,
  loop
  );


Idle->
setchannel::BRN2SetChannel(DEVICE wireless)
-> Discard;

Script(
  write setchannel.systemchannel 1,
  wait 300,
  write setchannel.systemchannel 2,
  wait 300,
  write setchannel.systemchannel 3,
  wait 300,
  write setchannel.systemchannel 4,
  wait 300,
  write setchannel.systemchannel 5,
  wait 300,
  write setchannel.systemchannel 6,
  wait 300,
  write setchannel.systemchannel 7,
  wait 300,
  write setchannel.systemchannel 8,
  wait 300,
  write setchannel.systemchannel 9,
  wait 300,
  write setchannel.systemchannel 10,
  wait 300,
  write setchannel.systemchannel 11,
  wait 300
  write setchannel.systemchannel 12,
  wait 300,
  write setchannel.systemchannel 13,
  wait 300,
  write setchannel.systemchannel 14,
  wait 300,
  write setchannel.systemchannel 34,
  wait 300
  write setchannel.systemchannel 38,
  wait 300,
  write setchannel.systemchannel 42,
  wait 300,
  write setchannel.systemchannel 46,
  wait 300
);
