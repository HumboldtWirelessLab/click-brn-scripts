#define DEBUGLEVEL 2

//#define WIFIDEV_LINKSTAT_DEBUG

//#define PRO_FL
#define BCAST2UNIC
#define DISABLE_WIFIDUBFILTER
#define RAWDUMP

#define SETCHANNEL

#define CST cst
#ifdef USERLEVEL 
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"
#endif

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "routing/broadcastflooding.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE true, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITY id, ROUTECACHE rc, STALE 500, MIN_LINK_METRIC_IN_ROUTE 9998);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

flooding::BROADCASTFLOODING(ID id, LT lt);

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
  -> brn_clf::Classifier(    0/BRN_PORT_FLOW,         //Simpleflow
                             0/BRN_PORT_FLOODING,     //Flooding
                             0/BRN_PORT_EVENTHANDLER, //Event
                               -  );                  //other

device_wifi[1] -> /*Print("BRN-In") -> */ BRN2EtherDecap() -> brn_clf;

Idle -> [1]device_wifi;

brn_clf[0]
//-> Print("rx")
  -> BRN2Decap()
  -> sf::BRN2SimpleFlow(HEADROOM 192, DEBUG 4)
  -> BRN2EtherEncap(USEANNO true)
  -> [0]flooding;

brn_clf[3] -> Discard;

brn_clf[1]
  -> [1]flooding[1]
//-> Print("Flood out")
//-> rdq::RandomDelayQueue(MINDELAY 2, MAXDELAY 10, DIFFDELAY 10)
  -> [0]device_wifi;

flooding[0]
  -> Label_brnether;

Idle()        //no push event
  -> event_notifier::EventNotifier(ETHERADDRESS deviceaddress, EVENTHANDLERADDR ff:ff:ff:ff:ff:ff, DEBUG 2)
  -> Discard; //no pull event

brn_clf[2]
  -> BRN2Decap()
  -> eh::EventHandler(DEBUG 2);

event_notifier[1]
  -> BRN2EtherEncap(USEANNO true)
//-> Print("To Flood")
  -> event_cpy::Tee()
  -> [0]flooding;

event_cpy[1] -> Label_brnether;

Idle -> [2]flooding; //route error

/*********************/
/* PASSIV (Overhear) */
/*********************/

device_wifi[2]
//-> Print("BRN-Overhear")
  -> BRN2EtherDecap()
  -> overhear_brn_clf::Classifier( 0/BRN_PORT_FLOODING,  //SimpleFlooding
                                              -       ); //other

overhear_brn_clf[0]
    -> [3]flooding; //passive

overhear_brn_clf[1]
    -> Discard;
