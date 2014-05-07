#define DEBUGLEVEL 2

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#define RAWDUMP

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

Idle()
  -> sf::BRN2SimpleFlow(FLOW "deviceaddress 00:00:00:00:00:01 1000 1500 0 5000 true 1 0", DEBUG 2)  //VAR_RATE VAR_PSIZE
  -> BRN2EtherEncap(USEANNO true)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRate(RATE 2, TRIES 7)
  -> SetTXPower(24)
  -> wifioutq::NotifierQueue(10)
  -> wifidevice
  -> discard::Discard;

