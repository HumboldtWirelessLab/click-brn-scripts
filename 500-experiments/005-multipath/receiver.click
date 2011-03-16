#define NOPCAP

#include "brn/helper.inc"

FROMRAWDEVICE(NODEDEVICE)
  -> tdraw :: ToDump("RESULTDIR/NODENAME.NODEDEVICE.dump");
