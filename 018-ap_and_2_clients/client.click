#define DEBUGLEVEL 2

#define RAWDEV_DEBUG
#define RAWDUMP

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/wifidev_client.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

infra_client :: WIFIDEV_CLIENT( DEVICENAME "NODEDEVICE", DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", ACTIVESCAN false);

infra_client
  -> brn_ether_clf :: Classifier( 0/000000000003 12/8086 14/BRN_PORT_FLOW, - )
  -> BRN2EtherDecap()
  -> Print("rx", TIMESTAMP true)
  -> BRN2Decap()
  -> sf::BRN2SimpleFlow(DEBUG 4)
  -> Print("tx", TIMESTAMP true)
  -> BRN2EtherEncap(USEANNO true)
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
  wait 6,
  read  sf.stats
);

