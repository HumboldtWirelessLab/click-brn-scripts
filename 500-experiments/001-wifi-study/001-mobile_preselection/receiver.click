gps::GPS();

#define CST_PROCFILE "/proc/net/madwifi/NODEDEVICE/channel_utility"

AddressInfo(deviceaddress NODEDEVICE:eth);
wireless::BRN2Device(DEVICENAME "NODEDEVICE", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");
id::BRN2NodeIdentity(NAME NODENAME, DEVICES wireless);

FROMRAWDEVICE(NODEDEVICE)
    -> tocst::Tee()
    -> GPSEncap(GPS gps)
    -> td :: ToDump("RESULTDIR/NODENAME.NODEDEVICE.dump");

tocst[1]
  -> __WIFIDECAP__
  -> cst::ChannelStats(DEVICE wireless, STATS_DURATION 1000, PROCFILE CST_PROCFILE, PROCINTERVAL 1000, RSSI_PER_NEIGHBOUR true, FULL_STATS false, SAVE_DURATION 1000 )
  -> Discard;

SYNC
 -> td;
