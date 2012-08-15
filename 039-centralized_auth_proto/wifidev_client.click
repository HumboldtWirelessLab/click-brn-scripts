#include "wifi/adhoc_or_infrastructure_client.click"
#include "device/wep_painted.click"

//output:
//  0: Unicast/broadcast
//  1: to underlying layer
//
//input::
//  0: Unicast/broadcast
//  1: from underlying layer

elementclass WIFIDEV_CLIENT { DEVICE $device,
                              ETHERADDRESS $etheraddress,
                              SSID $ssid,
                              ACTIVESCAN $active |

  auth_info :: WirelessInfo(SSID $ssid, BSSID 00:00:00:00:00:00 , CHANNEL 5);
  infra_wifiencap ::  WifiEncap(0x01, WIRELESS_INFO auth_info);


  client::ADHOC_OR_INFRASTRUCTURE_CLIENT(DEVICE $device, ETHERADDRESS $etheraddress, SSID $ssid,
                                         CHANNEL 5, WIFIENCAP infra_wifiencap, WIRELESS_INFO auth_info, ACTIVESCAN $active);

  
  wifioutq::NotifierQueue(50);

  input[1]
  -> filter_tx :: FilterTX()
#ifndef DISABLE_WIFIDUBFILTER
  -> WifiDupeFilter()
#endif
  //-> Print("Client Raw", TIMESTAMP true)

  -> wififrame_clf :: Classifier( 0/00%0f,  // management frames
                                  1/02%03,  //fromds
                                      - ); 


  wififrame_clf[0]
    -> client
    -> wifioutq
    -> [1]output;

  wififrame_clf[1]
  	//-> Print("Client 2")
    -> WifiDecap()
    -> toMe::BRN2ToThisNode(NODEADDRESS $etheraddress)
    -> [0]output; 

  toMe[1]         //broadcast 
  	-> [0]output; 
  
  toMe[2] -> Discard;

  wififrame_clf[2]
  	//-> Print("Client Discard!!")
    -> Discard;

  input[0]
    -> infra_wifiencap
    -> wifioutq;
  
} 
