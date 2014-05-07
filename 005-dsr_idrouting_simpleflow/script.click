
Script(
  wait 100,
  read lt.links,
  wait 1,
  read sf.stats,
  wait 1,
  read routing/routing/ridc.cache
);

Script(
#ifdef ENABLE_DSR_DEBUG
  write routing/routing/querier.debug 4,
  write routing/routing/req_forwarder.debug 4,
  write routing/routing/rep_forwarder.debug 4,
#endif
);
