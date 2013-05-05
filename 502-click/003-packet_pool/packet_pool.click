
ps::BRN2PacketSource(SIZE 1100, INTERVAL 10, MAXSEQ 500000, BURST 1, ACTIVE true)
-> Print()
-> bd::BrnDiscard;

ps2::BRN2PacketSource(SIZE 110, INTERVAL 10, MAXSEQ 500000, BURST 1, ACTIVE true)
-> Print()
-> BrnDiscard;


Script(
  wait 1,
  read bd.packetpool,
  stop
);
