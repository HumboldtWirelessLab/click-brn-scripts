#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/simdev.click"
#include "device/wifidev_client.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

infra_client :: WIFIDEV_CLIENT( DEVICENAME "eth0", DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brnvlan", ACTIVESCAN true);

arpc::BRN2ARPClient(CLIENTIP 192.168.0.5, CLIENTETHERADDRESS deviceaddress, STARTIP 192.168.0.6,
                    ADDRESSRANGE 1, START 100000, INTERVAL 1000, COUNT 2,
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

  -> BRN2EtherDecap() 
  -> CheckIPHeader(0)
  -> ip_classifier :: IPClassifier(dst udp port 68 and src udp port 67,
                                   src udp port 53,
                                     -)
  -> Strip(28) // strip ip and udp
  -> dhcpr::BRN2DHCPClient(FIRSTETHERADDRESS deviceaddress, FIRSTIP 0.0.0.0, RANGE 1, STARTTIME 12000, DIFF 500, DEBUG 3)
  -> udpen::UDPIPEncap(0.0.0.0, 68, 255.255.255.255, 67)
  -> EtherEncap(0x0800, deviceaddress , ff:ff:ff:ff:ff:ff)
//  -> Print("DHCP-Client")
  -> infra_client;

dhcp_arp_clf[1]
-> arpc
-> [0]infra_client;

dhcp_arp_clf[2]
-> Discard;


ip_classifier[1]
-> Strip(28) // strip ip and udp
-> Discard;
//-> BRN2DNSClient(".www.berlinroonet.de", 15000,1000,true,0)
Idle
-> UDPIPEncap( 192.168.0.5 , 39000 , 192.168.0.1 , 53 )
-> CheckIPHeader()
-> EtherEncap(0x0800, 00:0f:00:00:01:00 , 00:0f:00:00:00:00 )
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
