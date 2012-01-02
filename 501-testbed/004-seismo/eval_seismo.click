gps::GPS();
seismo::Seismo(GPS gps, PRINT true, CALCSTATS true, RECORD true, SHORTTAGS true, DEBUG 4);

//FromDump("data.dump",STOP true,TIMING true)
//-> BRN2EtherDecap()
Idle
-> [1]seismo;

//Idle
FromDump("seismo175.seismo.dump",STOP true, TIMING true)
-> [0]seismo;

//seismoreport::SeismoReporting(SEISMO seismo, INTERVAL 500, LONGAVG 500, SHORTAVG 20, MAXALARM 15, DEBUG 2)


Script(
  wait 1,
  //read seismo.channelinfo,
  //read seismo.channelinfostats
  //read seismo.shorttag,
  read seismo.localchannelinfo,
  // wait 1,
  // write seismo.shorttag false,
  // read seismo.localchannelinfo
  loop
);

/*Script(
  wait 86,
  read seismoreport.stats,
  wait 2,
  read seismoreport.stats,
  wait 2,
  read seismoreport.stats,
  wait 2,
  read seismoreport.stats,
  wait 2,
  read seismoreport.stats,
  wait 2,
  read seismoreport.stats,
  wait 2,
  read seismoreport.stats,
  wait 40,
  read seismoreport.stats,
  read seismoreport.alarm,
  wait 1,
  stop
);*/

Script(
  wait 15,
  stop
);
