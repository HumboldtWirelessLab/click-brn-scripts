//#define RAWDUMP
//#define RAWDEV_DEBUG
#define LINKSTAT_ENABLE
#define DEBUG_DSR

#include "brn/helper.inc"
#include "brn/brn.click"

#include "device/rawwifidev.click"
#include "wifidev_ap.click"
#include "routing/dsr.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless		:: BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");
id				:: BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);
rawdevice		:: RAWWIFIDEV(DEVNAME "eth0", DEVICE wireless);

lt				:: Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);
routingtable	:: BrnRoutingTable(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
routingalgo		:: Dijkstra(NODEIDENTITY id, LINKTABLE lt, ROUTETABLE routingtable, MIN_LINK_METRIC_IN_ROUTE 6000, MAXGRAPHAGE 30000, DEBUG 2);
routingmaint	:: RoutingMaintenance(NODEIDENTITY id, LINKTABLE lt, ROUTETABLE routingtable, ROUTINGALGORITHM routingalgo, DEBUG 2);
wifidev_ap		:: WIFIDEV_AP(DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", CHANNEL 5, LT lt);
dsr				:: DSR(id, lt, wifidev_ap/etx_metric,routingmaint); // Routing 

tls				:: TLS(ETHERADDRESS deviceaddress, KEYSERVER 00-00-00-00-00-01, ROLE "SERVER", KEYDIR "/home/aureliano/Uni/METRIK/repository2/click-brn-scripts/039-centralized_auth_proto/", DEBUG 5);
KeyServer		:: KEYSERVER(PROTOCOL_TYPE "CLIENT-DRIVEN", WEPENCAP wifidev_ap/wep/wep_encap, WEPDECAP wifidev_ap/wep/wep_decap, KEY_LIST_CARDINALITY 10, KEY_TIMEOUT 60000, START 10000 /* too fast ?? */, DEBUG 5);




/*
 * ******* Layer 0: Integration of Raw Device **************
 */
rawdevice
	-> [2]wifidev_ap[6]
	-> rawdevice;



/*
 * ******** Layer 2: Integration of Network-Layer (only for AP) *********
 *
 * Input 0: 	To device, thus to network
 * Output 0: 	From device to me
 */
to_routing :: Null()
	-> dsr;
	
wifidev_ap
	-> BRN2EtherDecap()
	-> dsr_clf :: Classifier( 0/BRN_PORT_DSR /* BrnDSR */, - /* other */);
         
wifidev_ap[1] //broadcast and brn
	//-> Print("[MOBISEC_SRV] BRN-In")
	-> BRN2EtherDecap()
	-> dsr_clf;
	
	dsr_clf[0]
		-> Print("[MOBISEC_SRV] DSR-Packet",1000)
		-> [1]dsr;

	dsr_clf[1]
		//-> Print("[MOBISEC_SRV] No DSR-Packet")
		-> BRN2Decap()
		-> from_routing :: Null();

wifidev_ap[2] 
	//-> Print("[MOBISEC_SRV] NODENAME: For and brn", TIMESTAMP true)
	-> [0]dsr;  //foreign and brn

wifidev_ap[3] -> Discard;  //to me no brn
wifidev_ap[4] -> Discard;  //broadcast and no brn

wifidev_ap[5] //foreign and no brn
	-> [0]dsr;

dsr[0]
	-> Print("[MOBISEC_SRV] DSR to this node????")
	-> toMeAfterDsr::BRN2ToThisNode(NODEIDENTITY id);
	
	toMeAfterDsr[0] 
		-> Print("[MOBISEC_SRV] DSR-out: For ME",100)
		-> BRN2EtherDecap()
		-> BRN2Decap()
		-> from_routing;
	  
	toMeAfterDsr[1]
		-> Print("[MOBISEC_SRV] DSR-out: Broadcast")
		-> Discard;

	toMeAfterDsr[2]
		-> Print("[MOBISEC_SRV] DSR-out: Foreign/Client")
		-> [1]wifidev_ap;
  
dsr[1] 
	-> Print("[MOBISEC_SRV] DSR[1]-out")
	-> SetEtherAddr(SRC deviceaddress)
	-> Print("[MOBISEC_SRV] DSR-Ether-OUT")
	-> [0]wifidev_ap;
	

Idle -> [2]dsr;
Idle -> [3]dsr;




/********* Layer 3: Integration of MobiSEC-Module *********
 *
 * Input 0: 	To MobiSEC
 * Output 0: 	From MobiSEC
 */

to_MobiSEC_KeyServer :: Null()
	-> tls
	-> Print("[MOBISEC_SRV NODENAME] TLS-Mesg from KeyServer", 100)
	-> BRN2Encap(BRN_PORT_FLOW, BRN_PORT_FLOW, 6, BRN_DEFAULT_TOS)
	-> BRN2EtherEncap()
	-> from_MobiSEC_KeyServer :: Null();

	tls[1] // decrypt message
		-> KeyServer
		-> Print("[MOBISEC_SRV NODENAME] KDP-Mesg from KeyServer", 100)
		-> [1]tls; //encrypt message


/***** connection to wifidev_ap *******/	
from_routing
	-> to_MobiSEC_KeyServer;
	
from_MobiSEC_KeyServer
	-> to_routing;






Script(
	wait 41,
	read lt.links,
/*
	wait 40,
	write dsr/src_forwarder.debug 4,
	write dsr/querier.debug 4,
	read wifidev_ap/ap/assoclist.stations,
	read lt.links,
	
	read lt.links,
	wait 10,
	
	*/
);

