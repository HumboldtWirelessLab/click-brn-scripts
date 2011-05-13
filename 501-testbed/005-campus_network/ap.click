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

tunnel_q::NotifierQueue(1000)
  //-> Print("From Client")
  -> cnt_from_client::Counter()

  -> tun_socket::Socket(TYPE UDP, ADDR gateway_ip, PORT 10000, LOCAL_ADDR my_ip, LOCAL_PORT 10000, CLIENT true, HEADROOM 128 )

  -> cnt_to_client::Counter()
  //-> Print("To Client")
  -> [0]device_wifi;

device_wifi[0]
  -> service_clf::Classifier( 12/0806, //arp tunnel
                              12/0800)
  -> tunnel_q;

device_wifi[1] 
  -> service_clf;

service_clf[1]
  -> MarkIPHeader(OFFSET 14)
  -> CheckIPHeader(OFFSET 14, VERBOSE true)
  //-> IPPrint()
  -> ipf::IPClassifier( dst 141.20.21.20 and tcp port 1194,
                        dst 141.20.21.20 and udp port 1194,
                        dst 141.20.37.97 and tcp port 80,
                        dst 192.168.100.1 and tcp port 80,
                        dst port 53,
                        dst udp port 67,
                        icmp type >=0,
                        - );


  ipf[0] -> tunnel_q;
  ipf[1] -> tunnel_q;
  ipf[2] -> tunnel_q;
  ipf[3] -> tunnel_q;
  ipf[4] -> tunnel_q;
  ipf[5] -> tunnel_q;
  ipf[6] -> tunnel_q;
  ipf[7] -> Discard; //->tunnel_q;

gps::GPS();

#ifndef SIMULATION
FromSocket("UDP", 127.0.0.1, 8086)
#else
Idle()
#endif
-> seismo::Seismo(GPS gps, CALCSTATS true, PRINT false);

/* DNS Redirect
  f[3]
  -> StripIPHeader()
  -> Strip(8)
  -> bind::BRN2DNSServer(SERVERNAME ".hwl", DOMAIN ".hu-berlin.de", SERVER 141.20.37.97, SERVERREDIRECT true, DEBUG 2)
  -> UDPIPEncap()
  tunnel_q;
*/

/* Tunnel test
RatedSource(\<0800010203040506070809>, 100, 10000)
-> UDPIPEncap(SRC 192.168.100.3, SPORT 20000, DST 192.168.100.1, DPORT 88)
-> EtherEncap(0x0800, 00-02-04-01-01-09,00-01-02-03-04-05)
-> tunnel_q;
*/
