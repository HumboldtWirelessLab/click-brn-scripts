AddressInfo(my_wlan NODEDEVICE:eth);

FROMRAWDEVICE(NODEDEVICE)
    -> td :: TODUMP("RESULTDIR/NODENAME.NODEDEVICE.dump");
