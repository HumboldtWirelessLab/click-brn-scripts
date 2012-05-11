//#define RAWDUMP
//#define RAWDEV_DEBUG

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_ap.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV_AP(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", CHANNEL 5, LT lt);

tls::TLS(ETHERADDRESS deviceaddress, dst 00-00-00-00-00-01, ROLE "SERVER", KEYDIR "/home/aureliano/Uni/METRIK/repository2/click-brn-scripts/039-centralized_auth_proto/", DEBUG 5);

KeyServer::keyserver(PROTOCOL_TYPE "CLIENT-DRIVEN", KEY_LIST_CARDINALITY 4, KEY_TIMEOUT 15, START 5 /* too fast ?? */, DEBUG 5);

device_wifi
	-> srv_cnt_in::Counter()
	-> BRN2EtherDecap()
	-> BRN2Decap()
	-> tls
	-> srv_cnt_out::Counter()
	-> BRN2EtherEncap(USEANNO true)
	-> [1]device_wifi; // forwarding to ap-clients, some improvements later needed here: guessing if pkt is for ap-clients

	tls[1] // decrypt message
	    -> Print()
		-> KeyServer
		-> Print()
		-> [1]tls; //encrypt message

	device_wifi[1] -> Discard;
	device_wifi[2] -> Discard;
	device_wifi[3] -> Discard;
	device_wifi[4] -> Discard;
	device_wifi[5] -> Discard;

Idle
-> [0]device_wifi;

Idle
-> [1]device_wifi;







Script(
  wait 12,
  read device_wifi/ap/assoclist.stations,
  read lt.links,
  wait 10,
  read srv_cnt_in.count,
  read srv_cnt_out.count,
  wait 5
);
