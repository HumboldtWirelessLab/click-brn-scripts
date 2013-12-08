#define DEBUGLEVEL 2

#include "flooding_config.h"

//#define WIFIDEV_LINKSTAT_DEBUG
//#define RAWDUMP

#define BRNFEEDBACK

#define CST cst

#define PRIO_QUEUE
#define LINKPROBE_PERIOD                                           2000
#define LINKPROBE_TAU                                            100000
//#define LINKPROBE_PROBES "2 100 2 1000 12 100 12 1000 22 100 22 1000"
#define LINKPROBE_PROBES                                        "2 100"
#define DISABLE_LP_POWER

#ifndef RTSCTS_STRATEGY
#define RTSCTS_STRATEGY 0
#endif

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
  -> sf::BRN2SimpleFlow(HEADROOM 192, ROUTINGPEEK flooding/routing_peek, LT lt, DEBUG 2)
  -> BRN2EtherEncap(USEANNO true)
  -> [0]flooding;

brn_clf[2] -> Discard;

brn_clf[1]
  -> [1]flooding[1]
  -> data_rate::SetTXRates(RATE0 2, TRIES0 DEFAULT_DATATRIES, TRIES1 0, TRIES2 0, TRIES3 0)
  -> Brn2_SetRTSCTS(STRATEGY RTSCTS_STRATEGY)
  -> [2]device_wifi;

Idle()
  -> [0]device_wifi;

flooding[0] -> Label_brnether;

device_wifi[2] 
  -> BRN2EtherDecap()
  -> foreign_clf::Classifier( 0/BRN_PORT_FLOODING )
  -> [3]flooding;

#ifdef BRNFEEDBACK
device_wifi[3]
#else
  Idle()
#endif
  //-> Print("Feedback")
  -> BRN2EtherDecap()
  -> Classifier( 0/BRN_PORT_FLOODING)
  -> ffilter::FilterFailures()
  -> [4]flooding; //feedback failure

ffilter[1] -> [2]flooding; //feedback success

Script(
  wait 100,
  wait 5,
  read lt.links,
  read device_wifi/link_stat.bcast_stats,
  read device_wifi/wifidevice/cst.stats,
//  wait 10,
//  write sf.add_flow NODEMACADDR FF-FF-FF-FF-FF-FF 500 100 0 50000 true, //flooding_init 51000  //51000 -> 100Pkt
//  wait 600,
//  wait 60,
//  read flooding/fl.stats,
//  read flooding/fl.forward_table,
//  read flooding/unicfl.stats,
//  read sf.stats
);

// 5 + 10 + 60 + TAU = 185

#ifdef MPR_STATS
Script(
  wait 184,
  write flooding/flp.mpr_algo,
  read flooding/flp.flooding_info
);
#endif
