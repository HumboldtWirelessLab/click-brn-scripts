gps::GPS();
seismo::Seismo(GPS gps, PRINT true, CALCSTATS false, DEBUG 4);

FromDump("data.dump"/*,STOP true, TIMING true*/)
-> BRN2EtherDecap()
-> q::Queue(15000)
-> RatedUnqueue(10)
-> t::Tee()
-> sup::Suppressor()
-> [1]seismo;

t[1] -> q;

Idle
-> [0]seismo;

Script(
  write sup.active0 false,
  wait 2,
  write sup.active0 true
);

ControlSocket(tcp, 7777);

