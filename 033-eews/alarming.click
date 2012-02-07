#define DEBUGLEVEL 2

#define PRIO_QUEUE
#define CST cst

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_linkstat.click"
#include "routing/broadcast.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

rc::Brn2RouteCache(ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITY id, ROUTECACHE rc, STALE 500, MIN_LINK_METRIC_IN_ROUTE 9998);

device_wifi::WIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

loc::GPS();

as::EewsState(GPS loc, LINKTABLE lt,NHOPNEIGHBOURINFO nhopinfo, HOPLIMIT 3, LOWHOPFWD false, RETRIES 4, MINNEIGHBOURFRACT 70, MINFRACT 70, DEBUG 2);
af::EewsForwarder(NODEID id, EEWSSTATE as, RSSI_DELAY true, DEBUG 2);
asrc::EewsSource(EEWSSTATE as);
art::EewsRetransmit(NODEID id, EEWSSTATE as, DEBUG 2);

nhopinfo::NHopNeighbouringInfoEews(EEWSSTATE as, HOPLIMIT 3);


bc::BROADCAST(ID id, LT lt);



asrc
  //-> Print("ALARM")
  -> af;

device_wifi[0]
  -> brn_ether_decap::BRN2EtherDecap()
  -> brn_clf::Classifier( 0/BRN_PORT_FLOODING,          //SimpleFlooding
                          0/BRN_PORT_NHOPNEIGHBOURING,  //NHopNeighbouringBRN_PORT_ALARMING
                          0/BRN_PORT_ALARMINGPROTOCOL,  //Alarming
                            -  );//other

device_wifi[1]
  -> brn_ether_decap;

af
  //-> Print("Out")
  -> rdq::RandomDelayQueue(MINDELAY 3, MAXDELAY 100, DIFFDELAY 10, TIMESTAMPANNOS true)
  -> nq::NotifierQueue(50)
  -> EewsAggregation(EEWSSTATE as, DELAYQUEUE rdq, EEWSRETRANSMIT art)
  //-> Print ("Out",TIMESTAMP true)
  -> BRN2EtherEncap(USEANNO true)
  -> c_out::Counter()
  -> SetTXRate(RATE 2, TRIES 1)
  -> [2]device_wifi;

art
-> nq;

nhop_ping::NHopNeighbouringPingEews(EEWSSTATE as, NODEIDENTITY id, NHOPN_INFO nhopinfo, INTERVAL 15000, ACTIVE true, DEBUG 4)
  -> BRN2EtherEncap(USEANNO true)
  //-> Print("Raus damit")
  -> [0]bc;

brn_clf[0]
  //-> Print("SimpleFlood-Ether-IN")
  -> [1]bc;

brn_clf[1]
  //-> Print("rx")
  -> BRN2Decap()
  //-> Print("rx_nhop")
  -> nhop_sink::NHopNeighbouringSinkEews(NHOPN_INFO nhopinfo, DEBUG 4);

brn_clf[2]
  -> BRN2Decap()
  -> [1]af;


brn_clf[3]
  -> Discard;

bc[0]
  //-> Print("Receive To This Node")
  -> toMeAfterRouting::BRN2ToThisNode(NODEIDENTITY id);

bc[1]
  //-> Print("Broadcast out")
  -> [0]device_wifi;

Idle
-> [2]bc;

toMeAfterRouting[0]
  //-> Print("Routing-out: For ME")
  -> brn_ether_decap;

toMeAfterRouting[1]
  //-> Print("Routing-out: Broadcast")
  -> brn_ether_decap;

toMeAfterRouting[2]
  -> [1]device_wifi;

/* PASSIV (Overhear) */

device_wifi[2]
  //-> Print("BRN-In2")
  -> BRN2EtherDecap()
  -> overhear_brn_clf::Classifier( 0/BRN_PORT_FLOODING,  //SimpleFlooding
                                  -  );//other

overhear_brn_clf[0]
  -> [3]bc;

overhear_brn_clf[1]
  -> Discard;

Script(
 write loc.cart_coord NODEPOSITIONX NODEPOSITIONY NODEPOSITIONZ,
 read loc.cart_coord,
 wait 99,
 read nhopinfo.state,
 wait 1,
 write asrc.state 2,
 wait 1,
 read c_out.byte_count,
 read c_out.count,
 read as.state,
 read loc.cart_coord
);

/*
 read c_out.byte_count,
 read loc.cart_coord,
 read c_out.byte_count,
 wait 1,
 read c_out.byte_count,
 write loc.cart_coord "221 222 223",
 read c_out.byte_count,
 read loc.cart_coord,

*/
