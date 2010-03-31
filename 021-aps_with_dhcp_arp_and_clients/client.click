#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/simdev.click"
#include "device/wifidev_client.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

infra_client :: WIFIDEV_CLIENT( DEVICENAME "eth0", DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn");

arpc::BRN2ARPClient(CLIENTIP 192.168.0.50, CLIENTETHERADDRESS deviceaddress, STARTIP 192.168.0.5,
                    ADDRESSRANGE 2, START 13000, INTERVAL 1000, COUNT 2,
                    REQUESTSPERTIME 1, TIMEOUT 1000, ACTIVE true, DEBUG 4);

infra_client
  -> brn_ether_clf :: Classifier( 12/8086 14/BRN_PORT_FLOW, - )
  -> BRN2EtherDecap()
  -> Print("rx")
  -> BRN2Decap()
  -> sf::BRN2SimpleFlow(SRCADDRESS deviceaddress, DSTADDRESS 00:0f:00:00:00:00,
                        RATE 1000 , SIZE 100, MODE 0, DURATION 20000,ACTIVE 0)
  -> BRN2EtherEncap()
  -> infra_client;
 
  brn_ether_clf[1]
  -> dhcp_arp_clf::Classifier( 12/0800,
                               12/0806,
                                -   )

  -> BRN2EtherDecap() 
  -> CheckIPHeader(0)
  -> ip_classifier :: IPClassifier(dst udp port 68 and src udp port 67, -)
  -> Strip(28) // strip ip and udp
  -> dhcpr::BRN2DHCPClient(FIRSTETHERADDRESS deviceaddress, FIRSTIP 0.0.0.0, RANGE 1, STARTTIME 10000, DIFF 500, DEBUG 4)
  -> udpen::UDPIPEncap(0.0.0.0, 68, 255.255.255.255, 67)
  -> EtherEncap(0x0800, deviceaddress , ff:ff:ff:ff:ff:ff)
  -> Print("DHCP-Client")
  -> infra_client;

dhcp_arp_clf[1]
-> arpc
-> [0]infra_client;

dhcp_arp_clf[2]
-> Discard;

ip_classifier[1] -> Discard;
dhcpr[1] -> udpen;

Script(
  wait 5,
  read infra_client/client/isc.wireless_info,
  read infra_client/client/isc.assoc,
  wait 10,
  wait 5,
  read  sf.txflows,
  read  sf.rxflows
);
