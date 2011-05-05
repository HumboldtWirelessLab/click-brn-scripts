#define DEBUGLEVEL 2
//#define RAWDEV_DEBUG 1

//#define NOPCAP

#define CST cst

#if WIFITYPE == 802
//#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:11.0/stats/channel_utility"
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:10.0/stats/channel_utility"
#else
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"
#endif


#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

/*Idle
-> ath_op::Ath2Operation(DEVICE wireless, READCONFIG false, DEBUG 2)
-> Discard;
  */
  
wifidevice
  //-> PrintWifi("Feedback", TIMESTAMP true)
  -> Discard;

//rate::SetTXRates(RATE0 108, TRIES0 1, TRIES1 0, TRIES2 0, TRIES3 0)
//rate::SetTXRates(RATE0 108, RATE1 11, RATE2 4, RATE3 2, TRIES0 2, TRIES1 2, TRIES2 2, TRIES3 2)

//rate::SetTXRates( RATE0 15, RATE1 7, RATE2 12, RATE3 2, TRIES0 3, TRIES1 1, TRIES2 2, TRIES3 4, MCS0 true, MCS1 true, MCS2 false, MCS3 false ) //MCS
//rate::SetTXRates( RATE0 7, RATE1 7, RATE2 7, RATE3 7, TRIES0 10, TRIES1 10, TRIES2 10, TRIES3 10, MCS0 true, MCS1 true, MCS2 true, MCS3 true ) //MCS
//rate::SetTXRates( RATE0 72, RATE1 72, RATE2 72, RATE3 72, TRIES0 10, TRIES1 10, TRIES2 10, TRIES3 10, MCS0 false, MCS1 false, MCS2 false, MCS3 false )

rate::SetTXRates( RATE0 15, TRIES0 1, MCS0 true, FEC0 1 )
//rate::SetTXRates( RATE0 108, TRIES0 1, MCS0 false )
  //-> SetTXPower(13)
  -> wifioutq::NotifierQueue(1000)
  -> cnt::Counter()
  //-> PrintWifi("Sender", TIMESTAMP true)
  -> wifidevice;

ps::BRN2PacketSource(SIZE /*1800*//* 2200*/ 3730 /*4000*/, INTERVAL 10 /*20*/, MAXSEQ 500000, BURST 40, ACTIVE false)
  -> cnt2::Counter()
  //-> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  //-> PrintWifi("Sender", TIMESTAMP true)
  -> rate;

/*
BRN2PacketSource(SIZE 1500, INTERVAL 10, MAXSEQ 500000, BURST 50, ACTIVE false)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, 00:0f:00:00:00:02)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
 // -> PrintWifi("Sender", TIMESTAMP true)
  -> rate;

BRN2PacketSource(SIZE 100, INTERVAL 1000, MAXSEQ 500000, BURST 1, ACTIVE false)
  -> SetTimestamp()
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:03)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> PrintWifi("Sender", TIMESTAMP true)
  -> rate;
*/

Script(
  wait 1,
  write ps.active true
  /*
  wait 7,
  write cnt.reset,
  wait 1,
  read cnt.bit_rate,
  read cnt.count,
  read cnt.byte_count,
  read cnt2.bit_rate,
  read cnt2.count,
  read cnt2.byte_count*/
);

Script(
 wait 1,
 read cnt.count,
 loop
);
