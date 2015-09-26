#define DEBUGLEVEL 2

#define FLOODING_DEBUG 2

#include "flooding.config"

//#define RAWDUMP
#define BRNFEEDBACK
#define ROUTING_TXFEEDBACK
#define FOREIGNRXSTATS
#define BCAST2UNIC_PDRCONFIG "101 5 115"

#define CST cst
#define CERR
#define COOPCST
#define COOPCST_STRING "device_wifi/cocst"

#define PRIO_QUEUE
#define LINKPROBE_PERIOD                                         2000
#define LINKPROBE_TAU                                          100000
#define LINKPROBE_PROBES                                       "2 100 24"
//#define LINKPROBE_PROBES                   "2 200 24 2 200 23 11 200 24 11 200 23"
#define DISABLE_LP_POWER

#define FLOODING_STRATEGY 1
//#define OVERLAYFLOODING_FILENAME "../97_overlays_new/limit90mac"
//#define GG_GRAPH
//#define GG_THRESHOLD 0

//#define RN_GRAPH
//#define RN_THRESHOLD 0

//#define DISBALE_BCASTWIFIDUPS

//#ifndef BCAST_ENABLE_ABORT_TX
#define BCAST_ENABLE_ABORT_TX 3
//#endif

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
#include "routing/routing.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

flooding::BROADCASTFLOODING(ID id, LT lt, LINKSTAT device_wifi/link_stat);
routing::ROUTING(ID id, ETHERADDRESS deviceaddress, LT lt, METRIC device_wifi/etx_metric, LINKSTAT device_wifi/link_stat);

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
  -> brn_clf::Classifier(    0/BRN_PORT_FLOW,         //Simpleflow
                             0/BRN_PORT_FLOODING,     //Flooding
                             0/BRN_PORT_ROUTING,      //Routing
                               -  );                  //other


device_wifi[1] -> /*Print("BRN-In") -> */ BRN2EtherDecap() -> brn_clf;

Idle -> [1]device_wifi;

brn_clf[0]
//-> Print("rx")
  -> BRN2Decap()
  -> sf::BRN2SimpleFlow(HEADROOM 256, ROUTINGPEEK flooding/routing_peek, LT lt, DEBUG 2)
  -> BRN2EtherEncap(USEANNO true)
  -> [0]flooding;

rate_fix::BrnFixRate(RATE0 2, TRIES0 DEFAULT_DATATRIES, TRIES1 0, TRIES2 0, TRIES3 0);
rate_flooding::BrnFloodingRate(FLOODING flooding/fl, FLOODINGHELPER flooding/fl_helper, FLOODINGDB flooding/fl_database, LINKSTAT device_wifi/link_stat, CHANNELSTATS device_wifi/wifidevice/cst, STRATEGY 0, DEFAULTRETRIES 7, DEBUG 4);

rates::BrnAvailableRates(DEFAULT 2 4 11 12 18 22 24 36 48 72 96 108);


brn_clf[1]
  -> [1]flooding[1]
//  -> SetTXRates(RATE0 2, TRIES0 DEFAULT_DATATRIES, TRIES1 0, TRIES2 0, TRIES3 0)
//  -> SetTXPowerRate(RATE0 2, TRIES0 DEFAULT_DATATRIES, TRIES1 0, TRIES2 0, TRIES3 0)
//  -> SetTXRate(RATE 2, TRIES DEFAULT_DATATRIES)
//  -> SetTXPower(24)
  -> data_rate::SetTXPowerRate(RATESELECTIONS "rate_fix rate_flooding", STRATEGY 5, RT rates, POWER 24, OFFSET -1)
//  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> [2]device_wifi;

flooding[0] -> Label_brnether;
flooding[2] -> Print("NODENAME: FloodingFeedback",20) -> Discard;

brn_clf[2] -> [1]routing;


routing[0] -> [0]device_wifi;
routing[1] -> [1]device_wifi;
routing[3] -> Discard;

brn_clf[3] -> Discard;

device_wifi[2] 
  -> BRN2EtherDecap()
  -> foreign_clf::Classifier( 0/BRN_PORT_FLOODING,
                              0/BRN_PORT_ROUTING )
  -> [3]flooding;

foreign_clf[1]
  -> [3]routing;

device_wifi[3]
  //-> Print("Feedback")
  -> BRN2EtherDecap()
  -> fb_filter::Classifier( 0/BRN_PORT_FLOODING,
                 0/BRN_PORT_ROUTING)
  -> ffilter_flood::FilterFailures()
  -> [4]flooding; //feedback failure

ffilter_flood[1] -> [2]flooding; //feedback success

fb_filter[1]
  -> ffilter_routing::FilterFailures()
  -> [4]routing; //feedback failure

ffilter_routing[1] -> [2]routing; //feedback success

routing[2]
  -> BRN2EtherDecap()
  -> BRN2Decap()
  -> unicastsf::BRN2SimpleFlow(HEADROOM 256, ROUTINGPEEK routing/routing/routing_peek, LT lt, DEBUG 4)
  -> BRN2EtherEncap(USEANNO true)
  -> [0]routing;

routing[4]
  -> Print("NODENAME: Routingfeedback",50,TIMESTAMP true)
  -> BRN2EtherDecap()
  -> BRN2Decap()
  -> [1]unicastsf;

Script(
  wait 100,
  wait 5,
  read lt.links,
  read device_wifi/link_stat.bcast_stats,
//  read device_wifi/wifidevice/cst.stats,
  wait 10,
  wait 60
 // read flooding/fl.stats,
 // read flooding/fl.forward_table,
 // read flooding/unicfl.stats,
 // read flooding/fl_passive_ack.stats,
 // read sf.stats
);

// 5 + 10 + 60 + TAU = 185

#ifdef MPR_STATS
Script(
  wait 100,
  write flooding/flp.mpr_algo,
  read flooding/flp.flooding_info,
);
#endif
