#define CST cst

#if WIFITYPE == 802
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:11.0/stats/channel_utility"
#else
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"
#endif

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/simple_ap.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

rc::Brn2RouteCache(DEBUG 0, ACTIVE true, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITY id, ROUTECACHE rc, STALE 500,  SIMULATE false, CONSTMETRIC 1, MIN_LINK_METRIC_IN_ROUTE 9998);

device_wifi::WIFIDEV_AP(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, SSID "HWL", CHANNEL 6, LT lt);

device_wifi[0] -> Discard;
device_wifi[1] -> Discard;
Idle -> [0]device_wifi;

ps::BRN2PacketSource(SIZE 180, INTERVAL 1000 , MAXSEQ 500000, BURST 1, ACTIVE true)
-> UDPIPEncap(SRC 192.168.100.3, SPORT 53876, DST 142.21.20.24, DPORT 80)
-> CheckIPHeader()
-> EtherEncap(ETHERTYPE 0x0800, SRC 00:13:77:e9:b6:19, DST 00:01:02:03:04:05) 
-> Socket(TYPE UDP, ADDR 192.168.3.1, PORT 10000, LOCAL_PORT 10000, CLIENT true )
-> Print()
-> BRN2EtherDecap()
-> CheckIPHeader()
-> IPPrint()
-> Discard;