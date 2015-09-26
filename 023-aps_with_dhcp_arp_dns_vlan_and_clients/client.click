#ifndef DEBUGLEVEL
#define DEBUGLEVEL 1
#endif

#include "brn/brn.click"
#include "device/wifidev_client.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

infra_client :: WIFIDEV_CLIENT( DEVICENAME "NODEDEVICE", DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", ACTIVESCAN false );

arpc::BRN2ARPClient(CLIENTIP 192.168.0.11, CLIENTETHERADDRESS deviceaddress, STARTIP 192.168.0.6,
                    ADDRESSRANGE 1, START 65000, INTERVAL 2000, COUNT 2,
                    REQUESTSPERTIME 1, TIMEOUT 1000, ACTIVE true, DEBUG 2);

infra_client
  -> brn_ether_clf :: Classifier( 12/8086 14/BRN_PORT_FLOW, - )
  -> BRN2EtherDecap()
#if DEBUGLEVEL > 3
  -> Print("rx")
#endif
  -> BRN2Decap()
  -> sf::BRN2SimpleFlow(FLOW "deviceaddress 00:00:00:00:00:03 1000 100 0 20000 false")
  -> BRN2EtherEncap()
  -> infra_client;
 
  brn_ether_clf[1]
  -> dhcp_arp_clf::Classifier( 12/0800,
                               12/0806,
                                -   )

  -> BRN2EtherDecap() 
  -> CheckIPHeader(0)
#if DEBUGLEVEL > 3
  -> IPPrint("Client")
#endif
  -> ip_classifier :: IPClassifier(dst udp port 68 and src udp port 67,
                                   src udp port 53,
                                     -)
  -> Strip(28) // strip ip and udp
  -> dhcpr::BRN2DHCPClient(FIRSTETHERADDRESS deviceaddress, FIRSTIP 0.0.0.0, RANGE 1, STARTTIME 60000, DIFF 500, DEBUG 2)
  -> udpen::UDPIPEncap(0.0.0.0, 68, 255.255.255.255, 67)
  -> EtherEncap(0x0800, deviceaddress , ff:ff:ff:ff:ff:ff)
#if DEBUGLEVEL > 3
  -> Print("DHCP-Client")
#endif
  -> infra_client;

dhcp_arp_clf[1]
  -> arpc
  -> [0]infra_client;

dhcp_arp_clf[2]
  -> Discard;


ip_classifier[1]
#if DEBUGLEVEL > 3
  -> Print("DNS-Response")
#endif
  -> Strip(28) // strip ip and udp
  -> dnsc::BRN2DNSClient("192.168.0.11.bloblo.org", 68000, 2000, true, DEBUG 2)
  -> UDPIPEncap( 192.168.0.6 , 39000 , 192.168.0.1 , 53 )
  -> CheckIPHeader()
  -> EtherEncap(0x0800, deviceaddress , /*00:00:00:00:00:02*/ ff:ff:ff:ff:ff:ff )
#if DEBUGLEVEL > 3
  -> Print("DNS-request (IP)", TIMESTAMP true)
#endif
  -> [0]infra_client;

ip_classifier[2] -> Discard;
dhcpr[1] -> udpen;

Script(
  wait 5,
  read infra_client/client/isc.wireless_info,
  read infra_client/client/isc.assoc,
  wait 65,
  read dhcpr.stats,
  read arpc.stats,
  read dnsc.stats
);
