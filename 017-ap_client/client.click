#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/wifidev_client.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

infra_client :: WIFIDEV_CLIENT( DEVICENAME "NODEDEVICE", DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", ACTIVESCAN false);

Idle
  -> infra_client
  -> Discard;

Script(
  wait 5,
  read infra_client/client/isc.wireless_info,
  read infra_client/client/isc.assoc,
  wait 5,
  write infra_client/client/isc.disassoc,
  wait 5,
  read infra_client/client/isc.wireless_info,
  read infra_client/client/isc.assoc
);
