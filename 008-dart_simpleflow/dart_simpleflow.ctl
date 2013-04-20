#TIME   NODE(S)         DEVICE  MODE    ELEMENT                            HANDLER         VALUE
35      FIRSTNODE       ath0    write   dht/dhtrouting/dhtroutemaintenance activestart     true
80      FIRSTNODE       ath0    write   sf                                 add_flow        FIRSTNODE:eth LASTNODE:eth 1000 400 2 10000 true
