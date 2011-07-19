#define DEBUGLEVEL 2

#define PACKET_REUSE 1
//#define NOPCAP

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

ps::BRN2PacketSource(SIZE 2268, INTERVAL 200, MAXSEQ 500000, BURST 25, PACKETCOUNT 50, ACTIVE true)
//ps::BRN2PacketSource(SIZE 1460, INTERVAL 20, MAXSEQ 500000, BURST 2, ACTIVE true)
  -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> PrintWifi("Sender", TIMESTAMP true)
  -> rate::SetTXRates( RATE0 2, TRIES0 1, MCS0 false, BW0 0, SGI0 false, GF0 true, FEC0 0, SP0 true, STBC0 false, DEBUG false )
//  -> SetTXRates(RATE0 2, TRIES0 1, TRIES1 0, TRIES2 0, TRIES3 0)
  -> SetTXPower(13)
  -> wifioutq::NotifierQueue(1000)
  -> wifidevice
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
//  -> BRN2PrintWifi("TXFeedback", TIMESTAMP true)
  -> discard;