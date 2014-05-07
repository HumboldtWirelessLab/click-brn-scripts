#define DEBUGLEVEL 2

#define FLOODING_DEBUG 2

#include "flooding.config"

#define PRIO_QUEUE
//#define RAWDUMP
#define BRNFEEDBACK
#define ROUTING_TXFEEDBACK
#define FOREIGNRXSTATS

#define CST cst

#define LINKPROBE_PERIOD                                         2000
#define LINKPROBE_TAU                                          100000
//#define LINKPROBE_PROBES "2 100 2 1000 12 100 12 1000 22 100 22 1000"
#define LINKPROBE_PROBES                                       "2 100"
#define DISABLE_LP_POWER

//#define PRO_FL
//#define MPR_FL
#define MST_FL
#define CIRCLE_DATA circles_konvertiert/circles1_1
//#define MST_BD

//#define DISBALE_BCASTWIFIDUPS

//#ifndef BCAST_ENABLE_ABORT_TX
#define BCAST_ENABLE_ABORT_TX 3
//#endif

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "routing/broadcastflooding.click"
#include "routing/routing.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

flooding::BROADCASTFLOODING(ID id, LT lt);
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

brn_clf[1]
  -> [1]flooding[1]
  -> SetTXRates(RATE0 2, TRIES0 DEFAULT_DATATRIES, TRIES1 0, TRIES2 0, TRIES3 0)
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
//  read lt.links,
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
