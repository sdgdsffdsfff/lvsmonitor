#!/usr/bin/perl
#show virtual serivce of lvs 
#list all the vip and vport
use 5.010;
use strict;
use warnings;
my $lib_path=`echo $0 | sed "s/\$(basename $0)//g"`;
chomp($lib_path);
require("$lib_path/common.pl");

my $cat='/bin/cat';
my $ip_vs_file='/proc/net/ip_vs';


my %err_info=(
    '111'=>"/proc/net/ip_vs doesn't exist",
    '112'=>"/proc/net/ip_vs read error",
    '113'=>"can't find vip service"
);    


my %vs_service=(
    vip=>'',
    protocol=>'',
    port=>'',
);

sub usage($){
    err_exit("usage:\n $_[0] <vip> <vport> <protocol>",0);
}      

sub check_vs(){
    if(!-f $ip_vs_file){
        err_exit($err_info{111},111);
        }
    
}



####################main
if($#ARGV ne 1 and $#ARGV ne 2){
    usage($0);
}
check_vs();







