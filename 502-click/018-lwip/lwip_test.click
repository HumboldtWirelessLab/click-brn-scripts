client_lwip::LwIP(IP 192.168.1.2, GATEWAY 192.168.1.1, NETMASK 255.255.255.0, DEBUG 3)
server_lwip::LwIP(IP 192.168.2.2, GATEWAY 192.168.2.1, NETMASK 255.255.255.0, SERVERPORT 12345, DEBUG 3)


client_lwip

-> SetCRC32()
-> rbe1::RandomBitErrors(0.00005)
-> CheckCRC32()

-> Print("CLIENT out", 600)
-> CheckIPHeader()
-> SetTimestamp()
//-> IPRewriter(pattern - -  192.168.2.2 -  0 0)
-> IPPrint("CLIENT->SERVER", ACTIVE true)
-> EtherEncap(0x0800, 1:1:1:1:1:1, 2:2:2:2:2:2)
-> cs_tee::Tee()


-> BRN2EtherDecap()
-> Print("SERVER in")
-> server_lwip

-> SetCRC32()
-> rbe2::RandomBitErrors(0.0001)
-> CheckCRC32()

-> Print("SERVER out")
-> CheckIPHeader()
-> SetTimestamp()
//-> IPRewriter(pattern 192.168.1.2 -  - -  0 0)
-> IPPrint("SERVER->CLIENT", ACTIVE true)
-> EtherEncap(0x0800, 2:2:2:2:2:2,1:1:1:1:1:1)
-> sc_tee::Tee()


-> BRN2EtherDecap()
-> Print("Client in",600)
-> client_lwip;

Idle() -> [1]client_lwip[1] -> Discard();
Idle() -> [1]server_lwip[1] -> Discard();

cs_tee[1] -> td::ToDump("ip.dump");
sc_tee[1] -> td;

Script(
  write rbe1.active false,
  write rbe2.active false,
  wait 1,
  write client_lwip.add_flow 192.168.2.2 12345 30000,
//  write client_lwip.add_flow 192.168.2.2 12345 50000
);

Script( wait 10,  stop);