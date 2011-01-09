#define DEBUGLEVEL 2

#define PRIO_QUEUE
#define CST cst

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

rc::Brn2RouteCache(ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 15000);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

as::AlarmingState(LINKTABLE lt, HOPLIMIT 10, LOWHOPFWD false, RETRIES 4, MINNEIGHBOURFRACT 70);
af::AlarmingForwarder(NODEID id, ALARMINGSTATE as, RSSI_DELAY true, DEBUG 2);
asrc::AlarmingSource(ALARMINGSTATE as);
art::AlarmingRetransmit(NODEID id, ALARMINGSTATE as);

asrc
//  -> Print("ALARM")
  -> af;
  
device_wifi
  -> Discard;
  
device_wifi[1]
//  -> Print("In")
  -> BRN2EtherDecap()
  -> BRN2Decap()
  -> [1]af;

device_wifi[2]
  -> Discard;
  
af
//  -> Print("Out")
  -> rdq::RandomDelayQueue(MINDELAY 3, MAXDELAY 100, DIFFDELAY 10, TIMESTAMPANNOS true)
  -> nq::NotifierQueue(50)
  -> AlarmingAggregation(ALARMINGSTATE as, DELAYQUEUE rdq, ALARMINGRETRANSMIT art)
  -> Print ("Out",TIMESTAMP true)
  -> BRN2EtherEncap(USEANNO true)
  -> c_out::Counter()
  -> [2]device_wifi;

art
-> nq;

Idle
  -> [0]device_wifi;

Idle
  -> [1]device_wifi;

Script(
 wait 100,
 write asrc.state 0,
 wait 1,
 read c_out.byte_count,
 read c_out.count,
 read as.state,
);
 
