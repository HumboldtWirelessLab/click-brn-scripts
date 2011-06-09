rates::BrnAvailableRates(DEFAULT 2 4 11 12 18 22 24 36 48 72 96 108 HT20 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 HT20_SGI 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 HT40 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 HT40_SGI 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15);

Script(
  wait 1,
  read rates.rates,
  stop
);
