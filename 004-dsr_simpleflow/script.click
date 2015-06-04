Script(
#ifdef ENABLE_DSR_DEBUG
  write routing/routing/querier.debug 4,
  write routing/routing/req_forwarder.debug 4,
  write routing/routing/rep_forwarder.debug 4,
  write routing/routing/err_forwarder.debug 4,
#endif
  write routing/routing/feedback_handler.debug 4,
  wait 100,
  read lt.links,
//read device_wifi/link_stat.bcast_stats,
  wait 10,
  read routing/routingtable.stats,
  wait 18,
  read routing/routingalgo.stats,
  read routing/routingmaint.stats,
  wait 1,
  read routing/routing/dsr_stats.stats
);

