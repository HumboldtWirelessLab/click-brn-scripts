#!/usr/bin/perl
use threads;
use threads::shared;
use DBI;


my $database = "hwl";
my $username = "hwl_user";
my $password = "testbed";
my $hostname = "192.168.4.164";
my $db = DBI->connect("DBI:mysql:$database:$hostname", $username, $password );

my %arp_table;

my $sql_query= "select 
                        nodes.id,
                        nodes.address,
                        nodes.status,
                        dev.mac,
                        dev.node_idx_testbed,
                        dev.driver_device_number,
                        dev.phy_connection
                from 
                        testbed_devices as dev,
                        testbed_nodes as nodes
                where 
                        dev.node_idx_testbed = nodes.id and
                        dev.driver_device_number = '0' and 
                        dev.phy_connection = 'wireless' and
                        nodes.status = 'active' ";

$query = $db->prepare($sql_query);
$execute = $query->execute;

while (@array = $query->fetchrow_array) {

        $ip = @array[1];
        $mac = @array[3];

	#print "$mac, $ip\n";

    	$arp_table{uc($mac)} = $ip;
	#print "$arp_table{$mac}\n";
}

	
sub trimwhitespaces($) {
  my $string = shift;
  $string =~ s/^\s+//;
  $string =~ s/\s+$//;
  return $string;
}


print "<systems>\n";

#
# iterate over all available nodes and construct a query
# 


#
# To accelerate the process we use threads. This means that instead of
# adding all idle times we let them occure parallel which means 
# reduction of the overall time to wait ;)
# 

my $host_reachable = "ping -q -c2 -w2 IP_ADDR 2>&1 >&- && echo ok || echo failed";
#my $base_query = "echo \"read sys_info.systeminfo\" | netcat -q 1 IP_ADDR 7777";
my $base_query = "/testbedhome/testbed/helper/host/bin/clickctrl.sh read IP_ADDR 7777 sys_info systeminfo";

# iterate over all available nodes and construct a query
foreach $key ( keys( %arp_table) ) {
        threads->create('thread',$key);
}

# Join all started threads
foreach $thr (threads->list()) {
        # if we are main thread, dont join main thread
        if ($thr->tid() && !threads::equal($thr, threads->self())) {
            $thr->join();
        }
}

sub thread {
  @arg = @_;
  $key = @arg[0];

  $check_host_query = $host_reachable;
  #construct query string
  $query = $base_query;
  $ip = $arp_table{$key};
  $check_host_query =~ s/IP_ADDR/$ip/;
  $query =~ s/IP_ADDR/$ip/;
#  print $query;
  
#  $ping_res = trimwhitespaces(`$check_host_query`);

#  if ($ping_res eq 'failed') {
   # printf "failed";
#    next mainloop;
#  } else {
   # print "ok: $ip\n";
#  }
  
  @res_lines = `$query`;
  chomp @res_lines;
  # skip the first three lines
  #shift @res_lines;
  #shift @res_lines;
  #shift @res_lines;
  
  while ( @res_lines ){
    $line = shift @res_lines;
    printf "%s\n", $line;
  }
}
print "</systems>\n";
