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

AddressInfo(deviceaddress NODEDEVICE:eth);
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
-> brn_clf::Classifier(    0/BRN_PORT_ROUTING,     //BrnDSR
                           0/BRN_PORT_DHTROUTING,  //DHT-Routing
                           0/BRN_PORT_DHTSTORAGE,  //DHT-Storage
                           0/BRN_PORT_RPC);       //RPC

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

tcc::TCC(DEBUG 2)

brn_clf[3]
-> Print("RPC", TIMESTAMP true)
-> BRN2Decap()
-> rpc::RPC(NODEIDENTITY id, TCC tcc, DHTSTORAGE dht/dhtstorage/dhtstorage, DEBUG 4)
-> BRN2EtherEncap(USEANNO true, PUSHHEADER true, DEBUG 4)
-> BRN2EtherEncap(SRC deviceaddress, PUSHHEADER false)
-> Print("RPC out", 100, TIMESTAMP true)
-> SetTimestamp()
-> [0]routing;

#if NODENUM == 1

Script(
  wait 100,
  write tcc.add int incr int int,
  write tcc.compile

               int incr(int i@ int j) {
                 return (i+j);
               }

            ,
  write tcc.call incr 5 5,
  read  tcc.result,
  write rpc.call incr 10 5,
  wait  1,
  read  rpc.result,
  read  ff.drops,
  write rpc.call incr 00-00-00-00-00-0F:ff.drops 3,
  wait  1,
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

#if NODENUM == 8

Script(
  wait 110,
  write rpc.call incr 3 4,
  wait 1,
  read  rpc.result,

  wait  1,
  write rpc.call incr ff.drops 4,
  read  rpc.result,

  wait  3,
  write rpc.call incr 00-00-00-00-00-01:rpc.result 4,
  wait  1,
  read  rpc.result
);

#endif

#if NODENUM == 16

Script(
  wait 120,
  write rpc.call incr 00-00-00-00-00-08:rpc.result 00-00-00-00-00-01:rpc.result,
  wait 1,
  read  rpc.result
);

Script(
  wait 125,
  write rpc.remote_call 00-00-00-00-00-01 incr 00-00-00-00-00-08:rpc.result 00-00-00-00-00-01:rpc.result,
  wait 1,
  read  rpc.result
);
Script(
  wait 130,
  write rpc.remote_call 00-00-00-00-00-01 incr 00-00-00-00-00-08:rpc.result 00-00-00-00-00-01:rpc.result,
  wait 1,
  read  rpc.result
);

#endif

Script(
  wait 135,
  read rpc.stats
);
