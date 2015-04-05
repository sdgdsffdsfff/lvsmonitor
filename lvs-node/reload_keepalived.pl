#!/usr/bin/perl
use 5.010;
use strict;
use warnings;
my $lib_path=`echo $0 | sed "s/\$(basename $0)//g"`;
chomp($lib_path);
require("$lib_path/common.pl");

my %pid_files=(
    keepalived=>'/var/run/keepalived.pid',
    check=>'/var/run/checkers.pid',
    vrrp=>'/var/run/vrrp.pid'
);

my $kill_cmd="/bin/kill -HUP";
my $cat_cmd="/bin/cat";
my $config_file="/etc/keepalived/keepalived.conf";
my %err_info=(
    221=>"pid file doesn't exit",
    222=>"kill command execute failed",
    223=>"pid file read failed"
);

sub reload_usage($){
    err_exit("usage:\n $0 [check] [vrrp]\n defualt:$0 keepalived(all)",0);
}    

sub reload($){
    my $pid=`$cat_cmd $pid_files{$_[0]}`;
    my $pid_file=$pid_files{$_[0]};
    if($? ne 0){
        err_exit($err_info{223},223);
    }
    if( !-f $pid_file){
        `keepalived -d -f $config_file`;
        if($? ne 0 and !-f $pid_file){
            err_exit(err_info{221},221);
        }
    }
    `$kill_cmd $pid`;
    if($? eq 0){
        say "reload $_[0] success!";
    }else{
        err_exit(err_info{223},223);
    }   
}

##main
if($#ARGV ne 0 and $#ARGV ne -1){
    reload_usage($0);   
}
if($#ARGV eq -1){reload("keepalived")}
else{
    given($ARGV[0]){
        when(/^vrrp$/){
            #kill vrrp
            reload($ARGV[0]);
        }
        when(/^check$/){
            #kill checkers
            reload($ARGV[0]);
        
        }
        default{
            reload_usage($0);
        }
}
}
