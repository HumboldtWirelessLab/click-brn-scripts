gpsmap::GPSMap()

gps::GPS(GPSMAP gpsmap);


Script(
  write gps.gps_coord 17.18 19.20,
  write gpsmap.insert 00:00:00:01:02:03 52.3334 13.434 12.0,
  write gpsmap.insert 00:00:01:02:03:04 41.5287 14.54,
  write gpsmap.insert 00:00:00:00:05:05 11.5287 33.54,
  read gpsmap.map,
  stop
);
