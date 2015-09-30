arp_tab :: ARPTable();

FromHost(tap0)
-> arp::Classifier(12/0806,
                   12/0800)
-> Print()
-> ar::ARPResponder(192.168.10.0/24 01:02:03:04:05:06) //192.168.10.2
-> th::ToHost(tap0);


arp[1]                                                 //handle ip-packets
-> CheckIPHeader(OFFSET 14, VERBOSE true)
-> MarkIPHeader(OFFSET 14)
-> IPPrint()
-> ipf::IPClassifier( dst 192.168.10.0/24)             //192.168.10.2 (ip-range 192.168.10.0/24 or fix ip)
-> IPClassifier(icmp echo)                             //icmp
-> StoreIPEthernet(arp_tab)                            //store all ip-mac-pairs
-> Strip(14)
-> CheckIPHeader(OFFSET 0)
-> ICMPPingResponder()
-> CheckIPHeader(0)
-> resolve :: ResolveEthernet(01:02:03:04:05:06, arp_tab)
-> th;

//-> Discard;
