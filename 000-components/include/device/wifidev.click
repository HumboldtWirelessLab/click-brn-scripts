//output:
//  0: To me and BRN
//  1: Broadcast and BRN
//  2: Foreign and BRN
//  3: To me and NO BRN
//  4: BROADCAST and NO BRN
//  5: Foreign and NO BRN
//  6: Feedback BRN
//  7: Feedback Other
//
//input::
//  0: brn
//  1: client

elementclass WIFIDEV { DEVNAME $devname, DEVICE $device, ETHERADDRESS $etheraddress, LT $lt |

  nblist::BRN2NBList();  //stores all neighbors (known (friend) and unknown (foreign))
  nbdetect::NeighborDetect(NBLIST nblist, DEVICE $device);
  rates::AvailableRates(DEFAULT 2 4 11 12 18 22 24 36 48 72 96 108);
  proberates::AvailableRates(DEFAULT 2 22);
  etx_metric :: BRN2ETXMetric($lt);
  
  link_stat :: BRN2LinkStat(ETHTYPE          0x0a04,
                            DEVICE          $device,
                            PERIOD             3000,
                            TAU               30000,
                            ETX          etx_metric,
//                          PROBES  "2 250 22 1000",
                            PROBES  "2 250",
                            RT           proberates);
                            
   
  brnToMe::BRN2ToThisNode(NODEIDENTITY id);
  rawdevice::RAWDEV(DEVNAME $devname);


  input[0] 
  -> brnwifi::WifiEncap(0x00, 0:0:0:0:0:0)
  -> wifioutq::NotifierQueue(50)
  -> rawdevice
  -> wififrame_clf :: Classifier( 0/00%0f,  // management frames
                                      - ); 

  wififrame_clf[0]
	-> Discard;

  wififrame_clf[1]
    -> WifiDecap()
    -> nbdetect
    //-> Print("Data")
    -> brn_ether_clf :: Classifier( 12/8086, - )
    -> lp_clf :: Classifier( 14/06, - )
    -> BRN2EtherDecap()
    -> link_stat
    -> EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
    -> brnwifi;
 
  brn_ether_clf[1]                         //no brn
  -> Discard;
    
  lp_clf[1]                               //brn, but no lp
//-> Print("Data, no LP")
  -> brnToMe;
  
  brnToMe[0] -> /*Print("wifi0") ->*/ [0]output;
  brnToMe[1] -> /*Print("wifi1") ->*/ [1]output;
  brnToMe[2] -> /*Print("wifi2") ->*/ [2]output;

  input[1] -> Discard;
  
} 

