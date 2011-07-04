rates::AvailableRates(DEFAULT 2 4 11 12 18 22 24 36 48 72 96 108);
brnrates::BrnAvailableRates(DEFAULT 2 4 11 12 18 22 24 36 48 72 96 108 HT20 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 HT20_SGI 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 HT40 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 HT40_SGI 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15);

//brnrs::BrnMadwifiRate(DEBUG 4);
brnrs::BrnAutoRateFallback();

//rs::MadwifiRate(RT rates);
//rs::AutoRateFallback(RT rates);
//rs::ProbeTXRate(RT rates, WINDOW 12);

rs::SetTXPowerRate(RT brnrates, MAXPOWER 16, RATESELECTION brnrs);

//rs::SetTXRates(RATE0 72, TRIES0 1, RATE1 36, TRIES1 1, RATE2 22, TRIES2 1, RATE3 2, TRIES3 1)

ps::BRN2PacketSource(SIZE 118, INTERVAL 100, MAXSEQ 500000, BURST 1, ACTIVE true)
-> EtherEncap(0x8086, 00:00:00:00:00:01, 00:00:00:00:00:02)
-> WifiEncap(0x00, 0:0:0:0:0:0)
-> rs
-> SetTXPower(7)
//-> wifioutq::NotifierQueue(1000)
-> SimDevice(DEVNAME "NODEDEVICE", EMPERICAL_FILE "empirical/empirical_27_2.txt")
-> BRN2PrintWifi()
-> [1]rs[1]
-> Discard;

Script(
  wait 5,
  read rs.info,
  read brnrates.rates,
  read rs.rates,
  stop
);
