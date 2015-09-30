#define DEBUGLEVEL 2

#include "flooding_config.h"

#define BCAST2UNIC_PDRCONFIG "101 5 115"
//#define BCAST2UNIC_PDRCONFIG "112 0 112"
//#define BCAST2UNIC_PDRCONFIG "102 0 102"

#define FOREIGNRXSTATS

#define FLOODING_DEBUG 2
//#define WIFIDEV_LINKSTAT_DEBUG
//#define RAWDUMP

#define PDR_LINKTABLE pdr_lt

#define BRNFEEDBACK

#define CST cst
#define CERR
#define COOPCST
#define COOPCST_STRING "device_wifi/cocst"

#define PRIO_QUEUE
#define LINKPROBE_PERIOD                                           2000
#define LINKPROBE_TAU                                            100000
#define LINKPROBE_PROBES                   "2 200 24 2 200 23 11 200 24 11 200 23"
//#define LINKPROBE_PROBES                   "2 1000 24 2 200 23 11 200 24 11 200 23"
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

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

//ett_lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);
//ett_metric :: BRNETTMetric(ett_lt);

pdr_lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);
pdr_metric :: BRNPDRMetric(pdr_lt);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

flooding::BROADCASTFLOODING(ID id, LT lt, LINKSTAT device_wifi/link_stat);

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

rtscts_packetsize::RtsCtsPacketSize(PACKETSIZE 32, PACKETDURATION -1);
rtscts_hiddennode::RtsCtsHiddenNode(HIDDENNODE device_wifi/wifidevice/hnd);
rtscts_flooding::RtsCtsFlooding(FLOODING flooding/fl, FLOODINGHELPER flooding/fl_helper, FLOODINGDB flooding/fl_database, HIDDENNODE device_wifi/wifidevice/hnd, DEBUG 2);

rate_fix::BrnFixRate(RATE0 2, TRIES0 DEFAULT_DATATRIES, TRIES1 0, TRIES2 0, TRIES3 0);
rate_flooding::BrnFloodingRate(FLOODING flooding/fl, FLOODINGHELPER flooding/fl_helper, FLOODINGDB flooding/fl_database, LINKSTAT device_wifi/link_stat, CHANNELSTATS device_wifi/wifidevice/cst, STRATEGY RS_STRATEGY, DEFAULTRETRIES 7, DEBUG 2);

rates::BrnAvailableRates(DEFAULT 2 4 11 12 18 22 24 36 48 72 96 108);

brn_clf[1]
  -> [1]flooding[1]
  -> data_rate::SetTXPowerRate(RATESELECTIONS "rate_fix rate_flooding", STRATEGY 5, RT rates, POWER 24, OFFSET -1)
  -> setrtscts::Brn2_SetRTSCTS(RTSCTS_SCHEMES "rtscts_hiddennode rtscts_flooding rtscts_packetsize", STRATEGY RTSCTS_STRATEGY, MIXEDSTRATEGY RTSCTS_MIXEDSTRATEGY, HEADER 2, DEBUG 2)
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

#ifdef MPR_STATS
Script(
  wait 184,
  write flooding/flp.mpr_algo,
  read flooding/flp.flooding_info
);
#endif

Script(
  write device_wifi/link_stat.add_metric pdr_metric
);

Script(
  wait 100,
  read lt.links,
//read ett_lt.links,
  read pdr_lt.links,
  read device_wifi/link_stat.bcast_stats
);

/*Script(
  wait 120,
  read flooding/fl_linktable.links
 );
*/

#include "flooding_script.click"
