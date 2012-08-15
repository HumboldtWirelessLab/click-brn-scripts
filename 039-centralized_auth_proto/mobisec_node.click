//#define RAWDUMP
//#define RAWDEV_DEBUG
#define LINKSTAT_ENABLE
#define DEBUG_DSR

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


BRNAddressInfo(deviceaddress eth0:eth);
wireless		:: BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");
rawdevice		:: RAWWIFIDEV(DEVNAME "eth0", DEVICE wireless);
id				:: BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt				:: Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);
routingtable	:: BrnRoutingTable(DEBUG 0, ACTIVE false, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
routingalgo		:: Dijkstra(NODEIDENTITY id, LINKTABLE lt, ROUTETABLE routingtable, MIN_LINK_METRIC_IN_ROUTE 6000, MAXGRAPHAGE 30000, DEBUG 2);
routingmaint	:: RoutingMaintenance(NODEIDENTITY id, LINKTABLE lt, ROUTETABLE routingtable, ROUTINGALGORITHM routingalgo, DEBUG 2);
wifidev_ap		:: WIFIDEV_AP(DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", CHANNEL 5, LT lt);
dsr				:: DSR(id, lt, wifidev_ap/etx_metric,routingmaint); // Routing 

wifidev_client	:: WIFIDEV_CLIENT(DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", ACTIVESCAN false);

switch_up		:: Switch();
switch_down 	:: PullSwitch();
switch_down2	:: Switch();

tls				:: TLS(ETHERADDRESS deviceaddress, KEYSERVER 00-00-00-00-00-01, ROLE "CLIENT", KEYDIR "/home/aureliano/Uni/METRIK/repository2/click-brn-scripts/039-centralized_auth_proto/", DEBUG 5);
BackboneNode	:: BACKBONE_NODE(NODEID id, PROTOCOL_TYPE "CLIENT-DRIVEN", WEPENCAP wifidev_ap/wep/wep_encap, WEPDECAP wifidev_ap/wep/wep_decap, START 10000, KEY_TIMEOUT 5000, DEVICE_CONTROL_UP switch_up, DEVICE_CONTROL_DOWN switch_down, DEVICE_CONTROL_DOWN2 switch_down2, DEBUG 5);





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



/********* Layer 1: Integration of wifidev_client *********/
switch_up[0] // Flow 0 upwards: Client-Pkts 
	//-> Print("received by client ++++++")
	-> [1]wifidev_client[1]
	-> Print("Node as Cl: Power!!!")
	-> [0]switch_down; // Flow 0 downwards: Client-Pkts 

/********* Layer 1: Integration of wifidev_ap *********/
switch_up[1] // Flow 1 upwards: AP-Pkts 
	-> [2]wifidev_ap[6]
	-> Print("Node as AP: Power!!!!")
	-> [1]switch_down; // Flow 1 downwards: AP-Pkts 



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
	//-> Print("BRN-In")
	-> BRN2EtherDecap()
	-> dsr_clf;
	
	dsr_clf[0]
		//-> Print("DSR-Packet")
		-> [1]dsr;

	dsr_clf[1]
		//-> Print("No DSR-Packet")
		-> Discard;

wifidev_ap[2] 
	// -> Print("NODENAME: For and brn", TIMESTAMP true)
	-> [0]dsr;  //foreign and brn

wifidev_ap[3] -> Discard;  //to me no brn
wifidev_ap[4] -> Discard;  //broadcast and no brn

wifidev_ap[5] //foreign and no brn
	-> [0]dsr;

dsr[0]
	-> toMeAfterDsr::BRN2ToThisNode(NODEIDENTITY id);
	
	toMeAfterDsr[0] 
		-> Print("DSR-out: For ME",100)
		-> from_routing :: Null();
	  
	toMeAfterDsr[1]
		-> Print("DSR-out: Broadcast")
		-> Discard;

	toMeAfterDsr[2]
		-> Print("DSR-out: Foreign/Client")
		-> [1]wifidev_ap;
  
dsr[1] 
	-> Print("DSR[1]-out")
	-> SetEtherAddr(SRC deviceaddress)
	-> Print("DSR-Ether-OUT")
	-> [0]wifidev_ap;


Idle -> [2]dsr;
Idle -> [3]dsr;







/********* Layer 3: Integration of MobiSEC-Module *********
 *
 * Input 0: 	To MobiSEC
 * Output 0: 	From MobiSEC
 */

to_MobiSEC_BackboneNode :: Null()
	-> BRN2EtherDecap()
	-> BRN2Decap()
	-> tls
	//-> Print("tls from client")
	-> BRN2EtherEncap(USEANNO true)
	-> Print("tls from client")
	-> from_MobiSEC_BackboneNode :: Null();

	tls[1] // decrypt message
		-> Print()
		-> BackboneNode
		-> [1]tls; //encrypt message

/***** connection to wifidev_client *******/
wifidev_client
	-> to_MobiSEC_BackboneNode;
	
/***** connection to wifidev_ap *******/	
from_routing
	-> to_MobiSEC_BackboneNode;
	
from_MobiSEC_BackboneNode
	-> switch_down2;
	
	switch_down2[0]
		-> wifidev_client;
	switch_down2[1]
		-> to_routing;




Script(
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
);


