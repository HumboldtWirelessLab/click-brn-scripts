AddressInfo(server_ip 192.168.0.1);
AddressInfo(server2_eth eth0:eth);
AddressInfo(server_eth 00:00:00:00:00:01);
AddressInfo(client_eth 00:00:00:00:00:02);


#include "brn/brn.click"
#include "dht/storage/dht_storage.click"

Idle ->
dhtstorage :: DHT_STORAGE(DEBUG 2)
-> Discard;

dsnl::BRN2DHCPSubnetList();

lease_tab::BRN2DHCPLeaseTable(DEBUG 2);

dh::BRN2DHCPServer( ETHERADDRESS server_eth, ADDRESSPREFIX 192.168.0.0/24,
                    ROUTER server_ip, SERVER 192.168.0.1, DNS 192.168.0.1, SERVERNAME foo, DOMAIN bla, DHCPSUBNETLIST dsnl, DHTSTORAGE dhtstorage/dhtstorage, LEASETABLE lease_tab, DEBUG 2);

  
  fromClient::BRN2EtherDecap()
  -> Strip(28) // strip ip and udp
  -> dh
  -> UDPIPEncap(192.168.0.1, 67, 255.255.255.255, 68)
  //-> EtherEncap(0x0800, server_eth , ff:ff:ff:ff:ff:ff)
  -> BRN2EtherEncap(USEANNO true)
  -> Print("ServerReply")
 
   // To Client

  -> BRN2EtherDecap() 
  -> CheckIPHeader(0)
  -> ip_classifier :: IPClassifier(dst udp port 68 and src udp port 67, -)
  -> Strip(28) // strip ip and udp
  -> dhcpr::BRN2DHCPClient(FIRSTETHERADDRESS client_eth, FIRSTIP 0.0.0.0, RANGE 1, STARTTIME 1000, DIFF 500, DEBUG 2)
  -> udpen::UDPIPEncap(0.0.0.0, 68, 255.255.255.255, 67)
  -> EtherEncap(0x0800, client_eth , ff:ff:ff:ff:ff:ff)
  -> fromClient;

   dhcpr[1] -> udpen; 
   
   ip_classifier[1]
   -> Discard;

Script(
  wait 5,
  read lease_tab.leases,
  stop
);
