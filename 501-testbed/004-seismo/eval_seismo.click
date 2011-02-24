gps::GPS();
seismo::Seismo(GPS gps, PRINT true, CALCSTATS false, DEBUG 4);

FromDump("data.dump",STOP true)
-> BRN2EtherDecap()
-> [1]seismo;

Idle
-> [0]seismo;