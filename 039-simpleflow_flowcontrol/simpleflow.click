#define DEBUGLEVEL 2

//#define WIFIDEV_LINKSTAT_DEBUG
#define ENABLE_DSR_DEBUG

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
  -> Print("BRN")
  -> BRN2EtherDecap()
  -> brn_clf::Classifier( 0/BRN_PORT_FLOW,        //Simpleflow
                          0/BRN_PORT_FLOWCONTROL, //Flowcontrol
                               -  );              //other

brn_clf[0]
-> BRN2Decap()
-> sf::BRN2SimpleFlow(DEBUG 4)
-> BRN2EtherEncap(USEANNO true)
-> Print("Simpleflow Out")
/*-> [0]device_wifi;
Idle*/
-> fcsrc::FlowControlSource(ETHERANNOS false, DEBUG 4)
-> BRN2EtherEncap(USEANNO true)
-> Print("Flowcontrol Out")
-> [0]device_wifi;

brn_clf[1]
-> BRN2Decap()
-> Print("Flowcontrol in")
-> flc_clf::Classifier( 0/00%ff,  //data
                        0/01%ff) //ack
                       
-> Print("Flowcontrol data_in")
-> fcsnk::FlowControlSink(DEBUG 4)
-> BRN2EtherEncap(USEANNO true)
-> Print("Flowcontrol data_out")
-> Label_brnether;

fcsnk[1]
-> Print("Flowcontrol ack_out")
-> BRN2EtherEncap(USEANNO true)
-> [0]device_wifi;


flc_clf[1]
-> Print("Flowcontrol ack_in")
-> [1]fcsrc;

brn_clf[2] -> Discard;

device_wifi[1] -> BRN2EtherDecap() -> brn_clf;
device_wifi[2] -> Discard;

Idle -> [1]device_wifi;
