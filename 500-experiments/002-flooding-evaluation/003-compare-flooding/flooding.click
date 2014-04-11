#define DEBUGLEVEL 2

#include "flooding_config.h"

//#define WIFIDEV_LINKSTAT_DEBUG
//#define RAWDUMP

#define BRNFEEDBACK

#define CST cst
#define CERR
#define COOPCST
#define COOPCST_STRING "device_wifi/cocst"

#define PRIO_QUEUE
#define LINKPROBE_PERIOD                                           2000
#define LINKPROBE_TAU                                            100000
#define LINKPROBE_PROBES                   "2 200 24 2 200 23 11 200 24 11 200 23"
#define DISABLE_LP_POWER

#ifndef RTSCTS_STRATEGY
#define RTSCTS_STRATEGY 0
#endif

#ifndef RS_STRATEGY
#define RS_STRATEGY 0
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

rtscts_packetsize::RtsCtsPacketSize(PACKETSIZE 32);
rtscts_hiddennode::RtsCtsHiddenNode(HIDDENNODE device_wifi/wifidevice/hnd);
rtscts_flooding::RtsCtsFlooding(FLOODING flooding/fl, FLOODINGHELPER flooding/fl_helper, HIDDENNODE device_wifi/wifidevice/hnd, DEBUG 4);

rate_fix::BrnFixRate(RATE0 2, TRIES0 DEFAULT_DATATRIES, TRIES1 0, TRIES2 0, TRIES3 0);
rate_flooding::BrnFloodingRate(FLOODING flooding/fl, FLOODINGHELPER flooding/fl_helper, LINKSTAT device_wifi/link_stat, CHANNELSTATS device_wifi/wifidevice/cst, STRATEGY RS_STRATEGY, DEFAULTRETRIES 7, DEBUG 4);

rates::BrnAvailableRates(DEFAULT 2 4 11 12 18 22 24 36 48 72 96 108);

brn_clf[1]
  -> [1]flooding[1]
  -> data_rate::SetTXPowerRate(RATESELECTIONS "rate_fix rate_flooding", STRATEGY 5, RT rates, POWER 24, OFFSET -1)
  -> setrtscts::Brn2_SetRTSCTS(STRATEGY RTSCTS_STRATEGY, RTSCTS_SCHEMES "rtscts_hiddennode rtscts_flooding", HEADER 2, DEBUG 4)
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
//read lt.links,
  read device_wifi/link_stat.bcast_stats,
  read device_wifi/wifidevice/cst.stats,
//read device_wifi/cocst.stats,
//read device_wifi/wifidevice/hnd.stats,
  wait 20,
  read setrtscts.stats
//read sf.stats
);

// 5 + 10 + 60 + TAU = 185

#ifdef MPR_STATS
Script(
  wait 184,
  write flooding/flp.mpr_algo,
  read flooding/flp.flooding_info
);
#endif

