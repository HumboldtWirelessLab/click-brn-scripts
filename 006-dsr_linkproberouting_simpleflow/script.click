Script(
  wait 120,
  read lt.links,
  wait 1,
  read sf.stats
);

Script(
#ifdef ENABLE_DSR_DEBUG
  write routing/routing/querier.debug 4,
  write routing/routing/req_forwarder.debug 4,
  write routing/routing/rep_forwarder.debug 4,
#endif
);
