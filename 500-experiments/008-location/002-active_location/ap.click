#define DEBUGLEVEL 2

#include "brn/brn.click"
#include "device/wifidev_ap.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);

device_wifi::WIFIDEV_AP(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, SSID "rnet", CHANNEL 8, LT lt);

device_wifi
-> BRN2EtherDecap()
-> Discard;

device_wifi[1] -> BRN2EtherDecap() -> Discard;
device_wifi[2] -> Discard;
device_wifi[3] -> Discard;
device_wifi[4] -> Discard;
device_wifi[5] -> Discard;

Idle
-> [0]device_wifi;

Idle
-> [1]device_wifi;

Script(
);
