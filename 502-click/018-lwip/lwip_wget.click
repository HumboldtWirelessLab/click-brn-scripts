server_lwip::LwIP(IP 192.168.10.2, GATEWAY 192.168.10.1, NETMASK 255.255.255.0, SERVERPORT 80, DEBUG 3)



FromHost(tap0)
-> Print("In", TIMESTAMP true)
-> arp_clf::Classifier( 12/0800,
                        12/0806)

-> cs_tee::Tee()
-> BRN2EtherDecap()
-> IPPrint("CLIENT->SERVER", ACTIVE true)
-> server_lwip
-> CheckIPHeader()
-> SetTimestamp()
-> IPPrint("SERVER->CLIENT", ACTIVE true)
-> EtherEncap(0x0800, 56:3c:c0:b3:2e:b1 ,56:3c:c0:b3:2e:b0)
-> Print("SERVER out")
-> sc_tee::Tee()
-> th::ToHost(tap0);

Idle() -> [1]server_lwip[1] -> Discard();

sc_tee[1] -> td::ToDump("ip.dump");
cs_tee[1] -> td;

arp_clf[1]
  -> Print("Arp-In", TIMESTAMP true)
  -> ar :: ARPResponder(192.168.10.2 192.168.10.0/24 56:3c:c0:b3:2e:b1)
  -> Print("Arp-out", TIMESTAMP true)
  -> th;

Script(
  write rbe1.active false,
  write rbe2.active false,
  wait 1,
//  write client_lwip.add_flow 192.168.2.2 12345 30000,
//  write client_lwip.add_flow 192.168.2.2 12345 50000
);

Script( wait 10,  stop);