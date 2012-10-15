gps::GPS();
seismo::Seismo(GPS gps, PRINT false, RECORD true, SHORTTAGS true, DEBUG 2);

longshortavg::SeismoDetectionLongShortAvg(LONGAVG 100, SHORTAVG 10, MAXALARM 15, DEBUG 4);
seismoreport::SeismoReporting(SEISMO seismo, ALGORITHMS longshortavg, INTERVAL 500, DEBUG 2)

//FromDump("data.dump",STOP true,TIMING true)
//-> BRN2EtherDecap()
Idle
-> [1]seismo;

//Idle
FromDump("seismo175.seismo.dump",STOP true, TIMING true)
-> [0]seismo;

/*Script(
  wait 1,
  //read seismo.channelinfo,
  //read seismo.channelinfostats
  //read seismo.shorttag,
  read seismo.localchannelinfo,
  // wait 1,
  // write seismo.shorttag false,
  // read seismo.localchannelinfo
  loop
);*/

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
  wait 4,
  read longshortavg.stats,
  stop
);
