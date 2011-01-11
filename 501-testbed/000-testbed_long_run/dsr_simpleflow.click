#define DEBUGLEVEL 2

//#define WIFIDEV_LINKSTAT_DEBUG
//#define ENABLE_DSR_DEBUG

//#define SETCHANNEL

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "routing/dsr.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE true, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 9998);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

//lpr::LPRLinkProbeHandler(LINKSTAT device_wifi/link_stat, ETXMETRIC device_wifi/etx_metric);

dsr::DSR(id,lt,rc,device_wifi/etx_metric);

#ifndef SIMULATION
sys_info::SystemInfo(NODEIDENTITY id);
#endif

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
//-> Print("Foo",100)
  -> brn_clf::Classifier(    0/BRN_PORT_DSR,  //BrnDSR
                             0/BRN_PORT_FLOW, //Simpleflow
                               -  );//other

brn_clf[0]
//-> Print("DSR-Packet")
  ->  [1]dsr;

device_wifi[1] -> /*Print("BRN-In") -> */ BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;

Idle -> [2]dsr;

brn_clf[1]
//-> Print("rx")
-> BRN2Decap()
-> sf::BRN2SimpleFlow(HEADROOM 192, DEBUG 4)
-> BRN2EtherEncap(USEANNO true)
-> [0]dsr;

brn_clf[2] -> Discard;

dsr[0] -> toMeAfterDsr::BRN2ToThisNode(NODEIDENTITY id);
dsr[1] /*-> Print("DSR[1]-out")*/ -> BRN2EtherEncap() -> SetEtherAddr(SRC deviceaddress) /*-> Print("DSR-Ether-OUT")*/ -> [0]device_wifi;

toMeAfterDsr[0] -> /*Print("DSR-out: For ME",100) ->*/ Label_brnether; 
toMeAfterDsr[1] -> /*Print("DSR-out: Broadcast") ->*/ Discard;
toMeAfterDsr[2] -> /*Print("DSR-out: Foreign/Client") ->*/ [1]device_wifi;

Script(
#ifdef ENABLE_DSR_DEBUG
  write dsr/querier.debug 4,
  write dsr/req_forwarder.debug 4,
  write dsr/rep_forwarder.debug 4,
#endif
);

#ifdef SETCHANNEL
Script(
 write device_wifi/wifidevice/sc.set_channel NODEDEVICE 1,
 write device_wifi/wifidevice/cst.channel 1/*,
 wait 60,
 write device_wifi/wifidevice/sc.set_channel NODEDEVICE 2,
 write device_wifi/wifidevice/cst.channel 2,
 wait 60,
 write device_wifi/wifidevice/sc.set_channel NODEDEVICE 3,
 write device_wifi/wifidevice/cst.channel 3,
 wait 60,
 write device_wifi/wifidevice/sc.set_channel NODEDEVICE 4,
 write device_wifi/wifidevice/cst.channel 4,
 wait 60,
 write device_wifi/wifidevice/sc.set_channel NODEDEVICE 5,
 write device_wifi/wifidevice/cst.channel 5,
 wait 60,
 write device_wifi/wifidevice/sc.set_channel NODEDEVICE 6,
 write device_wifi/wifidevice/cst.channel 6,
 wait 60,
 write device_wifi/wifidevice/sc.set_channel NODEDEVICE 7,
 write device_wifi/wifidevice/cst.channel 7,
 wait 60,
 write device_wifi/wifidevice/sc.set_channel NODEDEVICE 8,
 write device_wifi/wifidevice/cst.channel 8,
 wait 60,
 write device_wifi/wifidevice/sc.set_channel NODEDEVICE 9,
 write device_wifi/wifidevice/cst.channel 9,
 wait 60,
 write device_wifi/wifidevice/sc.set_channel NODEDEVICE 10,
 write device_wifi/wifidevice/cst.channel 10,
 wait 60,
 write device_wifi/wifidevice/sc.set_channel NODEDEVICE 11,
 write device_wifi/wifidevice/cst.channel 11,
 wait 60,
 write device_wifi/wifidevice/sc.set_channel NODEDEVICE 12,
 write device_wifi/wifidevice/cst.channel 12,
 wait 60,
 write device_wifi/wifidevice/sc.set_channel NODEDEVICE 13,
 write device_wifi/wifidevice/cst.channel 13,
 wait 60,
 write device_wifi/wifidevice/sc.set_channel NODEDEVICE 14,
 write device_wifi/wifidevice/cst.channel 14,
 wait 60,
 loop */
);
#endif
