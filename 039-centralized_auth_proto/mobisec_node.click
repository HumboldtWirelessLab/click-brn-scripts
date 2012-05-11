//#define RAWDUMP
//#define RAWDEV_DEBUG

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_client.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

infra_client :: WIFIDEV_CLIENT( DEVICENAME "eth0", DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", ACTIVESCAN false);

tls::TLS(ETHERADDRESS deviceaddress, dst 00-00-00-00-00-02, ROLE "CLIENT", KEYDIR "/home/aureliano/Uni/METRIK/repository2/click-brn-scripts/039-centralized_auth_proto/", DEBUG 5);

BackboneNode::backbone_node(NODEID id, PROTOCOL_TYPE "CLIENT-DRIVEN", DEBUG 5);

infra_client
	-> cl_cnt_in::Counter()
	-> BRN2EtherDecap()
	-> BRN2Decap()
	-> tls
	-> cl_cnt_out::Counter()
	-> BRN2EtherEncap(USEANNO true)
	-> infra_client;

	tls[1] // decrypt message
	    -> Print()
		-> BackboneNode
		-> Print()
		-> [1]tls; //encrypt message



Script(
 wait 1,
 loop
);

Script(
  wait 10,
  read infra_client/client/isc.wireless_info,
  read infra_client/client/isc.assoc,
  wait 15,
  read cl_cnt_in.count,
  read cl_cnt_out.count,
  wait 5
);

