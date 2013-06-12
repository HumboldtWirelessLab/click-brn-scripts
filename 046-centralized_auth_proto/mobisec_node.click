//#define RAWDUMP
//#define RAWDEV_DEBUG
#define LINKSTAT_ENABLE
//#define DEBUG_DSR

#include "brn/helper.inc"
#include "brn/brn.click"

#include "device/rawwifidev.click"
#include "wifidev_client.click"
#include "wifidev_ap.click"
#include "routing/dsr.click"


/*
 * MobiSEC-Node
 *
 * The MobiSEC-Node has a special role in the backbone network. On the one
 * hand she acts as a network client in infrastructure mode. On the other
 * hand, when successfully authenticated by the key server she acts as a
 * network AP in ad-hoc mode.
 * She may loose the authenticated status and fall back to client
 * functionality.
 */


// Device info elements
BRNAddressInfo(deviceaddress eth0:eth);
wireless		:: BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");
rawdevice		:: RAWWIFIDEV(DEVNAME "eth0", DEVICE wireless);
id				:: BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

// Device and routing elements
lt				:: Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);
routingtable	:: BrnRoutingTable(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
routingalgo		:: Dijkstra(NODEIDENTITY id, LINKTABLE lt, MIN_LINK_METRIC_IN_ROUTE 6000, MAXGRAPHAGE 30000, DEBUG 2);
routingmaint	:: RoutingMaintenance(NODEIDENTITY id, LINKTABLE lt, ROUTETABLE routingtable, ROUTINGALGORITHM routingalgo, DEBUG 2);
wifidev_ap		:: WIFIDEV_AP(DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", CHANNEL 5, LT lt);
ap_outq			:: NotifierQueue(50);
dsr				:: DSR(id, lt, wifidev_ap/etx_metric,routingmaint); // Routing 

wifidev_client	:: WIFIDEV_CLIENT(DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", ACTIVESCAN false);
client_outq		:: NotifierQueue(50);

// Switch elements specific for MobiSEC node
switch_up		:: Switch();
switch_down 	:: PullSwitch();
switch_down2	:: Switch();
is_assoc_req 	:: Classifier(0/a0%f0 /* disassoc */, 0/00%f0 /* assoc */, -);


// Application elements
tls				:: TLS(ETHERADDRESS deviceaddress, KEYSERVER 00-00-00-00-00-01, ROLE "CLIENT", KEYDIR "CONFIGDIR/", DEBUG 2);
BackboneNode	:: BACKBONE_NODE(NODEID id, PROTOCOL_TYPE "CLIENT-DRIVEN", WEPENCAP wifidev_ap/wep/wep_encap, WEPDECAP wifidev_ap/wep/wep_decap, TLS tls, DEV_CLIENT wifidev_client/client/isc, AP_Q ap_outq, CLIENT_Q client_outq, START 10000, KEY_TIMEOUT 60000, DEVICE_CONTROL_UP switch_up, DEVICE_CONTROL_DOWN switch_down, DEVICE_CONTROL_DOWN2 switch_down2, DEBUG 5);






/*
 * ******* Layer 0: Integration of Raw Device **************
 * 
 * Here we create to identical input flows coming from rawdevice
 * and use a suppressor to control which flow we want to be 
 * the main flow.
 * We use the suppressor technique to be able to isolate either
 * the wifidev_client or wifidev_ap.
 */
rawdevice
	-> switch_up; // Flow 1 upwards: AP-Pkts 
	
switch_down
	-> rawdevice;
		
/*********************************************************/		
/*********************************************************/
/*********************************************************/
/*********************************************************/
/*********************************************************/
/*********************************************************/
		
		
/********* Layer 1: Integration of wifidev_client *********/
switch_up[0] // Flow 0 upwards: Client-Pkts 
	-> [1]wifidev_client[1]	
	-> is_assoc_req[2] // special case: when upgrading to mesh node we need an disassoc
	-> client_outq
	-> [0]switch_down; // Flow 0 downwards: Client-Pkts 
	
	
	// This is the wormhole of the layer architecture :(
	is_assoc_req[0]
		-> dupl :: Tee(2);	
		dupl[0]
			-> client_outq;
		dupl[1]
			-> ap_outq;
	is_assoc_req[1]
		-> dupl;


/********* Layer 1: Integration of wifidev_ap *********/
switch_up[1] // Flow 1 upwards: AP-Pkts 
	-> [2]wifidev_ap[6]
	-> ap_outq
	-> [1]switch_down; // Flow 1 downwards: AP-Pkts 

/*********************************************************/		
/*********************************************************/
/*********************************************************/
/*********************************************************/
/*********************************************************/
/*********************************************************/

/*
 * ******** Layer 2: Integration of Network-Layer (only for AP) *********
 * 
 * Use of routing service:
 * Input: 	to_routing :: Null()
 * Output: 	from_routing :: Null()
 */
to_routing :: Null()
	-> dsr;
	
wifidev_ap[0]
	-> BRN2EtherDecap()
	-> dsr_clf :: Classifier( 0/BRN_PORT_DSR /* BrnDSR */, - /* other */);
         
wifidev_ap[1] //broadcast and brn
	//-> Print("[MOBISEC_NODE NODENAME]: BRN-In", TIMESTAMP true)
	-> BRN2EtherDecap()
	-> dsr_clf;
	
	dsr_clf[0]
		//-> Print("[MOBISEC_NODE NODENAME]: DSR-Packet", TIMESTAMP true)
		-> [1]dsr;

	dsr_clf[1]
		//-> Print("[MOBISEC_NODE NODENAME]: No DSR-Packet (e.g. TLS-Packet from infra-struct-client)", TIMESTAMP true)
		-> BRN2Decap()
		-> from_routing :: Null();

wifidev_ap[2] 
	//-> Print("[MOBISEC_NODE NODENAME]: Foreign and brn", TIMESTAMP true)
	-> [0]dsr;  //foreign and brn

wifidev_ap[3] -> Discard;  //to me no brn
wifidev_ap[4] -> Discard;  //broadcast and no brn

wifidev_ap[5] //foreign and no brn
	-> [0]dsr;

dsr[0]
	//-> Print("[MOBISEC_NODE NODENAME]: DSR to this node????", TIMESTAMP true)
	-> toMeAfterDsr::BRN2ToThisNode(NODEIDENTITY id);
	
	toMeAfterDsr[0] 
		//-> Print("[MOBISEC_NODE NODENAME]: DSR-out: For ME",100, TIMESTAMP true)
		-> BRN2EtherDecap()
		-> BRN2Decap()
		-> from_routing;
	  
	toMeAfterDsr[1]
		//-> Print("[MOBISEC_NODE NODENAME]: DSR-out: Broadcast", TIMESTAMP true)
		-> Discard;

	toMeAfterDsr[2]
		//-> Print("[MOBISEC_NODE NODENAME]: DSR-out: Foreign/Client", TIMESTAMP true)
		-> [1]wifidev_ap;
  
dsr[1] 
	//-> Print("[MOBISEC_NODE NODENAME]: DSR[1]-out", TIMESTAMP true)
	-> SetEtherAddr(SRC deviceaddress)
	//-> Print("[MOBISEC_NODE NODENAME]: DSR-Ether-OUT",100, TIMESTAMP true)
	-> [0]wifidev_ap;


Idle -> [2]dsr;
Idle -> [3]dsr;

/*********************************************************/		
/*********************************************************/
/*********************************************************/
/*********************************************************/
/*********************************************************/
/*********************************************************/

/********* Layer 3: Integration of MobiSEC-Module *********
 *
 * Use of MobiSEC-Service
 * Input: 	to_MobiSEC_BackboneNode::Null()
 * Output: 	from_MobiSEC_BackboneNode::Null()
 */

to_MobiSEC_BackboneNode :: Null()
	-> tls
	-> BRN2Encap(BRN_PORT_FLOW, BRN_PORT_FLOW, 6, BRN_DEFAULT_TOS)
	-> BRN2EtherEncap(USEANNO true)
	-> from_MobiSEC_BackboneNode :: Null();

	// The main application sits on top of TLS 
	tls[1] // decrypt message
		-> BackboneNode
		-> [1]tls; //encrypt message

/***** Integration of MobiSEC (connection with wifidev_client) *******/
wifidev_client
	-> BRN2EtherDecap()
	-> BRN2Decap()
	-> to_MobiSEC_BackboneNode;
	
/***** Integration of MobiSEC (connection with wifidev_ap) *******/	
from_routing
	-> to_MobiSEC_BackboneNode;

/***** Integration of MobiSEC (connection with wifidev_client and routing) *******/
from_MobiSEC_BackboneNode
	-> switch_down2;
	
	switch_down2[0]
		-> wifidev_client;
	switch_down2[1]
		-> to_routing;


/*********************************************************/		
/*********************************************************/
/*********************************************************/
/*********************************************************/
/*********************************************************/
/*********************************************************/


Script(
	wait 500,
	read BackboneNode.stats,
	loop
);


// Debugging Route-Requests
Script(
	wait 10,
	//write dsr/src_forwarder.debug 4,
	//read wifidev_ap/ap/assoclist.stations,
	//read lt.links,	
);

/*
Script(
	wait 2461,
	read wifidev_ap/ap/assoclist.stations,
	read lt.links,	
	read wifidev_client/client/isc.wireless_info,
	read wifidev_client/client/isc.assoc,
);
*/

/*
// Debuggin of Routing
Script(
	wait 2350,
	print "NODENAME",
	read wifidev_ap/ap/assoclist.stations,
	read lt.links,
);
*/


/*
	wait 41,
	read wifidev_ap/ap/assoclist.stations,
	write dsr/src_forwarder.debug 4,
	write dsr/querier.debug 4,
	
	read lt.links,
	
	wait 15,
	//write wifidev_client/client/assoc_req.send_reassoc_req,
	read wifidev_client/client/isc.wireless_info,
	read wifidev_client/client/isc.assoc,
	//read wifidev_client/client/bs.scan,
	wait 25,
	read wifidev_ap/ap/assoclist.stations,
	write dsr/src_forwarder.debug 4,
	write dsr/querier.debug 4,
	
	read lt.links,
	
	wait 1,
	print "NODENAME",
	read wifidev_ap/ap/assoclist.stations,
	read lt.links,
	loop
	*/



