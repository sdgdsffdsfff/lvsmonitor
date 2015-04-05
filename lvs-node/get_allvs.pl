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
    '113'=>"can't find vip service",
    '114'=>"no match"
);    

my %vs_service=(
    vip=>'',
    protocol=>'',
    port=>'',
);

sub check_all_vs(){
    if(!-f $ip_vs_file){
        err_exit($err_info{111},111);
    }
    my @vips=`$cat $ip_vs_file`;
    if($? ne 0){
        err_exit($err_info{112},112);
    }
    for(my $i=3;$i<=$#vips;$i++){
        my $ip;
        my $port;
        my $protocol;
        if($vips[$i]=~/(\w+)\s+([0-9A-Z]{8})\:([0-9A-Z]{4})/){
            $protocol=$1;
            $ip=hex_to_dec_ip($2);
            $port=hex_to_dec_port($3);
            say "vip service $1 => $ip : $port";
        }
    }
}

#192.168.2.1 80

sub check_one_vs($){
    my $ip=$_[0];
    my @info=`$cat $ip_vs_file`;
    if($? ne 0){
        err_exit($err_info{112},112);
    }
    my $light=0;
    my $match=0;
    for(@info){
        if($_=~/(\w+)\s+([0-9A-Z]{8})\:([0-9A-Z]{4})/){
            my $trip=hex_to_dec_ip($2);
            if($trip eq $ip){
                $match=1;
                $light=1;
                my $port=hex_to_dec_port($3);
                say "";
                say "vip service $1 => $ip : $port";
            }else{
                $light=0;
            }
        }elsif($light==1){
            if($_=~/([0-9A-Z]{8})\:([0-9A-Z]{4})/){
                my $trip=hex_to_dec_ip($1);
                my $port=hex_to_dec_port($2);
                say "\t |------rs $trip : $port";
            }
}
}
    if($match eq 0){
        err_exit($err_info{114},114);
    }
}

sub check_vs_port($$){
    my $ip=$_[0];
    my $port=$_[1];
    my @info=`$cat $ip_vs_file`;
    if($? ne 0){
        err_exit($err_info{112},112);
    }
    my $light=0;
    my $match=0;
    for(@info){
        if($_=~/(\w+)\s+([0-9A-Z]{8})\:([0-9A-Z]{4})/){
            my $tip=hex_to_dec_ip($2);
            my $tport=hex_to_dec_port($3);
            if($tip eq $ip and $tport eq $port){
               $light=1;
               $match=1;
               say "";
               say "vip service $1 => $ip : $port";
            
            }else{
                $light=0;
            }
    }elsif($light==1){
            if($_=~/([0-9A-Z]{8})\:([0-9A-Z]{4})/){
                my $trip=hex_to_dec_ip($1);
                my $port=hex_to_dec_port($2);
                say "\t |------rs $trip : $port";
            }
            
}
    }
    if($match eq 0){
        err_exit($err_info{114},114);
    }
}

####################main
given($#ARGV){
    when(/-1/){
        check_all_vs();
        err_exit("success",0);
    }   
    when(/0/){
       if(check_ip($ARGV[0])){
            check_one_vs($ARGV[0]);
            err_exit("success",0);
        }else{
            usage($0);
        } 
    }
    when(/1/){
        if(check_ip($ARGV[0]) and check_port($ARGV[1])){
            check_vs_port($ARGV[0],$ARGV[1]);
            err_exit("success",0);
        }else{usage($0)}
    } 
    default{
        usage($0);
    }
}


