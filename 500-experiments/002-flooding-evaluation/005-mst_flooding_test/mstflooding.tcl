#Autogenerated
Mac/802_11 set CWMin_ 7
Mac/802_11 set CWMax_ 63
Mac/802_11 set CWMin1_ 15
Mac/802_11 set CWMax1_ 127
Mac/802_11 set CWMin2_ 31
Mac/802_11 set CWMax2_ 255
Mac/802_11 set CWMin3_ 63
Mac/802_11 set CWMax3_ 511
Mac/802_11 set NoHWQueues_ 4
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

# Propagation model
# first set values of shadowing model
Propagation/Shadowing set pathlossExp_ 2.0  ;# path loss exponent
Propagation/Shadowing set std_db_ 2.0       ;# shadowing deviation (dB)
Propagation/Shadowing set dist0_ 1.0        ;# reference distance (m)
Propagation/Shadowing set seed_ 0           ;# seed for RNG

# Physical Layer

Phy/WirelessPhy set CPThresh_ 10.0
#Phy/WirelessPhy set CSThresh_ 1.559e-11 ;
#Phy/WirelessPhy set RXThresh_ 3.28984e-09
Phy/WirelessPhy set CSThresh_ 3.1623e-10; #-95db
Phy/WirelessPhy set RXThresh_ 3.28984e-09; #-84.8db
Phy/WirelessPhy set Rb_ 2*1e6
Phy/WirelessPhy set Pt_ 0.281838
Phy/WirelessPhy set freq_ 2.472e9
Phy/WirelessPhy set L_ 1.0

#Phy/WirelessPhy set Pt_ 0.281838     ;# transmission power
#Phy/WirelessPhy set freq_ 2.472e9    ;# for broadcast packets channel-13.2.472GHz
#Phy/WirelessPhy set RXThresh_ 3.28984e-09   ;# communication radius

# Mac Layer
Mac/802_11 set dataRate_ 11Mb
Mac/802_11 set basicRate_ 1Mb 
Mac/802_11 set RTSThreshold_ 3000
Mac/802_11 set TXFeedback_ 1
Mac/802_11 set Promisc_ 1
Mac/802_11 set FilterDub_ 0
Mac/802_11 set ControlFrames_ 1
Mac/802_11 set ShortRetryLimit_ 0
Mac/802_11 set LongRetryLimit_ 0
#
# The network channel, physical layer, MAC, propagation model,
# and antenna model are all standard ns-2.
#  
set netchan	Channel/WirelessChannel
set netphy	Phy/WirelessPhy
set netmac	Mac/802_11
set netprop     Propagation/Shadowing
set antenna     Antenna/OmniAntenna

set xsize 120
set ysize 120
set nodecount 10
set stoptime 221

set node_name(0) "sk1"
set node_mac(0) "00:00:00:00:00:01"
set pos_x(0) 0
set pos_y(0) 0
set pos_z(0) 0
set nodelabel(0) "sk1.eth0"
set clickfile(0) "/home/yetinam/Dokumente/brn-tools/click-brn-scripts/500-experiments/002-flooding-evaluation/005-mst_flooding_test/flooding.click.sk1.eth0"
set node_name(1) "sk2"
set node_mac(1) "00:00:00:00:00:02"
set pos_x(1) 70
set pos_y(1) 0
set pos_z(1) 0
set nodelabel(1) "sk2.eth0"
set clickfile(1) "/home/yetinam/Dokumente/brn-tools/click-brn-scripts/500-experiments/002-flooding-evaluation/005-mst_flooding_test/flooding.click.sk2.eth0"
set node_name(2) "sk3"
set node_mac(2) "00:00:00:00:00:03"
set pos_x(2) 140
set pos_y(2) 0
set pos_z(2) 0
set nodelabel(2) "sk3.eth0"
set clickfile(2) "/home/yetinam/Dokumente/brn-tools/click-brn-scripts/500-experiments/002-flooding-evaluation/005-mst_flooding_test/flooding.click.sk3.eth0"
set node_name(3) "sk4"
set node_mac(3) "00:00:00:00:00:04"
set pos_x(3) 210
set pos_y(3) 0
set pos_z(3) 0
set nodelabel(3) "sk4.eth0"
set clickfile(3) "/home/yetinam/Dokumente/brn-tools/click-brn-scripts/500-experiments/002-flooding-evaluation/005-mst_flooding_test/flooding.click.sk4.eth0"
set node_name(4) "sk5"
set node_mac(4) "00:00:00:00:00:05"
set pos_x(4) 0
set pos_y(4) 70
set pos_z(4) 0
set nodelabel(4) "sk5.eth0"
set clickfile(4) "/home/yetinam/Dokumente/brn-tools/click-brn-scripts/500-experiments/002-flooding-evaluation/005-mst_flooding_test/flooding.click.sk5.eth0"
set node_name(5) "sk6"
set node_mac(5) "00:00:00:00:00:06"
set pos_x(5) 70
set pos_y(5) 70
set pos_z(5) 0
set nodelabel(5) "sk6.eth0"
set clickfile(5) "/home/yetinam/Dokumente/brn-tools/click-brn-scripts/500-experiments/002-flooding-evaluation/005-mst_flooding_test/flooding.click.sk6.eth0"
set node_name(6) "sk7"
set node_mac(6) "00:00:00:00:00:07"
set pos_x(6) 140
set pos_y(6) 70
set pos_z(6) 0
set nodelabel(6) "sk7.eth0"
set clickfile(6) "/home/yetinam/Dokumente/brn-tools/click-brn-scripts/500-experiments/002-flooding-evaluation/005-mst_flooding_test/flooding.click.sk7.eth0"
set node_name(7) "sk8"
set node_mac(7) "00:00:00:00:00:08"
set pos_x(7) 210
set pos_y(7) 70
set pos_z(7) 0
set nodelabel(7) "sk8.eth0"
set clickfile(7) "/home/yetinam/Dokumente/brn-tools/click-brn-scripts/500-experiments/002-flooding-evaluation/005-mst_flooding_test/flooding.click.sk8.eth0"
set node_name(8) "sk9"
set node_mac(8) "00:00:00:00:00:09"
set pos_x(8) 0
set pos_y(8) 140
set pos_z(8) 0
set nodelabel(8) "sk9.eth0"
set clickfile(8) "/home/yetinam/Dokumente/brn-tools/click-brn-scripts/500-experiments/002-flooding-evaluation/005-mst_flooding_test/flooding.click.sk9.eth0"
set node_name(9) "sk10"
set node_mac(9) "00:00:00:00:00:0A"
set pos_x(9) 70
set pos_y(9) 140
set pos_z(9) 0
set nodelabel(9) "sk10.eth0"
set clickfile(9) "/home/yetinam/Dokumente/brn-tools/click-brn-scripts/500-experiments/002-flooding-evaluation/005-mst_flooding_test/flooding.click.sk10.eth0"
set enable_tr 1
set enable_nam 1


set wtopo	[new Topography]
$wtopo load_flatgrid $xsize $ysize

#
# We have to use a special queue and link layer. This is so that
# Click can have control over the network interface packet queue,
# which is vital if we want to play with, e.g. QoS algorithms.
#
set netifq	Queue/ClickQueue
set netll	LL/Ext
#LL set delay_			1ms
LL set delay_			0ms

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

#$ns_ use-scheduler Calendar
$ns_ use-scheduler Heap
#$ns_ use-scheduler List
#$ns_ use-scheduler Map
#$ns_ use-scheduler RealTime
#
# Create and activate trace files.
#
if { $enable_tr == 1 } {
  set tracefd     [open "/home/yetinam/Dokumente/brn-tools/click-brn-scripts/500-experiments/002-flooding-evaluation/005-mst_flooding_test/mstflooding.tr" w]
} else {
  set tracefd     [open "/dev/null" w]
}

$ns_ trace-all $tracefd

if { $enable_nam == 1 } {
  set namtrace    [open "/home/yetinam/Dokumente/brn-tools/click-brn-scripts/500-experiments/002-flooding-evaluation/005-mst_flooding_test/mstflooding.nam" w]
} else {
  set namtrace    [open "/dev/null" w]
}

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

#set iptemplate "10.0.%d.%d"
#set mactemplate "00:00:00:00:%0x:%0x"
#for {set i 0} {$i < $nodecount} {incr i} {
#    set node_ip($i) [format $iptemplate [expr ($i+1)/256] [expr ($i+1)%256] ]
#    set node_mac($i) [format $mactemplate [expr ($i+1)/256] [expr ($i+1)%256] ]
#}

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
    $node_($i) add-interface $chan_1_ $prop_ $netll $netmac $netifq 1 $netphy $antenna $wtopo

    #
    # Now configure the interface eth0
    #
    #  mac and ip is set by run_sim.sh
    #
    #$node_($i) setip "eth0" $node_ip($i)
    $node_($i) setmac "eth0" $node_mac($i)

    #
    # Set some node properties
    #
    $node_($i) random-motion 0
    $node_($i) topography $wtopo
    $node_($i) nodetrace $tracefd

    $node_($i) set X_ $pos_x($i)
    $node_($i) set Y_ $pos_y($i)
    $node_($i) set Z_ $pos_z($i)
    $node_($i) label $nodelabel($i)

    #
    # The node name is used by Click to distinguish information
    # coming from different nodes. For example, a "Print" element
    # prepends this to the printed string so it's clear exactly
    # which node is doing the printing.
    #
    # NODEmstflooding is set by run_sim.sh
    #
    [$node_($i) set classifier_] setnodename $node_name($i)

    [$node_($i) entry] loadclick $clickfile($i)

    #
    # Load the appropriate Click router script for the node.
    # All nodes in this simulation are using the same script,
    # but there's no reason why each node couldn't use a different
    # script.
    #
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



