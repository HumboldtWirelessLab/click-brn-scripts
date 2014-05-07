#define DEBUGLEVEL 2

#define PRIO_QUEUE
//#define RAWDUMP
//#define WIFIDEV_LINKSTAT_DEBUG
//#define ENABLE_DSR_DEBUG

#define BRNFEEDBACK

#define CST cst

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

coopcst::CooperativeChannelStats(CHANNELSTATS device_wifi/wifidevice/cst, INTERVAL 1000, NEIGHBOURS true, DEBUG 2);

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
  -> brn_clf::Classifier( 0/BRN_PORT_FLOW,              //Simpleflow
                          0/BRN_PORT_CHANNELSTATSINFO,  //ChannelStats
                               -  );                    //other

brn_clf[0]
-> BRN2Decap()
-> sf::BRN2SimpleFlow(EXTRADATA "channel 4 mcs 1", DEBUG 2)
-> SetTimestamp()
-> BRN2EtherEncap(USEANNO true)
-> SetTXRate(RATE 2, TRIES 1)
-> sf_queue::NotifierQueue(500);

brn_clf[1]
-> BRN2Decap()
-> coopcst
-> EtherEncap(BRN_ETHERTYPE_HEX, deviceaddress, BRN_MAC_BROADCAST)
//-> Print()
-> SetTXRate(RATE 2, TRIES 1)
-> NotifierQueue(10)
-> priosched::PrioSched()
-> [2]device_wifi;

sf_queue
-> [1]priosched;

brn_clf[2] -> Discard;

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

Script(
  write sf.add_flow deviceaddress ff:ff:ff:ff:ff:ff 100 50 0 10000 true 2 1000,
);

Script(
  wait 2,
  read device_wifi/wifidevice/cst.stats,
  read coopcst.stats,
  loop
  );
