Idle() ->
ps::BRN2PacketSource(SIZE 1460, INTERVAL 100, MAXSEQ 0, BURST 1, PACKETCOUNT 2, ACTIVE true, DEBUG 4)
  -> ee::EtherEncap(0x8086, 00:00:00:00:00:02, 00:00:00:00:00:01)
  -> SetTimestamp()
  -> Print("Send", TIMESTAMP true)
  -> FloodingEnd2EndRetry(DEFAULTRETRIES 10, DEFAULTTIMEOUT 100, TIMETOLERANCE 10, DEBUG 4)
  -> Print("Retry", TIMESTAMP true)
  -> Discard;

BRN2PacketSource(SIZE 100, INTERVAL 100, MAXSEQ 1000, BURST 1, PACKETCOUNT 3, ACTIVE true, DEBUG 4)
-> ee;

Script(
  wait 10,
  stop
);