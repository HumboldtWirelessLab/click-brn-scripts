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

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
  -> brn_clf::Classifier( 0/BRN_PORT_FLOW, //Simpleflow
                               -  );//other

brn_clf[0]
-> BRN2Decap()
-> sf::BRN2SimpleFlow(EXTRADATA "channel 4 mcs 1", DEBUG 2)
-> SetTimestamp() -> Print(TIMESTAMP true)
-> BRN2EtherEncap(USEANNO true)
-> data_rate::SetTXRate(RATE 36, TRIES 7)
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

Script(
  print "<rate>",
  read data_rate.rate,
  print "</rate>"
  write data_rate.rate 18,

  wait 1,
  print "New Rate:",
  read data_rate.rate
  
 )

Script(
  wait 2.5,
  read sf.stats,
  read device_wifi/wifidevice/hnd.stats,

  wait 1,
  read sf.stats,
  read device_wifi/wifidevice/hnd.stats,

  wait 1,
  read sf.stats,
  read device_wifi/wifidevice/hnd.stats,

  wait 1,
  read sf.stats,
  read device_wifi/wifidevice/hnd.stats,

  wait 1,
  read sf.stats,
  read device_wifi/wifidevice/hnd.stats,

  wait 1,
  read sf.stats,
  read device_wifi/wifidevice/hnd.stats

)

Script(
  wait 15.1,
  read sf.stats,
  read device_wifi/wifidevice/hnd.stats,
  read device_wifi/wifidevice/cst.stats
)

Script(
  wait 25.1,
  read sf.stats,
  read device_wifi/wifidevice/hnd.stats,
  read device_wifi/wifidevice/cst.stats
)

Script(
  wait 35.1,
  read sf.stats,
  read device_wifi/wifidevice/hnd.stats,
  read device_wifi/wifidevice/cst.stats
)

Script(
  wait 39
)