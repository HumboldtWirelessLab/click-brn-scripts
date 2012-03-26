#define DEBUGLEVEL 2

#define CST cst

#if DEVICENUMBER == 0
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:11.0/stats/channel_utility"
#else
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:12.0/stats/channel_utility"
#endif

//#define PACKET_REUSE 1

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

ps::BRN2PacketSource(SIZE 68, INTERVAL 20, MAXSEQ 500000, BURST 1, PACKETCOUNT 100000, ACTIVE true)
  -> Print()
//ps::BRN2PacketSource(SIZE 1460, INTERVAL 20, MAXSEQ 500000, BURST 2, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
//-> PrintWifi("Sender", TIMESTAMP true)
//-> rate::SetTXRates( RATE0 0, TRIES0 1, MCS0 true, BW0 0, SGI0 false, GF0 false, FEC0 0, SP0 false, STBC0 false, DEBUG false )
  -> rate::SetTXRates(RATE0 2, TRIES0 1, TRIES1 0, TRIES2 0, TRIES3 0)
  -> SetTXPower(16)
  -> wifioutq::NotifierQueue(1000)
  -> wifidevice
  -> Discard;

#ifdef PACKET_REUSE
wifidevice[1]
-> Discard;
#endif

/*
  Idle
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
//  -> PrintWifi("OKPacket", TIMESTAMP true)
  -> discard::Discard;

wifidevice[1]
-> rate;

error_clf[1]
//  -> BRN2PrintWifi("CRCerror", TIMESTAMP true)
  -> discard;

error_clf[2]
//  -> BRN2PrintWifi("PHYerror", TIMESTAMP true)
  -> discard;

error_clf[3]
//  -> BRN2PrintWifi("FIFOerror", TIMESTAMP true)
  -> discard;

error_clf[4]
//  -> BRN2PrintWifi("DECRYPTerror", TIMESTAMP true)
  -> discard;

error_clf[5]
//  -> BRN2PrintWifi("MICerror", TIMESTAMP true)
  -> discard;

error_clf[6]
//  -> BRN2PrintWifi("ZEROerror", TIMESTAMP true)
  -> discard;

error_clf[7]
//  -> BRN2PrintWifi("UNKNOWNerror", TIMESTAMP true)
  -> discard;

filter_tx[1]
  -> BRN2PrintWifi("TXFeedback", TIMESTAMP true)
  -> discard;


Script(
  wait 1,
  read wifidevice/cst.stats,
  loop
);
*/

Script(
  wait 1,
  write ps.active true
);
