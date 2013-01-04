#define DEBUGLEVEL 2

#include "flooding_config.h"

//#define WIFIDEV_LINKSTAT_DEBUG
//#define PRO_FL
//#define RAWDUMP
#define BRNFEEDBACK

#define CST cst

#define LINKPROBE_PERIOD                                         2000
#define LINKPROBE_TAU                                          100000
//#define LINKPROBE_PROBES "2 100 2 1000 12 100 12 1000 22 100 22 1000"
#define LINKPROBE_PROBES                                       "2 100"
#define DISABLE_LP_POWER

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "routing/broadcastflooding.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

flooding::BROADCASTFLOODING(ID id, LT lt);

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
  -> brn_clf::Classifier(    0/BRN_PORT_FLOW,         //Simpleflow
                             0/BRN_PORT_FLOODING,     //Flooding
                               -  );                  //other

device_wifi[1] -> /*Print("BRN-In") -> */ BRN2EtherDecap() -> brn_clf;

Idle -> [1]device_wifi;

brn_clf[0]
//-> Print("rx")
  -> BRN2Decap()
  -> sf::BRN2SimpleFlow(HEADROOM 192, DEBUG 2)
  -> BRN2EtherEncap(USEANNO true)
  -> [0]flooding;

brn_clf[2] -> Discard;

brn_clf[1]
  -> [1]flooding[1]
  -> rdq::RandomDelayQueue(MINDELAY 2, MAXDELAY 5, DIFFDELAY 5)
  -> [0]device_wifi;

flooding[0] -> Label_brnether;

device_wifi[2] -> Discard; //foreign
#ifdef BRNFEEDBACK
device_wifi[3]
#else
  Idle()
#endif
  -> Print("Feedback")
  -> BRN2EtherDecap()
  -> Classifier( 0/BRN_PORT_FLOODING)
  -> ffilter::FilterFailures()
  -> [4]flooding; //feedback failure

Idle -> [3]flooding;
ffilter[1] -> [2]flooding; //feedback success

Script(
  wait 100,
  wait 5,
  read lt.links,
  read device_wifi/link_stat.bcast_stats,
  read device_wifi/wifidevice/cst.stats,
  wait 10,
  wait 60,
  read flooding/fl.stats,
  read flooding/fl.forward_table,
  read sf.stats
);

// 5 + 10 + 60 + TAU = 185
