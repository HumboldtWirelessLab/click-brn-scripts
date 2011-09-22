#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/wifidev_client.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

infra_client :: WIFIDEV_CLIENT( DEVICENAME "NODEDEVICE", DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", ACTIVESCAN false );

infra_client
  -> brn_ether_clf :: Classifier(  0/000000000001 12/8086 14/BRN_PORT_FLOW, - )
  -> Print("rx1")
  -> BRN2EtherDecap()
  -> Print("rx")
  -> BRN2Decap()
  -> sf::BRN2SimpleFlow(HEADROOM 192)
  -> BRN2EtherEncap()
  -> infra_client;
 
  brn_ether_clf[1]
  -> Discard;

Script(
  wait 5,
  read infra_client/client/isc.wireless_info,
  read infra_client/client/isc.assoc
);
