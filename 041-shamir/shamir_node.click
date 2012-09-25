//#define RAWDUMP
//#define RAWDEV_DEBUG
#define LINKSTAT_ENABLE
//#define DEBUG_DSR

#include "brn/helper.inc"
#include "brn/brn.click"

#include "device/wifidev_client.click"
#include "routing/broadcast.click"

// Device info elements
BRNAddressInfo(deviceaddress eth0:eth);
wireless		:: BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");
wifidev		    :: WIFIDEV_CLIENT(DEVICENAME "eth0", DEVICE wireless, ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");
id				:: BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

// Device and routing elements
lt				:: Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);
bc              :: BROADCAST(ID id, LT lt)

// Application layer
client          :: ShamirClient(ETHERADDRESS deviceaddressm, THRESHOLD 3);

// Outbound flow: broadcast the request
client
    -> BRN2EtherEncap(USEANNO true)
    -> [0]bc

bc[1]
    ->[0]wifidev


// Inbound flow: receive the replies
wifidev
    -> Label_brnether::Null()
    -> BRN2EtherDecap(USEANNO true)
    -> client
