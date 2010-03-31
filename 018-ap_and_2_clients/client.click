#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/simdev.click"
#include "device/wifidev_client.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

infra_client :: WIFIDEV_CLIENT( DEVICENAME "eth0", DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn");

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
  -> Discard;

Script(
  wait 5,
  read infra_client/client/isc.wireless_info,
  read infra_client/client/isc.assoc,
  wait 10,
  wait 5,
  read  sf.txflows,
  read  sf.rxflows
);
