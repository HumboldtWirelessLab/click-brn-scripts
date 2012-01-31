#define DEBUGLEVEL 2

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_client.click"

BRNAddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

infra_client :: WIFIDEV_CLIENT( DEVICENAME "eth0", DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", ACTIVESCAN false);

infra_client
  -> brn_ether_clf :: Classifier( 0/000000000001 12/8086 14/BRN_PORT_FLOW, - )
  -> BRN2EtherDecap()
  -> Print("src rx", TIMESTAMP true)
  -> BRN2Decap()
  -> sf::BRN2SimpleFlow(DEBUG 4)
  -> Print("src tx", TIMESTAMP true)
  -> BRN2EtherEncap()
  -> infra_client;
 
  brn_ether_clf[1]
  -> Discard;

Script(
 wait 1,
 loop
);

Script(
  wait 5,
  read infra_client/client/isc.wireless_info,
  read infra_client/client/isc.assoc,
  write  sf.add_flow 00:00:00:00:00:01 00:00:00:00:00:03 1000 100 2 10000 true,
  wait 6,
  read  sf.stats
);

