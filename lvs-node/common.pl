my @PROTOCOL=qw(TCP UDP);

sub hex_to_dec_ip($){
    if(my @bips=$_[0]=~/(?<bip>[0-9A-F]{2})/g){
       my $res=join ".",map(hex,@bips);
       return $res;
    }
    else{return 0}
}

sub hex_to_dec_port($){
    return hex $_[0];
}

sub is_support_protocol($){
    for (@PROTOCOL){
        if($_[0] eq $_){
            return 1;
        }
        else{return 0}
    }
}


sub write_info($@){
    #write a list to a file
    my $file=shift @_;
    my @infos=@_;
    open(F,">$file");
    for(@infos){
        chomp($_);
        say F $_;
    }
}

sub get_time{
    my $ret=`/bin/date +%Y-%m-%d-%H:%M:%S-`;
    #if(!$ret){err_exit("get_time err",0)}
    chomp($ret);
    return $ret;
}



sub err_exit($$){
    print $_[0]."\n";
    exit $_[1];   
}

sub usage($){
    err_exit("usage:\n $_[0] <vip> <vport> <protocol>",0);
}      

sub check_ip($){
    if($_[0]=~/^(([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3}))$/){
        return 1;
    }else{
        return 0;
    }   
}

sub check_port($){
    if($_[0]>0 and $_[0] <=65535){
        return 1; 
    }else{
        return 0;
    }
}













1;
