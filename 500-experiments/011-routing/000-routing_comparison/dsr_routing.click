#include "routing/dsr.click"

routing::DSR(id,lt,rc,device_wifi/etx_metric);
#define ROUTINGPORT BRN_PORT_DSR

Script(
  wait 219,
  read routing/dsr_stats.stats,
  write routing/dsr_stats.reset,
  read routing/dsr_stats.stats
);
