#define DEBUGLEVEL 2

#define PRIO_QUEUE
#define RAWDUMP
#define ENABLE_DSR_DEBUG

#define BRNFEEDBACK

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"
#define CERR

#define DEFAULT_DATARATE    12
#define DEFAULT_DATARETRIES 1

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 3600000);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
  -> brn_clf::Classifier( 0/BRN_PORT_FLOW, //Simpleflow
                               -  );//other

brn_clf[0]
-> BRN2Decap()
//-> Print("in", TIMESTAMP true)
-> sf::BRN2SimpleFlow(EXTRADATA "")
//-> Print("out", TIMESTAMP true)
-> BRN2EtherEncap(USEANNO true)
-> mcs::SetTXRate(RATE DEFAULT_DATARATE, TRIES DEFAULT_DATARETRIES)
//-> NotifierQueue(50)
-> [0]device_wifi;

Idle -> [2]device_wifi;

/* alternativ: achtung: packete haben so hoehere prioritaet als Linkprobes -> linkstats funktionieren so evtl nicht (bei kleinen paketintervallen)

-> NotifierQueue(50)
-> [2]device_wifi;
Idle -> [0]device_wifi;
*/


Idle -> [1]device_wifi;

brn_clf[1] -> Discard;

device_wifi[1] -> BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;

#ifdef BRNFEEDBACK
device_wifi[3]
  -> BRN2EtherDecap()
  -> Classifier( 0/BRN_PORT_FLOW )
  -> BRN2Decap()
//  -> Print("txf", TIMESTAMP true)
  -> [1]sf;
#endif


// for stats: enabele read hnd... in "Script"
Idle
//-> hnd::HiddenNodeDetection(DEVICE wireless, TIMEOUT 1000, LINKTIMEOUT 2000, LINKTABLE lt, DEBUG 2)
-> Discard;

Script(
  wait 2,
//  read device_wifi/wifidevice/cst.stats,
//  write device_wifi/link_stat.probes "",
  wait 9,
  read sf.stats,
  wait 1,
  read lt.links,
);