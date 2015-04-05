#!/usr/bin/perl
use 5.010;
use strict;
use warnings;
my $lib_path=`echo $0 | sed "s/\$(basename $0)//g"`;
chomp($lib_path);
require("$lib_path/common.pl");

my $cat='/bin/cat';
my $ip_vs_file='/proc/net/ip_vs';
my @vips=();

my %err_info=(
    '111'=>"/proc/net/ip_vs doesn't exist",
    '112'=>"/proc/net/ip_vs read error",
    '113'=>"can't find vip service",
    '114'=>"no match"
);  

sub get_rs_info($){
    my $ip=shift @_;
    my @info=`$cat $ip_vs_file`;
    if($? ne 0){ err_exit($err_info{112},112)}
    my $match=0;
    my $light=0;
    for(@info){
        if($_=~/(\w+)\s+([0-9A-Z]{8})\:([0-9A-Z]{4})/){
            my $trip=hex_to_dec_ip($2);
            my $tport=hex_to_dec_port($3);
            my $protocol=$1;
            if($light ne 1 and scalar @vips == 0){
                pop @vips;  
            }
            push @vips,$protocol."=>".$trip.":".$tport;
            $light=0;
        }elsif($_=~/-> ([0-9A-Z]{8})\:([0-9A-Z]{4})/){
                my $rip=hex_to_dec_ip($1);
                    if($rip eq $ip){
                        $light=1;
                        $match=1;
                    }
                }

}
    if($match eq 0){err_exit($err_info{114},114)}
    else{
        for(@vips){
            say $_;
        }
        }

}

sub get_rs_usage($){
    err_exit("usage:\n $0 <rs_ip>",0);
    }


##main
given($#ARGV){
    when(/0/){
        if(check_ip($ARGV[0])){
            get_rs_info($ARGV[0]);
            err_exit("success",0);
        }else{get_rs_usage($0)}
    }
    default{
        get_rs_usage($0);
    }
}










