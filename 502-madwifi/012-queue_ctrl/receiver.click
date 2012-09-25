#define DEBUGLEVEL 2

#define RAWDUMP
#define CST cst

#if WIFITYPE == 802
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:11.0/stats/channel_utility"
#else
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"
#endif

// include unter helper/measurement/etc/click

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

Idle
  -> wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless)
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
//  -> Print("NODENAME RX")
  -> cnt::Counter()
  -> discard::Discard;

error_clf[1]
  -> discard;

error_clf[2]
  -> discard;

error_clf[3]
  -> discard;

error_clf[4]
  -> discard;

error_clf[5]
  -> discard;

error_clf[6]
  -> discard;

error_clf[7]
  -> discard;

filter_tx[1]
  -> discard;
/*
Script(
 wait 1,
// read wifidevice/ced.stats,
 write cnt.reset 1,
 wait 10,
 read cnt.count,
 read cnt.byte_count,
 read wifidevice/cst.stats,
 write cnt.reset 1,
 wait 10,
 read cnt.count,
 read cnt.byte_count,
 read wifidevice/cst.stats,
 write cnt.reset 1,
 wait 10,
 read cnt.count,
 read cnt.byte_count,
 read wifidevice/cst.stats,
 write cnt.reset 1,
 wait 10,
 read cnt.count,
 read cnt.byte_count,
 read wifidevice/cst.stats,
 write cnt.reset 1,
 wait 10,
 read cnt.count,
 read cnt.byte_count,
 read wifidevice/cst.stats
);
*/