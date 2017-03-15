#!/bin/bash
#date:2017-3-9
#author:bbs_ld
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
export PATH

####Stop iptables
iptables -F
service iptables stop  >/dev/null 2>&1

#######Initialize fastDFS 


#########install fastDFS Storage###

function init(){
    ###def variate
    #$1=""
    tar xf fastdfs-nginx-module_v1.16.tar.gz
    tar xf FastDFS_v5.08.tar.gz
    unzip -q libfastcommon-master.zip

    cd libfastcommon-master
    ./make.sh >/dev/null 2>&1
    ./make.sh install >/dev/null 2>&1
    ln -s /usr/lib64/libfastcommon.so /usr/local/lib/
    ln -s /usr/lib64/libfastcommon.so /usr/lib/
    
    cd ../FastDFS
    ./make.sh >/dev/null 2>&1
    ./make.sh install >/dev/null 2>&1
    
    if [[ $? -eq 0 ]];then
        echo -e "\033[32;1mFastDFS initial-install over \033[0m"
    else
        echo -e "\033[31;1mFastDFS initial-install failed. \033[0m"
	exit 1
    fi
    
    cp /etc/fdfs/client.conf.sample /etc/fdfs/client.conf
    cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf
    cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf	
    ###Input tracker server ip
    trip1="192.168.15.181"
    trip2="192.168.12.123"
    
    while read -p "Input tracker server ipaddress:" Tracker_IP1
    do
            if [ "$Tracker_IP1" != "$trip1" ] || [ "$Tracker_IP1" != "$trip2" ];then
                    read -p "input true ip:" tip1
                    echo  $tip1
                    continue
               elif read -p "input2 true ip:" tip2
                    then echo "$tip" "$tip1" "$tip2"
                    break
               else
                    echo "error"
                    exit 1
            fi
    done
       read -t 10 -p "Input tracker server ipaddress:" Tracker_IP1
       echo -e "\033[32;1m Tracker server ip:$Tracker_IP1\033[0m"

}

#####install fastDFS Tracker

function tracker(){
#   IP_ADDR_eth0=ifconfig eth0|sed -n 2p|awk -F"[ |: ]+" '{print $4}'
#   IP_ADDR_eth1=ifconfig eth1|sed -n 2p|awk -F"[ |: ]+" '{print $4}'
   mkdir -p /opt/tracker 
   track_PATH="/opt/tracker"
   sed -i "s#base_path=\/home\/yuqing\/fastdfs#base_path=\/opt\/$track_PATH#g" /etc/fdfs/tracker.conf   
   echo "/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf start" >> /etc/rc.d/rc.local 
####start tracer service
   /usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf start 
if [ $? -eq 0 ];then
 echo -e "\033[32;1m Track install Success. \033[0m"
else
 echo -e "\033[31;1m Track install Faild. \033[0m"
 exit 1
fi
   
}

function storage(){
   mkdir -p /opt/storage 
   stor_PATH="/opt/storage"
   ##Edit storage configure
   sed -i "s#base_path=\/home\/yuqing\/fastdfs#base_path=$stor_PATH#g" /etc/fdfs/storage.conf
   sed -i "s#store_path0=\/home\/yuqing\/fastdfs#store_path0=$stor_PATH#g" /etc/fdfs/storage.conf
   sed -i "s/209.121:22122/15.181:22122/g" /etc/fdfs/storage.conf
   sed -i -e "/15.181:22122/a\tracker_server=192.168.12.123:22122" /etc/fdfs/storage.conf

   ###Edit client configure 
   sed -i "s#base_path=\/home\/yuqing\/fastdfs#base_path=$stor_PATH#g" /etc/fdfs/client.conf
   sed -i "s/0.197:22122/15.181:22122/g" /etc/fdfs/client.conf
   sed -i -e "/15.181:22122/a\tracker_server=192.168.12.123:22122" /etc/fdfs/client.conf

   ###Auto boot service
   echo "/usr/bin/fdfs_storaged /etc/fdfs/storage.conf start" >> /etc/rc.d/rc.local

   ###start storage service 
   /usr/bin/fdfs_storaged /etc/fdfs/storage.conf start

   ###Start Prog
    if [ $? -eq 0 ];then
     echo -e "\033[32;1m Storage install Success. \033[0m"
    else
     echo -e "\033[31;1m Storage install Faild. \033[0m"
     exit 1
    fi
}

if [[  $# -eq 0 ]];then
	echo  -e "\n\tUSAGE: $0 {storage|tracker|all}\n"
	echo  -e "\t\tdescription: install storage, storage groupnumber(default group1)\n"
	exit
fi

case $1 in 
  "all")
	init
	tracker
	storage
	;;
#  "init")
#	init
#	;;
  "tracker")
	init
	tracker
	;;
  "storage")
	init
	storage
	;;

esac 
