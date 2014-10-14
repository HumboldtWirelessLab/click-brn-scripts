#define DEBUGLEVEL 2

#define PRIO_QUEUE
#define RAWDUMP
#define ENABLE_DSR_DEBUG

#define BRNFEEDBACK

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"
#define CERR

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

topo_info::TopologyInfo(DEBUG 4);

//rs::RandomSeed(12);

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
  -> brn_clf::Classifier( 0/BRN_PORT_TOPOLOGY_DETECTION,  //DETECT
                                                    -  ); //other

brn_clf[0]
-> BRN2Decap()
-> topo_detect::TopologyDetection(TOPOLOGY_INFO topo_info, NODE_IDENTITY id, LINK_TABLE lt, DEBUG 0, IS_DETECTION_PERIODICALLY false, RANDOM_START_DELAY_MS 20000, DETECTION_INTERVAL_MS 30000, USE_LINK_STAT true)
-> SetTimestamp()
-> Print(TIMESTAMP true)
-> BRN2EtherEncap(USEANNO true)
-> SetTXRate(RATE 2, TRIES 7)
-> SetRTS(true)
-> NotifierQueue(500)
-> [2]device_wifi;

brn_clf[1] -> Discard;

device_wifi[1] -> BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;

#ifdef BRNFEEDBACK
device_wifi[3]
  -> Discard;
#endif

Idle -> [1]device_wifi;
Idle -> [0]device_wifi;

Script(
  write device_wifi/link_stat.probes "",
  read topo_detect.config,
  
  write topo_detect.config DEBUG 6, // to get XML start elements
  write topo_detect.config PRINT_INFO_PERIODICALLY true,  // print topo info periodically


  wait 60030, // ... for testing
  write topo_detect.stop_periotically_detection_smoothly,  // timer for triggering periodically searches will not be refreshed
  write topo_detect.config PRINT_INFO_PERIODICALLY false,

  wait 30,  // wait for last search executions
  read topo_detect.link_stat,  // get all links nice formated at once
);
