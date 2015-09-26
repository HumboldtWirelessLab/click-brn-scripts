#define DEBUGLEVEL 2

#define RAWDUMP
#define CST cst
#define CST_PROCFILE foo
#define COLLINFO
#define CERR
#define USE_RTS_CTS

// include unter helper/measurement/etc/click

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"
#include "device/wifidev_linkstat.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);
lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

/*
ps::BRN2PacketSource(SIZE 1460, INTERVAL 20, MAXSEQ 500000, BURST 1, ACTIVE true)
  -> SetTimestamp()
//  -> sf::BRN2SimpleFlow(DEBUG 2)
  -> EtherEncap(0x8086, deviceaddress, 00:00:00:00:00:03)
  -> SetTXPower(13)
  -> rdq::RandomDelayQueue(MINDELAY 30, MAXDELAY 200, DIFFDELAY 10, TIMESTAMPANNOS false)
  -> [0]device_wifi
//  -> filter_tx :: FilterTX()
//  -> error_clf :: WifiErrorClassifier()
  -> discard::Discard;
*/

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
  -> brn_clf::Classifier( 0/BRN_PORT_FLOW, //Simpleflow
                               -  );//other

brn_clf[0]
-> BRN2Decap()
-> sf::BRN2SimpleFlow(DEBUG 2)
-> BRN2EtherEncap(USEANNO true)
-> [0]device_wifi;

//-> filter_tx :: FilterTX()
//-> error_clf :: WifiErrorClassifier()
//-> discard::Discard;

brn_clf[1] -> Discard;

Idle -> [1]device_wifi;

//device_wifi[1] -> /* Print("BRN-In") -> */ BRN2EtherDecap() -> Discard;
device_wifi[1] -> BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;

/*
error_clf[1]
  -> Discard;

error_clf[2]
  -> Discard;

error_clf[3]
  -> Discard;

error_clf[4]
  -> Discard;

error_clf[5]
  -> Discard;

error_clf[6]
  -> Discard;

error_clf[7]
  -> Discard;
*/
//filter_tx[1]
//  -> discard;
