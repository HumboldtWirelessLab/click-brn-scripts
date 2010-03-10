#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/simdev.click"
#include "device/wifidev_client.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

infra_client :: WIFIDEV_CLIENT( DEVICENAME "eth0", DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn");

arpc::BRN2ARPClient(CLIENTIP 192.168.0.6, CLIENTETHERADDRESS deviceaddress, STARTIP 192.168.1.81,
                    ADDRESSRANGE 1, START 13000, INTERVAL 1000, COUNT 2,
                    REQUESTSPERTIME 1, TIMEOUT 1000, ACTIVE true, DEBUG 3);

infra_client
  -> brn_ether_clf :: Classifier( 12/8086 14/10, - )
  -> BRN2EtherDecap()
//  -> Print("rx")
  -> StripBRNHeader()
  -> sf::BRN2SimpleFlow(SRCADDRESS deviceaddress, DSTADDRESS 00:0f:00:00:00:00,
                        RATE 1000 , SIZE 100, MODE 0, DURATION 20000,ACTIVE 0)
  -> BRN2EtherEncap()
  -> infra_client;
 
  brn_ether_clf[1]
  -> dhcp_arp_clf::Classifier( 12/0800,
                               12/0806,
                                -   )

//-> Print("client got ip reply") 
  -> BRN2EtherDecap() 
  -> CheckIPHeader(0)
  -> ip_classifier :: IPClassifier(dst udp port 68 and src udp port 67,
                                   src udp port 53,
                                     -)
  -> Strip(28) // strip ip and udp
  -> dhcpr::BRN2DHCPClient(FIRSTETHERADDRESS deviceaddress, FIRSTIP 0.0.0.0, RANGE 1, STARTTIME 11000, DIFF 500, DEBUG 3)
  -> udpen::UDPIPEncap(0.0.0.0, 68, 255.255.255.255, 67)
  -> EtherEncap(0x0800, deviceaddress , ff:ff:ff:ff:ff:ff)
//-> Print("DHCP-Client")
  -> infra_client;

dhcp_arp_clf[1]
-> arpc
-> [0]infra_client;

dhcp_arp_clf[2]
-> Discard;


ip_classifier[1]
//-> Print("got DNS response")
-> Strip(28) // strip ip and udp
//-> BRN2DNSClient(".192.168.0.6.bloblo.org", 18000,1000,true,0, DEBUG 4)
-> BRN2DNSClient(".www.bloblo.org", 18000, 1000, true, 0, DEBUG 3)
-> UDPIPEncap( 192.168.0.5 , 39000 , 192.168.0.1 , 53 )
-> CheckIPHeader()
-> EtherEncap(0x0800, 00:0f:00:00:00:00 , ff:ff:ff:ff:ff:ff /*00:0f:00:00:01:00*/ )
//-> Print("DNS-Request")
-> [0]infra_client;

ip_classifier[2] -> Discard;
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
