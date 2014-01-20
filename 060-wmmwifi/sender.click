#define DEBUGLEVEL 2

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#define RAWDUMP

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS", CWMIN CWMINPARAM, CWMAX CWMAXPARAM, AIFS AIFSPARAM);

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

Idle()
  -> sf::BRN2SimpleFlow(FLOW "deviceaddress 00:00:00:00:00:01 1000 1500 0 5000 true 1 0", DEBUG 0)  //VAR_RATE VAR_PSIZE
  -> BRN2EtherEncap(USEANNO true)
  -> WMMWifiEncap(0x00, 0:0:0:0:0:0, 57, 16)
  //-> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTimestamp()
  -> SetTXRates(RATE0 2, TRIES0 1, TRIES1 0, TRIES2 0, TRIES3 0)
  -> SetTXPower(13)
  -> wifioutq::NotifierQueue(10)
  -> SetTimestamp()
  -> BRN2PrintWifi("Sender (NODENAME)", TIMESTAMP true)
  -> wifidevice
  -> BRN2PrintWifi("TXFeedback", TIMESTAMP true)
  -> discard::Discard;

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);
