#define DEBUGLEVEL 2

#define PRIO_QUEUE
#define RAWDUMP
//#define WIFIDEV_LINKSTAT_DEBUG
#define ENABLE_DSR_DEBUG

#define BRNFEEDBACK

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"

#define LINKPROBE_PERIOD   1000
#define LINKPROBE_TAU      50000

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

topo_info::TopologyInfo(DEBUG 4);

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
  -> brn_clf::Classifier( 0/BRN_PORT_TOPOLOGY_DETECTION,  //DETECT
                                                    -  ); //other

brn_clf[0]
-> BRN2Decap()
-> topo_detect::TopologyDetection(TOPOLOGYINFO topo_info, NODEIDENTITY id, LINKTABLE lt, DEBUG 5, ORIGINDELAY true)
-> SetTimestamp()
-> Print(TIMESTAMP true)
-> BRN2EtherEncap(USEANNO true)
-> SetTXRate(RATE 2, TRIES 7)
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
  wait 260,
  read topo_detect.local_topo_info,
  read lt.links,
);
