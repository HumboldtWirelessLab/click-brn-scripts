#include "routing/geor.click"

routing::GEOR(id, lt, device_wifi/link_stat); 

Script(
  write routing/gps.cart_coord NODEPOSITIONX NODEPOSITIONY NODEPOSITIONZ,
  write routing/grt.add 00:00:00:00:00:01 0 0 0,
  wait 219,
  read routing/grt.table
);

#define ROUTINGPORT BRN_PORT_GEOROUTING
