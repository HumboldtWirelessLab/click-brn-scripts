#define DEBUGLEVEL 2

#define RAWDUMP 1

#define CST cst

#if WIFITYPE == 802

//#if NODEDEVICE == "wlan0"
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:11.0/stats/channel_utility"
//#else
//#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:12.0/stats/channel_utility"
//#endif

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


wifioutq::NotifierQueue(1000)
  -> wifidevice
  -> Discard;

ps::BRN2PacketSource(SIZE 50, INTERVAL 100, MAXSEQ 500000, BURST 1, PACKETCOUNT 12000, ACTIVE false)
  -> EtherEncap(0x8086, deviceaddress, ff-ff-ff-ff-ff-ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> rrs::RoundRobinSwitch();

/* R A T E S */

/* 80211b */

  rrs[0]
  -> SetTXRates( RATE0 2, TRIES0 1, MCS0 false )
  -> wifioutq;

  rrs[1]
  -> SetTXRates( RATE0 4, TRIES0 1, MCS0 false )
  -> wifioutq;

  rrs[2]
  -> SetTXRates( RATE0 11, TRIES0 1, MCS0 false )
  -> wifioutq;

  rrs[3]
  -> SetTXRates( RATE0 22, TRIES0 1, MCS0 false )
  -> wifioutq;

/* 80211ag */

  rrs[4]
  -> SetTXRates( RATE0 12, TRIES0 1, MCS0 false )
  -> wifioutq;

  rrs[5]
  -> SetTXRates( RATE0 18, TRIES0 1, MCS0 false )
  -> wifioutq;

  rrs[6]
  -> SetTXRates( RATE0 24, TRIES0 1, MCS0 false )
  -> wifioutq;

  rrs[7]
  -> SetTXRates( RATE0 36, TRIES0 1, MCS0 false )
  -> wifioutq;

  rrs[8]
  -> SetTXRates( RATE0 48, TRIES0 1, MCS0 false )
  -> wifioutq;

  rrs[9]
  -> SetTXRates( RATE0 72, TRIES0 1, MCS0 false )
  -> wifioutq;

  rrs[10]
  -> SetTXRates( RATE0 96, TRIES0 1, MCS0 false )
  -> wifioutq;

  rrs[11]
  -> SetTXRates( RATE0 108, TRIES0 1, MCS0 false )
  -> wifioutq;

Script(
  wait 1,
  write ps.active true
);

Script(
  wait 10,
  read wifidevice/cst.stats_xml,
  loop
);

