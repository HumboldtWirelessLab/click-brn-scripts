BRNAddressInfo(my_ip eth0:ip);
BRNAddressInfo(gateway_ip 192.168.3.1);

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

device_wifi::WIFIDEV_AP(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, SSID "HWL", CHANNEL 11, LT lt);


tunnel_q::NotifierQueue(1000);

device_wifi[0] -> tunnel_q;
device_wifi[1] -> tunnel_q;

from_tunnel::Null()
  //-> Print("To Client")
  -> [0]device_wifi;

tunnel_q
  //-> Print("From Client")
  -> tun_socket::Socket(TYPE UDP, ADDR gateway_ip, PORT 10000, CLIENT true );
  //-> tun_socket::Socket(TYPE UDP, ADDR gateway_ip, PORT 10000, LOCAL_ADDR my_ip, LOCAL_PORT 10000, CLIENT true )
  //-> from_tunnel;

FromRawSocket(UDP, 10000)
  //-> Print("To Client (From socket)")
  -> CheckIPHeader()
  -> IPClassifier(dst udp port 10000)
  //-> IPPrint("FromDev")
  -> StripIPHeader() //remove tunnel ip
  -> Strip(8)        //remove tunnel udp
  -> from_tunnel;

/*
FromSocket(UDP, 0.0.0.0, 10001) //0.0.0.0 -> my_ip
-> from_tunnel;

FromDevice(eth0)
-> BRN2EtherDecap()
-> CheckIPHeader()
-> IPClassifier(dst udp port 10000)
-> IPPrint("FromDev")
-> StripIPHeader() //remove tunnel ip
-> Strip(8)        //remove tunnel udp
-> from_tunnel;
*/


