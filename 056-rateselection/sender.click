#define DEBUGLEVEL 2

#define CST cst
#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

#define RAWDUMP

#include "brn/helper.inc"
#include "brn/brn.click"
#include "device/rawwifidev.click"

rates::BrnAvailableRates(DEFAULT 2 4 11 12 18 22);

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS", WIRELESSCONFIG "rates", DEBUG 4);

wifidevice::RAWWIFIDEV(DEVNAME NODEDEVICE, DEVICE wireless);

id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);


rs_madwifi::BrnMadwifiRate();
rs_arf::BrnAutoRateFallback();
rs_fix::BrnFixRate();
rs_rr::BrnRoundRobinRate();
rs_minstrel::BrnMinstrelRate();

ratesel::SetTXPowerRate( RATESELECTIONS "rs_arf rs_madwifi rs_fix rs_rr rs_minstrel", STRATEGY 4, RT rates);

Idle()
  -> sf::BRN2SimpleFlow(DEBUG 2)
  -> BRN2EtherEncap(USEANNO true)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> [0]ratesel[0]
  -> SetTXPower(24)
  -> wifioutq::NotifierQueue(10)
  -> SetTimestamp()
  -> BRN2PrintWifi("Sender (NODENAME)", TIMESTAMP true)
  -> wifidevice
  -> filter_tx :: FilterTX()
  -> error_clf :: WifiErrorClassifier()
  -> BRN2PrintWifi("OKPacket", TIMESTAMP true)
  -> discard::Discard;

error_clf[1]
  -> BRN2PrintWifi("CRCerror", TIMESTAMP true)
  -> discard;

error_clf[2]
  -> BRN2PrintWifi("PHYerror", TIMESTAMP true)
  -> discard;

error_clf[3]
  -> BRN2PrintWifi("FIFOerror", TIMESTAMP true)
  -> discard;

error_clf[4]
  -> BRN2PrintWifi("DECRYPTerror", TIMESTAMP true)
  -> discard;

error_clf[5]
  -> BRN2PrintWifi("MICerror", TIMESTAMP true)
  -> discard;

error_clf[6]
  -> BRN2PrintWifi("ZEROerror", TIMESTAMP true)
  -> discard;

error_clf[7]
  -> BRN2PrintWifi("UNKNOWNerror", TIMESTAMP true)
  -> discard;

filter_tx[1]
  -> BRN2PrintWifi("TXFeedback", TIMESTAMP true)
  -> [1]ratesel[1]
  -> discard;

Script(
  write rates.insert 00-00-00-00-00-01 2 4 11 12 18 22,
  write rates.insert 00-00-00-00-00-02 2 4 11 12 18 22,
  wait 1,
  read rates.rates,
  read ratesel.info
);


Script(
  write sf.add_flow 00:00:00:00:00:02 00:00:00:00:00:01 12 1500 0 5000 true 1 0,
  wait 5,
  read sys_info.systeminfo,
  read id.version,
  read wireless.deviceinfo,
  read wifidevice/cst.stats,
  read rates.rates
);
