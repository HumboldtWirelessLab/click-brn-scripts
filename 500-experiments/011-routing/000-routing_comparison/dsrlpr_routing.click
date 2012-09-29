#include "routing/dsr.click"

lpr::LPRLinkProbeHandler(LINKSTAT device_wifi/link_stat, METRIC device_wifi/etx_metric);

routing::DSR(id,lt,rc,device_wifi/etx_metric);
#define ROUTINGPORT BRN_PORT_DSR
