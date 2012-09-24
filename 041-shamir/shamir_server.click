#define LINKSTAT_ENABLE
//#define DEBUG_DSR

#include "brn/helper.inc"
#include "brn/brn.click"

#include "device/wifidev_ap.click"
#include "routing/dsr.click"
#include "routing/broadcast.click"

// Device info elements
BRNAddressInfo(deviceaddress eth0:eth);
wireless		:: BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");
id				:: BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

// Device and routing elements
lt				:: Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);
routingtable	:: BrnRoutingTable(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
routingalgo		:: Dijkstra(NODEIDENTITY id, LINKTABLE lt, ROUTETABLE routingtable, MIN_LINK_METRIC_IN_ROUTE 6000, MAXGRAPHAGE 30000, DEBUG 5);
routingmaint	:: RoutingMaintenance(NODEIDENTITY id, LINKTABLE lt, ROUTETABLE routingtable, ROUTINGALGORITHM routingalgo, DEBUG 2);
wifidev 		:: WIFIDEV_AP(DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", CHANNEL 5, LT lt);
dsr				:: DSR(id, lt, wifidev_ap/etx_metric,routingmaint); // Routing
bc              :: BROADCAST(ID id, LT lt);
tee             :: Tee()

server          :: ShamirServer();

/* Inbound flow:
 * Might be requests distributed via flooding or responses distibuted via DSR
 * Unicast. Requests must be processed by the application layer and trigger a
 * response. Of course they must also be passed on to other APs. Responses must
 * be passed on to the requesting client. */

wifidev
    -> Label_brnether :: Null()
	-> BRN2EtherDecap()
    -> clf :: Classifier( 0/BRN_PORT_FLOODING,
                          0/BRN_PORT_DSR,
                          0/BRN_PORT_SHAMIR, //Packets from clients directly associated  with this AP
                          - );

clf[0]
    -> [1]bc;
    -> server; // Local copy

clf[1]
    -> [1]dsr;

clf[2]
    -> tee;

clf[3]
    -> Discard;

tee[0] //Packets from clients directly associated  with this AP
    -> server;

    


/* Outbound flow:
 * Forward requests and send responses to the client */

server[0]
	-> BRN2EtherEncap(USEANNO true)
	-> [1]device_wifi; // forwarding to ap-clients, some improvements later needed here: guessing if pkt is for ap-clients

bc[1]
    -> BRN2EtherEncap()
    -> [1]device_wifi;

tee[1]
    -> bc; //FIXME: Does this create duplicate packets because of lines 69 and 55?

dsr[1] //BRN DSR packets to internal nodes
    -> BRN2EtherEncap()
    -> [1]device_wifi;

dsr[0] //Ethernet frames to external nodes/clients
    -> BRN2EtherEncap()
    -> [1]device_wifi;
