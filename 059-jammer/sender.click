#define DEBUGLEVEL 2

#define CST cst

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

Idle()
  -> sf::BRN2SimpleFlow(FLOW "deviceaddress FF:FF:FF:FF:FF:FF 5 1500 0 3000 true 1 0", DEBUG 2)
  -> BRN2EtherEncap(USEANNO true)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTimestamp()
  -> SetTXRate(RATE 2, TRIES 1)
  -> SetTXPower(24)
  -> sj::SetJammer(JAMMER true)
  -> wifioutq::NotifierQueue(10)
  -> SetTimestamp()
  -> wifidevice
  -> discard::Discard;

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

Script(
  read wireless.deviceinfo,
  write wireless.cca -20 -20 10,
  wait 2,
  read wifidevice/cst.stats
);
