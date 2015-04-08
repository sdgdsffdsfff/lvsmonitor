#!/usr/bin/perl
#show virtual serivce of lvs 
#list all the vip and vport
use 5.010;
use strict;
use warnings;
my $lib_path=`echo $0 | sed "s/\$(basename $0)//g"`;
chomp($lib_path);
require("$lib_path/common.pl");



#this scripts will be executed by the remote monitor node
my $CP="/bin/cp";
my $RM="/bin/rm";
my $CAT="/bin/cat";
my $TOUCH="/bin/touch";
my $keepalived_config="/usr/local/etc/keepalived/keepalived.conf";
#/usr/local/etc/keepalived
my $keepalived_configback="/usr/local/etc/keepalived/keepalived.confback";
my $flag=0;
if( ! -f $keepalived_config){
	err_exit("keepalived_config not exits",0);
}

if(-f $keepalived_configback){
	`$RM $keepalived_configback`;
	if($? ne 0){
		err_exit("rm $keepalived_configback failed",0);
	}

}

`$TOUCH $keepalived_configback`;

my $time=get_time();
if($? ne 0){
	err_exit("get time err",0);
}

my @ret=`$CAT $keepalived_config`;
if( $? ne 0){err_exit("cat $keepalived_config failed",0)}
for(@ret){
        if($_=~/!time:[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{2}:[0-9]{2}:[0-9]{2}--upload/){
             s/$_/!time:$time-backup/;
            $flag=1;
            last;
        }
}
write_info($keepalived_configback,@ret);

if($flag!=1){
    my @ret=`$CAT $keepalived_config`;
    @ret=("!time:$time-backup",@ret);
    write_info($keepalived_configback,@ret);
}













