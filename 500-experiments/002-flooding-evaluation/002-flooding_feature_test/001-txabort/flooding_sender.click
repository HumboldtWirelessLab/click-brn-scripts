




elementclass RAWDEV { DEVNAME $devname, DEVICE $device |

  input[0]
  -> rawdev_suppressor::Suppressor()




  -> pullstats::PullStats()
  -> todev::ToSimDevice($devname, ENCAP UNKNOWN, POLLING false, HAVETXFEEDBACKANNO true );



  fromdev::FromSimDevice($devname, SNAPLEN 8190, HEADROOM 192, ZEROCOPY true)





  -> SetTimestamp()
  -> BRN2SetDeviceAnno(DEVICE $device)
  -> [0]output;
}
elementclass RAWWIFIDEV { DEVNAME $devname, DEVICE $device |



  cst::ChannelStats(DEVICE $device, STATS_DURATION 1000, PROCFILE /simulation, PROCINTERVAL 1000, NEIGHBOUR_STATS true, FULL_STATS false, SAVE_DURATION 1000 );
  hnd::HiddenNodeDetection(DEVICE $device, TIMEOUT 1000, COOPCHANNELSTATSPATH "device_wifi/cocst", DEBUG 2);
  rawdev::RAWDEV(DEVNAME $devname, DEVICE $device);



  bo_maxtp::BoMaxThroughput(CHANNELSTATS cst, OFFSET -50, DEBUG 2);

  bo_cla::BoChannelLoadAware(CHANNELSTATS cst, TARGETLOAD 90, TARGETDIFF 0, CAP 1, CST_SYNC 1, DEBUG 4);

  bo_targetpl::BoTargetPacketloss(CHANNELSTATS cst, TARGETPL 10, DEBUG 2);

  bo_nbs::BoNeighbours(CHANNELSTATS cst, ALPHA 500 , BETA 200 , DEBUG 2);

  bo_learning::BoLearning(MIN_CWMIN 32, MAX_CWMIN 1024, STRICT 1, CAP 1, DEBUG 2);





  bo_const::BoConstant(BO 32, DEBUG 2);

  bo_minstrel::BoMinstrel(DEBUG 2);


  bo_mshare::BoMediumShare(CHANNELSTATS cst, COOPCHANNELSTATSPATH "device_wifi/cocst", HIDDENNODE hnd, BO 32, DEBUG 2);
  input[0]

  -> WifiSeq()
  -> tosq::Tos2QueueMapper( DEVICE $device, STRATEGY 1, BO_SCHEMES "bo_maxtp bo_cla bo_targetpl bo_learning bo_nbs bo_const bo_minstrel bo_mshare",



                            MAC_BO_SCHEME 0,
                            QUEUEMODE 0, QUEUEVAL 1,
                            CWMINMAXMODE 0, CWMINMAXVAL 7,
                            QUEUEMAPPING 0, DEBUG 2)
  -> ExtraEncap()
  -> rawdev;

  rawdev
  -> dev_decap::ExtraDecap()

  -> cst
  -> hnd



  -> Tos2QueueMapperTXFeedback(TOS2QM tosq, DEBUG 2)



  -> ForeignRxStats(DEVICE $device,TIMEOUT 15, DEBUG 2)

  -> [0]output;
}
elementclass WIFIDEV { DEVNAME $devname, DEVICE $device, ETHERADDRESS $etheraddress, LT $lt |

  availablerates::BrnAvailableRates(DEFAULT 2 4 11 22 12 18 24 36 48 72 96 108);
  etx_metric :: BRN2ETXMetric($lt);

  link_stat :: BRN2LinkStat(DEVICE $device,

                            PERIOD 2000,




                            TAU 100000,




                            PROBES "2 200 24 2 200 23 11 200 24 11 200 23",



                            RT availablerates,

                            METRIC "etx_metric",
                            DEBUG 0 );





  brnToMe::BRN2ToThisNode(NODEIDENTITY id);
  wifidevice::RAWWIFIDEV(DEVNAME $devname, DEVICE $device);

  input[0]



  -> data_power::SetTXPower(POWER 24)

  -> data_rate::SetTXRate(RATE 2, TRIES 4)
  -> brnwifi::WifiEncap(0x00, 0:0:0:0:0:0)




  -> data_queue::NotifierQueue(100)



  -> data_suppressor::Suppressor()
  -> [1]lp_data_scheduler::PrioSched()

  -> [2]x_prio_q::PrioSched()





  -> wifidevice



  -> filter_tx :: FilterTX()



  -> error_clf :: FilterPhyErr()



  -> bcast_clf::Classifier(30/80860c0c,
                           - );

  bcast_clf[1]

  -> WifiDupeFilter()

  -> bcast_dup::Null();

  bcast_clf[0]
  -> bcast_dup


  -> wififrame_clf :: Classifier( 1/40%40,
                                  0/00%0f,
                                      - );

  filter_tx[1]





  -> WifiDecap()
  -> ig_feedback_clf :: Classifier( 12/8888, - );

  ig_feedback_clf[1]






  -> txfb_brn_clf :: Classifier( 12/8086, - )
  -> brnfb_lsclf :: Classifier( 14/01, - )
  -> Discard;

  brnfb_lsclf[1]
  -> [3]output;

  txfb_brn_clf[1]

  -> Discard;

  wififrame_clf[0]
    -> Discard;

  wififrame_clf[1]
    -> Discard;

  wififrame_clf[2]




    -> WifiDecap()

    -> brn_ether_clf :: Classifier( 12/8086, - )
    -> lp_clf :: Classifier( 14/01, - )







    -> BRN2EtherDecap()

    -> link_stat

    -> lp_etherencap::EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
    -> lp_wifiencap::WifiEncap(0x00, 0:0:0:0:0:0)
    -> lp_queue::FrontDropQueue(2)
    -> lp_suppressor::Suppressor()
    -> [0]lp_data_scheduler;

  brn_ether_clf[1]

  -> Discard;

  lp_clf[1]


  -> co_cst_clf :: Classifier( 14/3c, - );

  co_cst_clf[1]



  -> [1]data_suppressor[1]
  -> brnToMe;



  co_cst_clf[0]

  -> BRN2EtherDecap()
  -> BRN2Decap()
  -> cocst::CooperativeChannelStats(CHANNELSTATS wifidevice/cst, NEIGHBOURS true, INTERVAL 1000, DEBUG 2)
  -> cocst_etherencap::EtherEncap(0x8086, deviceaddress, ff:ff:ff:ff:ff:ff)
  -> cocst_rate::SetTXRate(RATE 2, TRIES 1)
  -> brnwifi;



  brnToMe[0] -> [0]output;
  brnToMe[1] -> [1]output;
  brnToMe[2] -> [2]output;

  input[1] -> Discard;



  input[2]

  -> x_brnwifi::WifiEncap(0x00, 0:0:0:0:0:0)
  -> [1]x_prio_q;

  Idle()
  -> ig_flow::BRN2SimpleFlow(EXTRADATA "Interferenzgraph", ELEMENTID 255, DEBUG 2);

  ig_feedback_clf[0]
  -> BRN2EtherDecap()
  -> Classifier( 0/34 )
  -> BRN2Decap()
  -> [1]ig_flow
  -> Print("packet")
  -> EtherEncap(0x8888, $etheraddress, ff:ff:ff:ff:ff:ff)
  -> WifiEncap(0x00, 0:0:0:0:0:0)
  -> ig_rate :: SetTXRate(2)



  -> ig_power :: SetTXPower(POWER 48)

  -> SetTimestamp()
  -> ig_notifierqueue::NotifierQueue(500)
  -> ig_suppressor::Suppressor()


  -> [0]x_prio_q;



  error_clf[1]

  -> PrintCRCError(LABEL "CRC")


  -> Discard;

  link_stat[1]
  -> Print("Linkstat error",200)
  -> Discard;





}
elementclass BROADCASTFLOODING {ID $id, LT $lt, LINKSTAT $linkstat |


  fl_database::FloodingDB(DEBUG 2);




  fl_lt::Brn2LinkTable(NODEIDENTITY $id, STALE 500, DEBUG 2);




  fl_linktable::FloodingLinktable(LINKSTAT $linkstat, ETXLINKTABLE $lt, LOCALTABLE fl_lt, MODE 7, DEBUG 2);


  fl_prenegotiation::FloodingPrenegotiation(LINKSTAT $linkstat, LINKTABLE fl_lt, FLOODINGDB fl_database, DEBUG 2);


  fl_helper::FloodingHelper(LINKTABLE fl_linktable, MAXNBMETRIC 8000, CACHETIMEOUT 5000000, DEBUG 2);
  flp_prob::ProbabilityFlooding(NODEIDENTITY $id, FLOODINGHELPER fl_helper, FLOODINGDB fl_database, MINNEIGHBOURS 3, FWDPROBALILITY 90, DEBUG 2);





  flp_mpr::MPRFlooding(NODEIDENTITY $id, FLOODINGHELPER fl_helper, FLOODINGDB fl_database, MAXNBMETRIC 500, MPRUPDATEINTERVAL 10000, DEBUG 2);
  ovl::OverlayStructure(NODEIDENTITY $id, OVERLAYFILE "", DEBUG 2);
  flp_overlay::OverlayFlooding(NODEIDENTITY $id, OVERLAY_STRUCTURE ovl, OPPORTUNISTIC true, RESPONSABLE4PARENTS false, DEBUG 2);

  flp_simple::SimpleFlooding();
  rdq::RandomDelayQueue(MINDELAY 1, MAXDELAY 150, DIFFDELAY 5, TIMESTAMPANNOS true)

  fl_scheduling::FloodingTxScheduling(NODEIDENTITY $id, FLOODINGHELPER fl_helper, FLOODINGDB fl_database, DEFAULTINTERVAL 150, SCHEDULING 4, DEBUG 2);

  fl_passive_ack::FloodingPassiveAck(NODEIDENTITY $id, FLOODINGHELPER fl_helper, FLOODINGDB fl_database, FLOODINGSCHEDULING fl_scheduling, DEFAULTRETRIES 2, DEFAULTTIMEOUT 1000, ABORTONFINISHED true, DEBUG 2);

  fl::Flooding(NODEIDENTITY $id, FLOODINGPOLICIES "flp_prob flp_mpr flp_overlay flp_simple", FLOODINGSTRATEGY 1, FLOODINGHELPER fl_helper, FLOODINGDB fl_database, FLOODINGPASSIVEACK fl_passive_ack, ABORTTX 31, QUEUE rdq, DEBUG 2);
  unicfl :: UnicastFlooding(NODEIDENTITY $id, FLOODING fl, FLOODINGHELPER fl_helper, FLOODINGDB fl_database, PRESELECTIONSTRATEGY 2, REJECTONEMPTYCS true, CANDSELECTIONSTRATEGY 4, UCASTPEERMETRIC 4, FORCERESPONSIBILITY true, USEASSIGNINFO true, FIXCS true, PDRCONFIG "101 5 115", DEBUG 2);
  fl_piggyback::FloodingPiggyback(NODEIDENTITY $id, FLOODING fl, FLOODINGHELPER fl_helper, FLOODINGDB fl_database, LASTNODESPERPKT 20, DEBUG 2);

  routing_peek::FloodingRoutingPeek(DEBUG 2);

  input[0]
  -> e2eretry::FloodingEnd2EndRetry(DEFAULTRETRIES 0, DEFAULTTIMEOUT 100, TIMETOLERANCE 20, DEBUG 2)
  -> [0]fl;

  input[1]

  -> routing_peek
  -> BRN2Decap()
  -> [1]fl;

  input[2]
  -> BRN2Decap()
  -> [2]fl;

  fl[0]
  -> [0]output;

  fl[1]
  -> rdq

  -> FrontDropQueue(100)

  -> unicfl
  -> fl_piggyback
  -> setsrc::BRN2SetSrcForNeighbor(LINKTABLE $lt, USEANNO true)
  -> BroadcastMultiplexer(NODEIDENTITY $id, USEANNO true)
  -> BRN2EtherEncap(USEANNO true)



  -> [1]output;

  input[3]

  -> [1]routing_peek[1]
  -> BRN2Decap()
  -> [4]fl;

  input[4]

  -> BRN2Decap()
  -> [3]fl;

  unicfl[1]
  -> BRN2Decap()
  -> [5]fl;

  setsrc[1]
  -> BRN2EtherEncap(USEANNO true)
  -> Print("No Src for Dst",100)
  -> Discard;





}

AddressInfo(deviceaddress eth0:eth);
wireless::BRN2Device(DEVICENAME "eth0", ETHERADDRESS deviceaddress, DEVICETYPE "WIRELESS");

id::BRN2NodeIdentity(NAME auto, DEVICES wireless);

lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);




pdr_lt::Brn2LinkTable(NODEIDENTITY id, STALE 500);
pdr_metric :: BRNPDRMetric(pdr_lt);

device_wifi::WIFIDEV(DEVNAME eth0, DEVICE wireless, ETHERADDRESS deviceaddress, LT lt);

flooding::BROADCASTFLOODING(ID id, LT lt, LINKSTAT device_wifi/link_stat);

sys_info::SystemInfo(NODEIDENTITY id, CPUTIMERINTERVAL 1000);

device_wifi
  -> Label_brnether::Null()
  -> BRN2EtherDecap()
  -> brn_clf::Classifier( 0/34,
                             0/0c,
                               - );

device_wifi[1] -> BRN2EtherDecap() -> brn_clf;

Idle -> [1]device_wifi;

brn_clf[0]

  -> BRN2Decap()
  -> sf::BRN2SimpleFlow(HEADROOM 192, ROUTINGPEEK flooding/routing_peek, LINKTABLE lt, DEBUG 2)
  -> BRN2EtherEncap(USEANNO true)
  -> [0]flooding;

brn_clf[2] -> Discard;

rtscts_packetsize::RtsCtsPacketSize(PACKETSIZE 32, PACKETDURATION -1);
rtscts_hiddennode::RtsCtsHiddenNode(HIDDENNODE device_wifi/wifidevice/hnd);
rtscts_flooding::RtsCtsFlooding(FLOODING flooding/fl, FLOODINGHELPER flooding/fl_helper, FLOODINGDB flooding/fl_database, HIDDENNODE device_wifi/wifidevice/hnd, DEBUG 2);

rate_fix::BrnFixRate(RATE0 2, TRIES0 4, TRIES1 0, TRIES2 0, TRIES3 0);
rate_flooding::BrnFloodingRate(FLOODING flooding/fl, FLOODINGHELPER flooding/fl_helper, FLOODINGDB flooding/fl_database, LINKSTAT device_wifi/link_stat, CHANNELSTATS device_wifi/wifidevice/cst, STRATEGY 0, DEFAULTRETRIES 7, DEBUG 2);

rates::BrnAvailableRates(DEFAULT 2 4 11 12 18 22 24 36 48 72 96 108);

brn_clf[1]
  -> [1]flooding[1]
  -> data_rate::SetTXPowerRate(RATESELECTIONS "rate_fix rate_flooding", STRATEGY 5, RT rates, POWER 24, OFFSET -1)
  -> setrtscts::Brn2_SetRTSCTS(RTSCTS_SCHEMES "rtscts_hiddennode rtscts_flooding rtscts_packetsize", STRATEGY 0, MIXEDSTRATEGY 0, HEADER 2, DEBUG 2)
  -> [2]device_wifi;

Idle()
  -> [0]device_wifi;

flooding[0] -> Label_brnether;

device_wifi[2]
  -> BRN2EtherDecap()
  -> foreign_clf::Classifier( 0/0c )
  -> [3]flooding;


device_wifi[3]




  -> BRN2EtherDecap()
  -> Classifier( 0/0c)
  -> ffilter::FilterFailures()
  -> [4]flooding;

ffilter[1] -> [2]flooding;
Script(
  write device_wifi/link_stat.add_metric pdr_metric
);

Script(
  wait 100,
  read lt.links,

  read pdr_lt.links,
  read device_wifi/link_stat.bcast_stats
);

Script(
  wait 120,
  read flooding/fl_linktable.links
 );
Script( wait 130,
  read flooding/fl.stats,
  read flooding/fl_database.forward_table,
  read flooding/unicfl.stats,
  read sf.stats,
  read device_wifi/wifidevice/cst.stats
);
Script(wait 131,






       stop);
Script(wait 110, write  sf.add_flow 00-00-00-00-00-01 FF-FF-FF-FF-FF-FF 1000 100 0 10000 true);
