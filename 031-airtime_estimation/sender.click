#define DEBUGLEVEL 2
#define CST cst

#include "brn/brn.click"
#include "device/rawwifidev.click"

BRNAddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

rawdevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

rawdevice
  -> BRN2PrintWifi("Feedback", TIMESTAMP true)
  -> Discard;

rate::SetTXRate(RATE 22, TRIES 3)
-> wifioutq::NotifierQueue(50)
-> rawdevice;

Idle()
  -> sf::BRN2SimpleFlow(EXTRADATA "sf1", DEBUG 2)
  -> BRN2EtherEncap(USEANNO true)
  -> SetTimestamp()
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> WifiSeq()
  -> Discard;
//  -> rate;

Idle()
  -> sf2::BRN2SimpleFlow(EXTRADATA "sf2", DEBUG 2)
  -> BRN2EtherEncap(USEANNO true)
  -> SetTimestamp()
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> WifiSeq()
//  -> Discard;
  -> rate;

Script(
 write sf.add_flow 00:00:00:00:00:01 ff:ff:ff:ff:ff:ff 30 1500 0 7000 true 1 0,
 write sf2.add_flow 00:00:00:00:00:01 00:00:00:00:00:02 30 1500 0 7000 true 1 0,
 wait 3,
 read rawdevice/cst.stats,
 wait 3,
 read rawdevice/cst.stats
);
  
  