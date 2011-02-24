ControlSocket(tcp, 7777);
src::FromSocket("UDP", 0.0.0.0, 8090);
gps::GPS();
seismo::Seismo(GPS gps, PRINT false, CALCSTATS true, DEBUG 4);
tee::Tee();

src
//-> Print("Data", 308, TIMESTAMP true)
-> tee[0]
-> BRN2EtherDecap()
-> [1]seismo;

Idle
-> [0]seismo;

tee[1]
-> ToDump("data.dump");

//Script(wait 10, read seismo.channelstatinfo );