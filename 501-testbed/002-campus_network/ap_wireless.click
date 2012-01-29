BRNAddressInfo(deviceaddress NODEDEVICE:eth);
BRNAddressInfo(deviceip 192.168.100.1);
BRNAddressInfo(backbone_ip ath1:ip);
BRNAddressInfo(backbone_eth ath1:eth);
BRNAddressInfo(gateway_ip 192.168.3.1);
BRNAddressInfo(server_eth 00-01-02-03-04-05);
BRNAddressInfo(server_ip 192.168.100.1);

#define CST cst

#if WIFITYPE == 802
#define CST_PROCFILE "/sys/devices/pci0000\:00/0000\:00\:11.0/stats/channel_utility"
#else
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"
#endif

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/simple_ap.click"

wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS", IPADDRESS deviceip, SERVICEDEVICE true, MASTERDEVICE true);
backbone::BRN2Device(DEVICENAME "ath1", ETHERADDRESS backbone_eth, DEVICETYPE "WIRED", IPADDRESS backbone_ip);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES "wireless backbone" );

rc::Brn2RouteCache(DEBUG 0, ACTIVE true, DROP /* 1/20 = 5% */ 0, SLICE /* 100ms */ 0, TTL /* 4*100ms */4);
lt::Brn2LinkTable(NODEIDENTITY id, ROUTECACHE rc, STALE 500, MIN_LINK_METRIC_IN_ROUTE 9998);

device_wifi::WIFIDEV_AP(DEVNAME NODEDEVICE, DEVICE wireless, ETHERADDRESS deviceaddress, SSID "HWL", CHANNEL 11, LT lt);

arp_tab :: ARPTable();

tunnel_q::NotifierQueue(1000)
  //-> Print("From Client")
  -> cnt_from_client::Counter()
  -> ToSocket(TYPE UDP, ADDR gateway_ip, PORT 10000, HEADROOM 128 );
  //-> tun_socket::Socket(TYPE UDP, ADDR gateway_ip, PORT 10000, LOCAL_ADDR backbone_ip, LOCAL_PORT 10000, CLIENT true, HEADROOM 128 );

  FromSocket(UDP, 0.0.0.0, 10000)
  -> cnt_to_client::Counter()
  //-> Print("To Client")
  -> [0]device_wifi;

device_wifi[0]
  -> service_clf::Classifier( 12/0806, //arp tunnel
                              12/0800)
  //-> tunnel_q;
  -> ar::ARPResponder(server_ip server_eth, 192.168.100.2 deviceaddress )
  -> [0]device_wifi;

device_wifi[1] 
  -> service_clf;

service_clf[1]
//-> MarkIPHeader(OFFSET 14)
  -> CheckIPHeader(OFFSET 14, VERBOSE true)
  -> MarkIPHeader(OFFSET 14)
  //-> IPPrint()
  -> ipf::IPClassifier( dst 141.20.21.20 and tcp port 1194,
                        dst 141.20.21.20 and udp port 1194,
                        dst 141.20.37.97 and tcp port 80,
                        dst 192.168.100.1 and tcp port 80,
                        dst port 53,
                        dst udp port 67,
                        dst 192.168.100.2,
                        icmp type >=0,
                        - );


  ipf[0] -> tunnel_q;
  ipf[1] -> tunnel_q;
  ipf[2] -> tunnel_q;
  ipf[3] -> tunnel_q;
  ipf[4] -> tunnel_q;
  ipf[5] -> tunnel_q;
  ipf[6]
    -> IPClassifier(icmp echo)
    -> StoreIPEthernet(arp_tab)
    -> Strip(14)
    -> CheckIPHeader(OFFSET 0)
    -> ICMPPingResponder()
    -> CheckIPHeader(0)
    -> resolve :: ResolveEthernet(deviceaddress, arp_tab)
    -> [0]device_wifi;

  ipf[7] -> tunnel_q;
  ipf[8] -> Discard;


device_wifi[2]
-> tt::BRN2ToThisNode(id)
-> service_clf;

tt[1] -> Discard;
tt[2] -> Discard;

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
