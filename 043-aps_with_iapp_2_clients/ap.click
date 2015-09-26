#define DEBUGLEVEL 2
#define LINKSTAT_ENABLE

#include "brn/brn.click"
#include "device/wifidev_ap.click"
#include "routing/dsr.click"
#include "wifi/iapp.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME "NODENAME", DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);
routingtable::BrnRoutingTable(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
routingalgo::Dijkstra(NODEIDENTITY id, LINKTABLE lt, MIN_LINK_METRIC_IN_ROUTE 6000, MAXGRAPHAGE 30000, DEBUG 2);
routingmaint::RoutingMaintenance(NODEIDENTITY id, LINKTABLE lt, ROUTETABLE routingtable, ROUTINGALGORITHM routingalgo, DEBUG 2);

device_wifi::WIFIDEV_AP(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", CHANNEL 5, LT lt);

dsr::DSR(id, lt, device_wifi/etx_metric,routingmaint);

/* Parameter:
 * ==========
 * - ID                := node $identity
 * - LINKTABLE         := link table
 * - ASSOCLIST         := list of associated stations
 
 * =====================
 *  - input[0]        <- 802.11 frames from the queue to the interface ( q -> )
 *  - output[0]       -> 802.11 frames to the interface ( -> ToDevice)
 *
 *  - input[1]        <- BRN_IAPP packets (destinating, without further header)
 *                       (brn_clf[6] -> Strip(6) -> )
 *  - input[2]        <- BRN_IAPP packets (peeked, without further header)
 *  - input[3]        <- 802.3 frames which could not be forwarded 
 *                         (dsr[2] -> Strip(182) -> ) failure from dsr 
 *                         (FilterFailures[1] -> WifiDecap -> ) from dev no ack
 *  - input[4]        <- 802.11 infrastructure data with foreign BSSID
                            (filter_bssid[1] -> )
 *  - output[1]       -> 802.3 frames to be routed ( -> [0]dsr)
 *  - output[2]       -> ????
 *
 *  - output[3]       -> BRN_IAPP notify packets with further information
                         for other elements (Gateway needs to know about hand overs)
 */

iapp::IAPP(STALE 1000, ASSOCLIST device_wifi/ap/assoclist, ASSOC_RESP device_wifi/ap/assoc_resp, NODEIDENTITY id, LINKTABLE lt)


Idle()
-> [0]iapp;

Idle()
-> [1]iapp;

Idle()
-> [2]iapp;

Idle()
-> [3]iapp;

Idle()
-> [4]iapp;

iapp[0]
-> Print("IAPP[0]")
-> Discard;

iapp[1]
-> Print("IAPP[1]")
-> Discard;

iapp[2]
-> Print("IAPP[2]")
-> Discard;

iapp[3]
-> Print("IAPP[3]")
-> Discard;

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
//-> Print("Foo",100)
  -> brn_clf::Classifier(    0/BRN_PORT_DSR,  //BrnDSR
                               -  );//other

device_wifi[1]       //broadcast and brn
//-> Print("BRN-In")
  -> BRN2EtherDecap()
  -> brn_clf;

device_wifi[2] /*-> Print("NODENAME: For and brn", TIMESTAMP true)*/ -> [0]dsr;  //foreign and brn

device_wifi[3] -> Discard;  //to me no brn
device_wifi[4] -> Discard;  //broadcast and no brn

device_wifi[5] //foreign and no brn
 -> [0]dsr;

brn_clf[0]
  //-> Print("DSR-Packet")
  -> [1]dsr;

dsr[0]
  -> toMeAfterDsr::BRN2ToThisNode(NODEIDENTITY id);

dsr[1]
  //-> Print("DSR[1]-out")
  -> BRN2EtherEncap(SRC deviceaddress, PUSHHEADER false)
  //-> Print("DSR-Ether-OUT")
  -> [0]device_wifi;

toMeAfterDsr[0] 
  //-> Print("DSR-out: For ME",100)
  -> Label_brnether; 
  
toMeAfterDsr[1]
  //-> Print("DSR-out: Broadcast")
  -> Discard;

toMeAfterDsr[2]
  //-> Print("DSR-out: Foreign/Client")
  -> [1]device_wifi;

Idle -> [2]dsr;
brn_clf[1] -> Discard;

Idle -> [3]dsr;
Idle -> [4]dsr;

Script(
  wait 10,
  read device_wifi/ap/assoclist.stations,
  read lt.links
);

//#define ENABLE_DSR_DEBUG
Script(
#ifdef ENABLE_DSR_DEBUG
  write dsr/querier.debug 4,
  write dsr/req_forwarder.debug 4,
  write dsr/rep_forwarder.debug 4,
  write dsr/err_forwarder.debug 4
#endif
);
	
