#
# Set some general simulation parameters
#

#
# Unity gain, omnidirectional antennas, centered 1.5m above each node.
# These values are lifted from the ns-2 sample files.
#
Antenna/OmniAntenna set X_ 0
Antenna/OmniAntenna set Y_ 0
Antenna/OmniAntenna set Z_ 1.5
Antenna/OmniAntenna set Gt_ 1.0
Antenna/OmniAntenna set Gr_ 1.0

#
# Initialize the SharedMedia interface with parameters to make
# it work like the 914MHz Lucent WaveLAN DSSS radio interface
# These are taken directly from the ns-2 sample files.
#

#DSSS (IEEE802.11b)

Phy/WirelessPhy set CPThresh_ 10.0

Phy/WirelessPhy set CSThresh_ 1.559e-11
#1.559e-11 -> -108db

Phy/WirelessPhy set RXThresh_ 3.28984e-09
#3.28984e-09 -> -85db

#Phy/WirelessPhy set Rb_ 2*1e6

Phy/WirelessPhy set Pt_ 0.281838
#Phy/WirelessPhy set Pt_ 0.031622777

Phy/WirelessPhy set freq_ 2.472e9
Phy/WirelessPhy set L_ 1.0
Phy/WirelessPhy set bandwidth_ 1Mb


Mac/802_11 set SlotTime_          0.000020        ;# 20us
Mac/802_11 set SIFS_              0.000010        ;# 10us
Mac/802_11 set PreambleLength_    144             ;# 144 bit
Mac/802_11 set PLCPHeaderLength_  48              ;# 48 bits
Mac/802_11 set PLCPDataRate_      1.0e6           ;# 1Mbps
Mac/802_11 set dataRate_          11.0e6          ;# 11Mbps
Mac/802_11 set basicRate_         1.0e6           ;# 1Mbps

Mac/802_11 set RTSThreshold_ 100
Mac/802_11 set ShortRetryLimit_ 7               ;# retransmittions
Mac/802_11 set LongRetryLimit_  4               ;# retransmissions

################################################################################################

# Propagation model
# first set values of shadowing model
# Propagation/Shadowing set pathlossExp_ 2.0  ;# path loss exponent
Propagation/Shadowing set pathlossExp_ 1.95  ;# path loss exponent
Propagation/Shadowing set std_db_ 0.0       ;# shadowing deviation (dB)
Propagation/Shadowing set dist0_ 1.0        ;# reference distance (m)
Propagation/Shadowing set seed_ 0           ;# seed for RNG

#
# The network channel, physical layer, MAC, propagation model,
# and antenna model are all standard ns-2.
#  
set netchan	Channel/WirelessChannel
set netphy	Phy/WirelessPhy
set netmac	Mac/802_11
set antenna     Antenna/OmniAntenna

#set netprop Propagation/TwoRayGround
set netprop Propagation/Shadowing

#
# Create a network Channel for the nodes to use. One channel
# per LAN. Also set the propagation model to be used.
#
set wiredchan Channel
set wiredphy Phy/WiredPhy
set wiredmac Mac/802_3

##################################################################################

#COLLISIONWINDOWS MIN 31
#MAX 1023

# 
# Set the size of the playing field and the topography.
#
set xsize  500
set ysize  500
set wtopo	[new Topography]
$wtopo load_flatgrid $xsize $ysize

#
# We have to use a special queue and link layer. This is so that
# Click can have control over the network interface packet queue,
# which is vital if we want to play with, e.g. QoS algorithms.
#
set netifq	Queue/ClickQueue
set netll	LL/Ext
LL set delay_			1ms

#
# These are pretty self-explanatory, just the number of nodes
# and when we'll stop.
#

set nodecount   38
set slen	7
set stoptime    100.0

#
# With nsclick, we have to worry about details like which network
# port to use for communication. This sets the default ports to 5000.
#
Agent/Null set sport_		5000
Agent/Null set dport_		5000

Agent/CBR set sport_		5000
Agent/CBR set dport_		5000

#
# Standard ns-2 stuff here - create the simulator object.
#
Simulator set MacTrace_ ON
set ns_		[new Simulator]

#
# Create and activate trace files.
#
set tracefd     [open "simple_sort.tr" w]
set namtrace    [open "simple_sort.nam" w]
$ns_ trace-all $tracefd
$ns_ namtrace-all-wireless $namtrace $xsize $ysize
$ns_ use-newtrace


#
# Create the "god" object. This is another artifact of using
# the mobile node type. We have to have this even though
# we never use it.
#
set god_ [create-god $nodecount]

#
# Tell the simulator to create Click nodes.
#
Simulator set node_factory_ Node/MobileNode/ClickNode

#
# Create a network Channel for the nodes to use. One channel
# per LAN. Also set the propagation model to be used.
#
set chan_1_ [new $netchan]
set prop_ [new $netprop]

#
# In nsclick we have to worry about assigning IP and MAC addresses
# to out network interfaces. Here we generate a list of IP and MAC
# addresses, one per node since we've only got one network interface
# per node in this case. Also note that this scheme only works for
# fewer than 255 nodes, and we aren't worrying about subnet masks.
#
set iptemplate "10.9.0.%d"
set mactemplate "00:0f:00:00:%0x:00"
for {set i 0} {$i < $nodecount} {incr i} {
    set node_ip($i) [format $iptemplate [expr $i+2]]
    set node_mac($i) [format $mactemplate [expr $i]]
}

#
# We set the routing protocol to "Empty" so that ns-2 doesn't do
# any packet routing. All of the routing will be done by the
# Click script.
#
$ns_ rtproto Empty

#
# Here is where we actually create all of the nodes.
#
for {set i 0} {$i < $nodecount } {incr i} {
    set node_($i) [$ns_ node]

    #
    # After creating the node, we add one wireless network interface to
    # it. By default, this interface will be named "eth0". If we
    # added a second interface it would be named "eth1", a third
    # "eth2" and so on.
    #
    $node_($i) add-interface $chan_1_ $prop_ $netll $netmac \
	  $netifq 1 $netphy $antenna $wtopo

    #
    # Now configure the interface eth0
    #
    #$node_($i) setip "eth0" $node_ip($i)
    $node_($i) setmac "eth0" $node_mac($i)

    #
    # Set some node properties
    #
    $node_($i) random-motion 0
    $node_($i) topography $wtopo
    $node_($i) nodetrace $tracefd

    #
    # The node name is used by Click to distinguish information
    # coming from different nodes. For example, a "Print" element
    # prepends this to the printed string so it's clear exactly
    # which node is doing the printing.
    #
    [$node_($i) set classifier_] setnodename "node$i"
}

for {set i 1} {$i < $nodecount } {incr i} {
    #
    # Load the appropriate Click router script for the node.
    # All nodes in this simulation are using the same script,
    # but there's no reason why each node couldn't use a different
    # script.
    #
[$node_($i) entry] loadclick "dht_dsr_out.click"
}

[$node_(0) entry] loadclick "dht_dsr_writer_out.click"

for {set i 0} {$i < $nodecount} {incr i} {
   $ns_ at 0.0 "[$node_($i) entry] runclick"
}

# 
# Define node network traffic. There isn't a whole lot going on
# in this simple test case, we're just going to have the first node
# send packets to the last node, starting at 1 second, and ending at 10.
# There are Perl scripts available to automatically generate network
# traffic.
#


#
# Start transmitting at $startxmittime, $xmitrate packets per second.
#
set startxmittime 0
set xmitrate 4
set xmitinterval 0.25
set packetsize 64

$node_(0) set X_ 325.5916488475772
$node_(0) set Y_ 431.3157336124599
$node_(0) set Z_ 0
$node_(1) set X_ 274.44159840637633
$node_(1) set Y_ 355.9457685375079
$node_(1) set Z_ 0
$node_(2) set X_ 259.29212985598525
$node_(2) set Y_ 324.43347253219434
$node_(2) set Z_ 0
$node_(3) set X_ 185.4065089867965
$node_(3) set Y_ 304.2079589143682
$node_(3) set Z_ 0
$node_(4) set X_ 218.35862236126772
$node_(4) set Y_ 422.179643780286
$node_(4) set Z_ 0
$node_(5) set X_ 303.647124910825
$node_(5) set Y_ 242.46924603545483
$node_(5) set Z_ 0
$node_(6) set X_ 382.2693640021416
$node_(6) set Y_ 242.91218206124756
$node_(6) set Z_ 0
$node_(7) set X_ 303.7560999156406
$node_(7) set Y_ 149.748943973667
$node_(7) set Z_ 0
$node_(8) set X_ 368.423868451347
$node_(8) set Y_ 426.47418626963326
$node_(8) set Z_ 0
$node_(9) set X_ 463.1152958331395
$node_(9) set Y_ 406.1898191050212
$node_(9) set Z_ 0
$node_(10) set X_ 294.13076946329375
$node_(10) set Y_ 356.60489750615943
$node_(10) set Z_ 0
$node_(11) set X_ 134.86887284535487
$node_(11) set Y_ 464.17295136870496
$node_(11) set Z_ 0
$node_(12) set X_ 121.08051979105454
$node_(12) set Y_ 520.8635807984843
$node_(12) set Z_ 0
$node_(13) set X_ 102.11717664238836
$node_(13) set Y_ 406.5046422144613
$node_(13) set Z_ 0
$node_(14) set X_ 316.26174936061227
$node_(14) set Y_ 530.5226834413866
$node_(14) set Z_ 0
$node_(15) set X_ 475.55440489968265
$node_(15) set Y_ 397.23234499803823
$node_(15) set Z_ 0
$node_(17) set X_ 209.28670228325328
$node_(17) set Y_ 400.0347007036464
$node_(17) set Z_ 0
$node_(16) set X_ 506.50822410260974
$node_(16) set Y_ 494.2508823408998
$node_(16) set Z_ 0
$node_(19) set X_ 373.2431089536491
$node_(19) set Y_ 92.42235008348592
$node_(19) set Z_ 0
$node_(18) set X_ 247.36422347002468
$node_(18) set Y_ 123.95431136865454
$node_(18) set Z_ 0
$node_(21) set X_ 135.52057983436438
$node_(21) set Y_ 266.80881518404294
$node_(21) set Z_ 0
$node_(20) set X_ 434.8973501025776
$node_(20) set Y_ 76.59181003145932
$node_(20) set Z_ 0
$node_(23) set X_ 180.47808394010102
$node_(23) set Y_ 107.8868693389478
$node_(23) set Z_ 0
$node_(22) set X_ 346.83380219839484
$node_(22) set Y_ 0.0
$node_(22) set Z_ 0
$node_(25) set X_ 301.6747077517545
$node_(25) set Y_ 570.9958850563004
$node_(25) set Z_ 0
$node_(24) set X_ 108.20330497046234
$node_(24) set Y_ 83.77809530381523
$node_(24) set Z_ 0
$node_(27) set X_ 285.04449717382016
$node_(27) set Y_ 650.7383036028608
$node_(27) set Z_ 0
$node_(26) set X_ 253.39107583896487
$node_(26) set Y_ 39.05789241402175
$node_(26) set Z_ 0
$node_(29) set X_ 200.1518264832404
$node_(29) set Y_ 605.7802790002764
$node_(29) set Z_ 0
$node_(28) set X_ 403.7636952357803
$node_(28) set Y_ 561.9256871492902
$node_(28) set Z_ 0
$node_(31) set X_ 282.7567029652846
$node_(31) set Y_ 740.7736060386223
$node_(31) set Z_ 0
$node_(30) set X_ 359.1126379314188
$node_(30) set Y_ 673.2693259224253
$node_(30) set Z_ 0
$node_(34) set X_ 86.44032579904444
$node_(34) set Y_ 251.4606699231336
$node_(34) set Z_ 0
$node_(35) set X_ 0.0
$node_(35) set Y_ 257.68386506352505
$node_(35) set Z_ 0
$node_(32) set X_ 76.47228777037708
$node_(32) set Y_ 151.3686441478202
$node_(32) set Z_ 0
$node_(33) set X_ 144.86077532389777
$node_(33) set Y_ 9.884651191787611
$node_(33) set Z_ 0
$node_(36) set X_ 286.4638104310154
$node_(36) set Y_ 552.6142580686453
$node_(36) set Z_ 0
$node_(37) set X_ 27.874951846297108
$node_(37) set Y_ 61.402546538879676
$node_(37) set Z_ 0

for {set i 0} {$i < $nodecount} {incr i} {
#    $node_($i) set X_ [expr $i % $slen * 50 ]
#    $node_($i) set Y_ [expr $i / $slen * 50 ]
#    $node_($i) set Z_ 0
    $node_($i) label $node_mac($i).brn
}

#
# This sizes the nodes for use in nam. Currently, the trace files
# produced by nsclick don't really work in nam.
#
for {set i 0} {$i < $nodecount} {incr i} {
    $ns_ initial_node_pos $node_($i) 20
}

$ns_ at  0.0 "puts \"\[\[$node_(0) entry\] writehandler dhtrouting/dhtrouting node_id \"00000000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(1) entry\] writehandler dhtrouting/dhtrouting node_id \"071c0000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(2) entry\] writehandler dhtrouting/dhtrouting node_id \"0e380000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(3) entry\] writehandler dhtrouting/dhtrouting node_id \"15540000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(4) entry\] writehandler dhtrouting/dhtrouting node_id \"1c700000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(5) entry\] writehandler dhtrouting/dhtrouting node_id \"238c0000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(6) entry\] writehandler dhtrouting/dhtrouting node_id \"2aa80000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(7) entry\] writehandler dhtrouting/dhtrouting node_id \"31c40000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(8) entry\] writehandler dhtrouting/dhtrouting node_id \"38e00000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(9) entry\] writehandler dhtrouting/dhtrouting node_id \"40000000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(10) entry\] writehandler dhtrouting/dhtrouting node_id \"471c0000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(11) entry\] writehandler dhtrouting/dhtrouting node_id \"4e380000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(12) entry\] writehandler dhtrouting/dhtrouting node_id \"55540000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(13) entry\] writehandler dhtrouting/dhtrouting node_id \"5c700000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(14) entry\] writehandler dhtrouting/dhtrouting node_id \"638c0000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(15) entry\] writehandler dhtrouting/dhtrouting node_id \"6aa80000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(16) entry\] writehandler dhtrouting/dhtrouting node_id \"71c40000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(17) entry\] writehandler dhtrouting/dhtrouting node_id \"78e00000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(18) entry\] writehandler dhtrouting/dhtrouting node_id \"80000000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(19) entry\] writehandler dhtrouting/dhtrouting node_id \"871c0000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(20) entry\] writehandler dhtrouting/dhtrouting node_id \"8e380000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(21) entry\] writehandler dhtrouting/dhtrouting node_id \"95540000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(22) entry\] writehandler dhtrouting/dhtrouting node_id \"9c700000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(23) entry\] writehandler dhtrouting/dhtrouting node_id \"a38c0000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(24) entry\] writehandler dhtrouting/dhtrouting node_id \"aaa80000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(25) entry\] writehandler dhtrouting/dhtrouting node_id \"b1c40000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(26) entry\] writehandler dhtrouting/dhtrouting node_id \"b8e00000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(27) entry\] writehandler dhtrouting/dhtrouting node_id \"c0000000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(28) entry\] writehandler dhtrouting/dhtrouting node_id \"c5d10000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(29) entry\] writehandler dhtrouting/dhtrouting node_id \"cba20000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(30) entry\] writehandler dhtrouting/dhtrouting node_id \"d1730000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(31) entry\] writehandler dhtrouting/dhtrouting node_id \"d7440000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(32) entry\] writehandler dhtrouting/dhtrouting node_id \"dd150000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(33) entry\] writehandler dhtrouting/dhtrouting node_id \"e2e60000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(34) entry\] writehandler dhtrouting/dhtrouting node_id \"e8b70000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(35) entry\] writehandler dhtrouting/dhtrouting node_id \"ee880000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(36) entry\] writehandler dhtrouting/dhtrouting node_id \"f4590000000000000000000000000000 128\" \]\""
$ns_ at  0.0 "puts \"\[\[$node_(37) entry\] writehandler dhtrouting/dhtrouting node_id \"fa2a0000000000000000000000000000 128\" \]\""
#
# Stop the simulation
#
$ns_ at  $stoptime.000000001 "puts \"NS EXITING...\" ; $ns_ halt"

#
# Let nam know that the simulation is done.
#
$ns_ at  $stoptime	"$ns_ nam-end-wireless $stoptime"


puts "Starting Simulation..."
$ns_ run
