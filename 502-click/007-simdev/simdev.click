rates::AvailableRates(DEFAULT 2 4 11 12 18 22 24 36 48 72 96 108);
brnrates::BrnAvailableRates(DEFAULT 2 4 11 12 18 22 24 36 48 72 96 108 );
// HT20 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 /*HT20_SGI 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15*/ HT40 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 HT40_SGI 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15);

rs_fix::BrnFixRate(RATE0 2, TRIES0 1, TRIES1 0, TRIES2 0, TRIES3 0); //1
rs_minstrel::BrnMinstrelRate(DEBUG 2);                               //2
rs_madwifi::BrnMadwifiRate(PERIOD 55, DEBUG 2);                      //3
rs_autorate::BrnAutoRateFallback();                                  //4

rs::SetTXPowerRate(RATESELECTIONS "rs_madwifi rs_autorate rs_fix rs_minstrel", STRATEGY 4, RT brnrates, POWER 24, OFFSET 0, STATSINTERVAL 100, DEBUG 4);

//rs::MadwifiRate(RT rates);
//rs::AutoRateFallback(RT rates);
//rs::ProbeTXRate(RT rates, WINDOW 12);

Idle()
-> sf::BRN2SimpleFlow(FLOW "00:00:00:00:00:01 00:00:00:00:00:02 5 150 0 2000 true 1 0", DEBUG 2)  //VAR_RATE VAR_PSIZE
-> EtherEncap(0x8086, 00:00:00:00:00:01, 00:00:00:00:00:02)
-> WifiEncap(0x00, 0:0:0:0:0:0)
-> rs
//-> wifioutq::NotifierQueue(1000)
-> sd::SimDevice(DEVNAME "NODEDEVICE", EMPERICAL_FILE "empirical/empirical_5_2.txt")
-> BRN2PrintWifi(PRINTUSEDRATE true, TIMESTAMP true)
-> [1]rs[1]
-> Discard;

Script(
  wait 2,
  read rs.info,
//  read brnrates.rates,
//  read rs.rates,
  read sd.psr,
//  stop
);
