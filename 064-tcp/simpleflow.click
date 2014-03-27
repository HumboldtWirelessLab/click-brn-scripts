#define DEBUGLEVEL 2

#define USE_RTS_CTS
#define CERR
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

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

tcpin::TCPSpeaker();

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
  -> IPPrint()
  -> [1]tcpin[1]
  -> brn_clf::Classifier( 0/BRN_PORT_FLOW, //Simpleflow
                               -  );//other

brn_clf[0]
-> BRN2Decap()
-> sf::BRN2SimpleFlow(EXTRADATA "channel 4 mcs 1", FLOWSTARTRANDOM 99, DEBUG 2)
//-> SetTimestamp() -> Print(TIMESTAMP true)
-> UDPIPEncap(192.168.0.1, 10000, 192.168.0.2, 20000)
-> IPPrint()
-> tcpout::TCPSpeaker(VERBOSITY 0xFFFFFF)
//-> NotifierQueue(500)
-> IPPrint()
-> BRN2EtherEncap(USEANNO true)
-> SetTXRates(RATE0 2, TRIES0 7, TRIES1 0, TRIES2 0, TRIES3 0)
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


Idle -> [0]tcpin[0] -> Discard;
Idle -> [1]tcpout[1] -> Discard;
