use 5.010;
#
my @PROTOCOL=qw(TCP UDP);

sub err_exit($$){
    say "err_exit:$_[0]";
    exit $_[1];
}

sub is_ip($){
	if($_[0]=~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){
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

sub check_vs($$){

}



sub check_rs($$){

}


sub backup_config($$){
	#backup the keepalived config file on  
	#on the remote lvs node
}

sub write_log($){
    #write a log for every operator command
}

sub upload_config_file($$){
	#upload the config file
}




sub usage($){
	say <<EOF;
Info:you should run this command int the dir named a hostname or ip of the remote lvs,because the script will get the 
  	 ip from the directory.
Usage:
	$_[0]  [command] [options]
	add_vs			[vip=vip] [vport=vport] [pro=protcol]
	add_rs			[vip=vip] [vport=vport] [rip=rip] [rport=rport] [pro=protcol]
	del_vs			[vip=vip] [vport=vport] [pro=protcol]
	del_rs			[vip=vip] [vport=vport] [rip=rip] [rport=rport] [pro=protcol]
	
	add_vip			[vip=vip]   add a ip on the lvs lo and write into rc.local
	del_vip			[vip=vip]   del a ip on the lvs lo and clear it from rc.local
	get_vs 			get all the virtual service from the remote lvs mode
	get_rs			[rip=rip] get the rip infromation from the remote lvs node

	backup			backup keepalived file on the remote lvs
	download_conf	download keepalived file from the remote lvs
	upload_conf		upload the keepalived file that we changed to the remote lvs

EOF
}




1;