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
Propagation/Shadowing set pathlossExp_ 2.0  ;# path loss exponent
Propagation/Shadowing set std_db_ 4.0       ;# shadowing deviation (dB)
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

set netprop Propagation/TwoRayGround
#set netprop Propagation/Shadowing

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
set xsize  700
set ysize  700
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

set nodecount   40
set slen	4
set stoptime    11.0

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
set tracefd     [open "simple.tr" w]
set namtrace    [open "simple.nam" w]
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
[$node_($i) entry] loadclick "linkstat_out.click"
}

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

 $node_(0) set X_ 155.6490669415673
 $node_(0) set Y_ 85.54468830543249
 $node_(0) set Z_ 0
 $node_(0) label $node_mac(0).brn
 $node_(1) set X_ 196.92352137872803
 $node_(1) set Y_ 104.09432855015685
 $node_(1) set Z_ 0
 $node_(1) label $node_mac(1).brn
 $node_(2) set X_ 180.55834271284
 $node_(2) set Y_ 134.94718298687343
 $node_(2) set Z_ 0
 $node_(2) label $node_mac(2).brn
 $node_(3) set X_ 234.4266734895063
 $node_(3) set Y_ 84.51532001917246
 $node_(3) set Z_ 0
 $node_(3) label $node_mac(3).brn
 $node_(4) set X_ 195.16529467568765
 $node_(4) set Y_ 173.63880926409294
 $node_(4) set Z_ 0
 $node_(4) label $node_mac(4).brn
 $node_(5) set X_ 142.97407651562696
 $node_(5) set Y_ 166.49075363254627
 $node_(5) set Z_ 0
 $node_(5) label $node_mac(5).brn
 $node_(6) set X_ 245.20703127706446
 $node_(6) set Y_ 64.71553290444771
 $node_(6) set Z_ 0
 $node_(6) label $node_mac(6).brn
 $node_(7) set X_ 259.5750453289786
 $node_(7) set Y_ 117.33656436350094
 $node_(7) set Z_ 0
 $node_(7) label $node_mac(7).brn
 $node_(8) set X_ 272.20363456076905
 $node_(8) set Y_ 122.22631475652881
 $node_(8) set Z_ 0
 $node_(8) label $node_mac(8).brn
 $node_(9) set X_ 284.9703528747271
 $node_(9) set Y_ 169.1481870515318
 $node_(9) set Z_ 0
 $node_(9) label $node_mac(9).brn
 $node_(10) set X_ 243.0703424965091
 $node_(10) set Y_ 101.80125900577508
 $node_(10) set Z_ 0
 $node_(10) label $node_mac(10).brn
 $node_(11) set X_ 124.2739021156691
 $node_(11) set Y_ 168.88107676209756
 $node_(11) set Z_ 0
 $node_(11) label $node_mac(11).brn
 $node_(12) set X_ 317.43458972707725
 $node_(12) set Y_ 124.86721448104811
 $node_(12) set Z_ 0
 $node_(12) label $node_mac(12).brn
 $node_(13) set X_ 242.99475680995147
 $node_(13) set Y_ 135.6723798167593
 $node_(13) set Z_ 0
 $node_(13) label $node_mac(13).brn
 $node_(14) set X_ 282.3453009609875
 $node_(14) set Y_ 52.91002453385522
 $node_(14) set Z_ 0
 $node_(14) label $node_mac(14).brn
 $node_(15) set X_ 338.80835483855344
 $node_(15) set Y_ 118.41102400112476
 $node_(15) set Z_ 0
 $node_(15) label $node_mac(15).brn
 $node_(16) set X_ 126.91516058068379
 $node_(16) set Y_ 48.5471827915641
 $node_(16) set Z_ 0
 $node_(16) label $node_mac(16).brn
 $node_(17) set X_ 216.1444060104681
 $node_(17) set Y_ 30.451323275445304
 $node_(17) set Z_ 0
 $node_(17) label $node_mac(17).brn
 $node_(18) set X_ 91.27233178105459
 $node_(18) set Y_ 182.9113617901062
 $node_(18) set Z_ 0
 $node_(18) label $node_mac(18).brn
 $node_(19) set X_ 157.98658109767405
 $node_(19) set Y_ 90.89208714153763
 $node_(19) set Z_ 0
 $node_(19) label $node_mac(19).brn
 $node_(20) set X_ 290.127941480749
 $node_(20) set Y_ 172.08372410586145
 $node_(20) set Z_ 0
 $node_(20) label $node_mac(20).brn
 $node_(21) set X_ 210.23475658737806
 $node_(21) set Y_ 87.72862543454927
 $node_(21) set Z_ 0
 $node_(21) label $node_mac(21).brn
 $node_(22) set X_ 217.82104530145148
 $node_(22) set Y_ 84.59019270572003
 $node_(22) set Z_ 0
 $node_(22) label $node_mac(22).brn
 $node_(23) set X_ 63.4345136198892
 $node_(23) set Y_ 201.70224280913257
 $node_(23) set Z_ 0
 $node_(23) label $node_mac(23).brn
 $node_(24) set X_ 83.22840726790596
 $node_(24) set Y_ 123.3886320688525
 $node_(24) set Z_ 0
 $node_(24) label $node_mac(24).brn
 $node_(25) set X_ 92.67711064286895
 $node_(25) set Y_ 147.53146293558967
 $node_(25) set Z_ 0
 $node_(25) label $node_mac(25).brn
 $node_(26) set X_ 118.05663538752522
 $node_(26) set Y_ 223.2333011680126
 $node_(26) set Z_ 0
 $node_(26) label $node_mac(26).brn
 $node_(27) set X_ 303.0090624901575
 $node_(27) set Y_ 64.8190125022684
 $node_(27) set Z_ 0
 $node_(27) label $node_mac(27).brn
 $node_(28) set X_ 381.4991571608848
 $node_(28) set Y_ 107.15979079512933
 $node_(28) set Z_ 0
 $node_(28) label $node_mac(28).brn
 $node_(29) set X_ 276.88908012061677
 $node_(29) set Y_ 10.02790496190481
 $node_(29) set Z_ 0
 $node_(29) label $node_mac(29).brn
 $node_(30) set X_ 89.76973784639226
 $node_(30) set Y_ 37.09379034011522
 $node_(30) set Z_ 0
 $node_(30) label $node_mac(30).brn
 $node_(31) set X_ 146.12491976078343
 $node_(31) set Y_ 113.3698251165366
 $node_(31) set Z_ 0
 $node_(31) label $node_mac(31).brn
 $node_(32) set X_ 27.126852863459987
 $node_(32) set Y_ 218.1611585805814
 $node_(32) set Z_ 0
 $node_(32) label $node_mac(32).brn
 $node_(33) set X_ 341.0943225364661
 $node_(33) set Y_ 45.90619453794321
 $node_(33) set Z_ 0
 $node_(33) label $node_mac(33).brn
 $node_(34) set X_ 125.29288660896164
 $node_(34) set Y_ 0.0
 $node_(34) set Z_ 0
 $node_(34) label $node_mac(34).brn
 $node_(35) set X_ 248.39446207032242
 $node_(35) set Y_ 200.30470202124675
 $node_(35) set Z_ 0
 $node_(35) label $node_mac(35).brn
 $node_(36) set X_ 49.617039670837926
 $node_(36) set Y_ 258.71605019002993
 $node_(36) set Z_ 0
 $node_(36) label $node_mac(36).brn
 $node_(37) set X_ 365.60964350777755
 $node_(37) set Y_ 35.30230474100536
 $node_(37) set Z_ 0
 $node_(37) label $node_mac(37).brn
 $node_(38) set X_ 357.02599938394724
 $node_(38) set Y_ 164.87656538175005
 $node_(38) set Z_ 0
 $node_(38) label $node_mac(38).brn
 $node_(39) set X_ 0.0
 $node_(39) set Y_ 249.19530028694976
 $node_(39) set Z_ 0
 $node_(39) label $node_mac(39).brn

#
# This sizes the nodes for use in nam. Currently, the trace files
# produced by nsclick don't really work in nam.
#
for {set i 0} {$i < $nodecount} {incr i} {
    $ns_ initial_node_pos $node_($i) 20
}

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




