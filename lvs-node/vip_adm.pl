#!/usr/bin/perl
use 5.010;
use strict;
use warnings;
my $lib_path=`echo $0 | sed "s/\$(basename $0)//g"`;
chomp($lib_path);
require("$lib_path/common.pl");
#This script is used to add/del/list vip on the dev interface loopback








my $ip_cmd="/sbin/ip";
my $dev="dev lo";
my $rc_local="/etc/rc.d/rc.local";
my @vips;
my $cat="/bin/cat";

my %err_info=(
    211=>"vip not confinged on the lo,del failed!",
    212=>"ip command execute failed",
    213=>"Invalued args",
    214=>"Usage:\n $0: list\t\tlist all the ip on lo\n $0 add/del x.x.x.x\tadd or del vip on lo",
    215=>"rc.loacl doesn't exit",
    216=>"backup rc.local failed",
    217=>"modify rc.local file failed",
    218=>"vip already confinged on the lo,add failed!"
);

sub mod_vip($$){
    my $cmd=$_[0];
    my $vip=$_[1];
    my @ips=get_dev_ip();
    if($cmd eq "add"){
        if(!check_ip_in($vip,@ips)){
            #add the ip on lo
            `$ip_cmd addr add $vip/32 $dev`;
            if($? ne 0){err_exit($err_info{212},212)}
            else{
                say "add $vip on lo success";
                my $info="$ip_cmd addr add $vip/32 $dev";
                modify_rc_local($cmd,$info);
            }
        }
        else{err_exit($err_info{218},218)}
    }
    if($cmd eq "del"){
        if(check_ip_in($vip,@ips)){
         #del the ip on lo
         `$ip_cmd addr del $vip/32 $dev`;
         if($? ne 0){err_exit($err_info{212},212)}  
         else{
            say "del $vip on lo success";
            my $info="$ip_cmd addr add $vip/32 $dev";
            modify_rc_local($cmd,$info);  
         }
        }
        else{err_exit($err_info{211},211)}
       
    }    
}

sub modify_rc_local($$){
    #backup rc.local first
    backup_rc_local();
    my @configs=`$cat  $rc_local`;
    my $new_line=$_[1];
    my $action=$_[0];
    if($action eq "add"){
        if(grep {$_ eq $new_line} @configs){
            say "Item:$new_line already configed in rc.local";
        }
        else{
            push @configs,$new_line;
        }
    }
    if($action eq "del"){
        if(grep(/$new_line/,@configs)){
            @configs=grep(!/$new_line/,@configs);
        }
        else{
            say "Item:$new_line doesn't configed in rc.local";
        }
            
    }
    #operater the file
    no strict "subs";
    open(RCLOCAL,">/etc/rc.d/rc.local");
    for(@configs){
        chomp($_);
        say RCLOCAL $_;
    }
    close(RCLOCAL);
}

sub get_dev_ip{
    my @ips=`$ip_cmd addr list $dev`;  
    my @vips;
    for (@ips){
        if($_=~/([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2})/){
            if($1 !~/127\.0\.0\.1\/8/){push @vips,$1}
        }
    }
    return @vips;
}

sub check_ip_in($@){
    my $ip=shift @_;
    my @ips=@_;
    for (@ips){
        if($ip."/32" eq $_){return 1}
    }    
    return 0;
}

sub vip_adm_usage($){
    err_exit($err_info{214},214);
}

sub backup_rc_local{
    `cp /etc/rc.d/rc.local /etc/rc.d/rc.localback`;
    if($? ne 0){err_exit{err_info{216},216}}
}


#main
if( !-f $rc_local){err_exit(err_info{215},215)}

if($#ARGV ne 1 and $#ARGV ne 0){
    vip_adm_usage($0);
}
given($#ARGV){
    when(/0/){
        my $action=$ARGV[0];
        if($action ne "list"){vip_adm_usage($0)}
        my @ips=get_dev_ip();
        for(@ips){say $_};
    }
    when(/1/){
        my $action=$ARGV[0];
        if($action ne "add" and $action ne "del"){vip_adm_usage($0)}
        my $vip=$ARGV[1];
        if(check_ip($vip)){
            mod_vip($action,$vip);
        }
        else{vip_adm_usage($0)}
    }
}


