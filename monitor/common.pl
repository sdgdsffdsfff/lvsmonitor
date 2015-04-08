use 5.010;
#
my @PROTOCOL=qw(TCP UDP);

sub err_exit($$){
    say "err_exit:$_[0]";
    exit $_[1];
}

sub is_ip($){
	if($_[0]=~/^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})$/){
		return 1;
	}else{
		return 0;
	}
}

sub is_port($){
	if($_[0]>0 and $_[0]<65535){
		return 1;
	}else{
		return 0;
	}
}

sub is_pro($){
	for(@PROTOCOL){
		if($_ eq $_[0]){
			return 1;
		}
	}
	return 0;
}






sub get_time{
	my $ret=`/bin/date +%Y-%m-%d-%H:%M:%S-`;
	#if(!$ret){err_exit("get_time err",0)}
	chomp($ret);
	return $ret;
}





sub usage($){
	say <<EOF;
Info:you should run this command int the dir named a hostname or ip of the remote lvs,because the script will get the 
  	 ip from the directory.
Usage:
	$_[0]  [command] [options]
	add_vs				[vip=vip] [vport=vport] [pro=protcol]
	add_rs				[vip=vip] [vport=vport] [rip=rip] [rport=rport] [pro=protcol]
	del_vs				[vip=vip] [vport=vport] [pro=protcol]
	del_rs				[vip=vip] [vport=vport] [rip=rip] [rport=rport] [pro=protcol]
	
	add_vip				[vip=vip]   add a ip on the lvs lo and write into rc.local
	del_vip				[vip=vip]   del a ip on the lvs lo and clear it from rc.local
	get_vs 				[vip=vip] [vport=vport] get all the virtual service from the remote lvs mode
	get_rs				[rip=rip] get the rip infromation from the remote lvs node

	backup				backup keepalived file on the remote lvs
	download			download keepalived file from the remote lvs
	upload      			upload the keepalived file that we changed to the remote lvs
	reload          		[vrrp][check] default(without arg) is to reload all the three pids

EOF

exit 0;
}




1;