#define DEBUGLEVEL 2

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#define FOREIGNRXSTATS
#define RAWDUMP
//#define RAWDUMPSNAPLEN 100

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

server_lwip::LwIP(IP 192.168.2.2, GATEWAY 192.168.2.1, NETMASK 255.255.255.0, SERVERPORT 12345, DEBUG 3)

  wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless)
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
  -> BRN2PrintWifi("OKPacket (NODENAME)", TIMESTAMP true)
  -> WifiDecap()

  -> BRN2EtherDecap()

  -> Print("SERVER in")
  -> td::ToDump("receiver.dump", ENCAP IP)
  -> server_lwip
  -> Print("SERVER out")
  -> CheckIPHeader()
  -> SetTimestamp()
  -> IPPrint("SERVER->CLIENT", ACTIVE true)

  -> EtherEncap(0x0800, 0:0:0:0:0:1, 0:0:0:0:0:2)

  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> SetTXRate(RATE 2, TRIES 1)
  -> SetTXPower(24)
  -> SetRTS(false)

  -> wifioutq::NotifierQueue(100)
  -> SetTimestamp()
  -> BRN2PrintWifi("Sender (NODENAME)", TIMESTAMP true)
  -> wifidevice;

Idle() -> [1]server_lwip[1] -> Discard();
