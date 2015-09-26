#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/wifidev_client.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

infra_client :: WIFIDEV_CLIENT( DEVICENAME "NODEDEVICE", DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", ACTIVESCAN false );

infra_client
  -> brn_ether_clf :: Classifier( 12/8086 14/BRN_PORT_FLOW, - )
  -> BRN2EtherDecap()
  //-> Print("rx")
  -> BRN2Decap()
  -> sf::BRN2SimpleFlow(FLOW "deviceaddress 00:00:00:00:00:03 1000 100 0 20000 false")
  -> BRN2EtherEncap(USEANNO true)
  -> infra_client;
 
  brn_ether_clf[1]
  -> Classifier( 12/0800 )
  -> BRN2EtherDecap() 
  //-> Print("ff",TIMESTAMP true)
  -> CheckIPHeader(0)
  -> ip_classifier :: IPClassifier(dst udp port 68 and src udp port 67, -)
  //-> Print("For DHCP-CLient")
  -> Strip(28) // strip ip and udp
  -> dhcpr::BRN2DHCPClient(FIRSTETHERADDRESS deviceaddress, FIRSTIP 0.0.0.0, RANGE 1, STARTTIME 60000, DIFF 500, DEBUG 2)
  -> udpen::UDPIPEncap(0.0.0.0, 68, 255.255.255.255, 67)
  -> EtherEncap(0x0800, deviceaddress , ff:ff:ff:ff:ff:ff)
  //-> Print("DHCP-Client")
  -> infra_client;

ip_classifier[1] -> Discard;
dhcpr[1] -> udpen;

Script(
  wait 5,
  read infra_client/client/isc.wireless_info,
  read infra_client/client/isc.assoc,
  wait 65,
  read dhcpr.stats
);
