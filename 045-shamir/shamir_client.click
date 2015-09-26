//#define RAWDUMP
//#define RAWDEV_DEBUG
#define LINKSTAT_ENABLE
//#define DEBUG_DSR

#define DISABLE_FLOODING_LINKTABLE

#include "brn/helper.inc"
#include "brn/brn.click"

#include "device/wifidev_client.click"
#include "routing/broadcast.click"

// Device info elements
AddressInfo(deviceaddress eth0:eth);
wireless:: BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");
wifidev:: WIFIDEV_CLIENT(DEVICENAME "eth0", DEVICE wireless, ETHERADDRESS deviceaddress, SSID "brn", ACTIVESCAN false);
id:: BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

// Device and routing elements
lt:: Brn2LinkTable(NODEIDENTITY id, STALE 500, DEBUG 2);

bc:: BROADCAST(ID id, LT lt);

// Application layer
shamir_client          :: ShamirClient(ETHERADDRESS deviceaddress, THRESHOLD 3);

// Outbound flow: broadcast the request
shamir_client
    -> BRN2EtherEncap(USEANNO true)
    -> [0]bc;

bc[1]
    ->[0]wifidev;


// Inbound flow: receive the replies
wifidev
    -> Label_brnether::Null()
    -> BRN2EtherDecap(USEANNO true)
    -> shamir_client;

/* Disable unnecessary in- and outputs */
Idle
    -> [1]bc;
Idle
    -> [2]bc;
Idle
    -> [3]bc;
Idle
    -> [4]bc;

bc[0]
    -> Discard;
