#define DEBUGLEVEL 2

#define USE_RTS_CTS
#define CERR
#define PRIO_QUEUE
//#define RAWDUMP
//#define WIFIDEV_LINKSTAT_DEBUG
#define ENABLE_DSR_DEBUG

#define BRNFEEDBACK

#define COOPCST_STRING "device_wifi/cocst"
#define COOPCST
#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
  -> brn_clf::Classifier( 0/BRN_PORT_FLOW, //Simpleflow
                               -  );//other

brn_clf[0]
-> BRN2Decap()
-> sf::BRN2SimpleFlow(EXTRADATA "channel 4 mcs 1", FLOWSTARTRANDOM 99, DEBUG 2)
//-> SetTimestamp() -> Print(TIMESTAMP true)
-> BRN2EtherEncap(USEANNO true)
-> SetTXRates(RATE0 2, TRIES0 7, TRIES1 0, TRIES2 0, TRIES3 0)
-> NotifierQueue(500)
-> [2]device_wifi;

brn_clf[1] -> Discard;

device_wifi[1] -> BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;

#ifdef BRNFEEDBACK
device_wifi[3]
  -> BRN2EtherDecap()
  -> Classifier( 0/BRN_PORT_FLOW )
  -> BRN2Decap()
  -> [1]sf;
#endif

Idle -> [1]device_wifi;
Idle -> [0]device_wifi;

