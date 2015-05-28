#define DEBUGLEVEL 2

//#define ROUTINGHAWK
//#define WIFIDEV_LINKSTAT_DEBUG
//#define ENABLE_DSR_DEBUG

//#define RAWDUMP

//#define SETCHANNEL

#define BRNFEEDBACK

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "dht/dht.click"
#include "routing/routing.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

dht::DHT(ETHERADDRESS deviceaddress, LINKSTAT device_wifi/link_stat, STARTTIME 30000, UPDATEINT 3000, DEBUG 2);
routing::ROUTING(ID id, ETHERADDRESS deviceaddress, LT lt, METRIC device_wifi/etx_metric, LINKSTAT device_wifi/link_stat/*, DHT dht*/);

dhtstoragetest :: DHTStorageTest( DHTSTORAGE dht/dhtstorage/dhtstorage, STARTTIME 0, INTERVAL 1000, COUNTKEYS 0, WRITE false, RETRIES 1, REPLICA 0, DEBUG 2);

#ifndef SIMULATION
sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);
#endif

device_wifi
-> Label_brnether::Null()
-> BRN2EtherDecap()
-> brn_clf::Classifier(    0/BRN_PORT_ROUTING,  //BrnDSR
                           0/BRN_PORT_DHTROUTING,  //DHT-Routing
                           0/BRN_PORT_DHTSTORAGE ); //DHT-Storage

device_wifi[1] -> Label_brnether;
device_wifi[2] -> Discard;
device_wifi[3] -> ff::FilterFailures() -> Discard;
ff[1] -> /*Print("TxFailed") ->*/ BRN2EtherDecap() -> Discard;


routing[0] -> [0]device_wifi;
routing[1] -> [1]device_wifi;
routing[2] -> Label_brnether;
routing[3] -> Discard;

brn_clf[0] -> [1]routing;
Idle -> [2]routing;
Idle -> [3]routing;
Idle -> [4]routing;

brn_clf[1] -> [0]dht;
brn_clf[2] -> [1]dht;

dht[0] -> [0]device_wifi;
dht[1] -> [0]routing;


Idle()
-> tcc::TCC()
-> discard::Discard;


Idle
-> rpc::RPC(TCC tcc, DHTSTORAGE dht/dhtstorage/dhtstorage, DEBUG 4)
-> Discard;

#if NODEID == 1

Script(
  wait 100,
  write tcc.add int incr int,
  write tcc.compile

               int incr(int i) {
                 return (i+1);
               }

            ,
  write tcc.call incr 5,
  read  tcc.result,
  write rpc.call incr 10,
  read  rpc.result,
  write tcc.code

               int click_tcc_init() {
                 printf("Hallo\n");
                 return 0;
               }

               int click_tcc_close() {
                 printf("good bye\n");
                 return 0;
               }

               void* click_tcc_simple_action(void *p) {
                 printf("Handle p. Size: %d\n"@tcc_packet_size(p));
                 return p;
               }

               ,
);
#endif

#if NODEID == 32

Script(
  wait 130,
  write rpc.call incr 7,
  wait 1,
  read  tcc.result,
);

#endif

#if NODEID == 64

Script(
  wait 135,
  write rpc.call incr 111,
  wait 1,
  read  tcc.result,
);

#endif