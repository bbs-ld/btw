PHP安装fastDFS扩展

原创作品，允许转载，转载时请务必以超链接形式标明文章 原始出处 、作者信息和本声明。否则将追究法律责任。http://369369.blog.51cto.com/319630/771169

1、下载fastDFS源程序，最好与FastDFS服务器版本匹配，这里我下载了FastDFS_v3.06.tar.gz版本，放在/opt/soft目录下。

2、LAMP或LNMP已安装好，PHP安装目录为/usr/local/php

首先安装libfastcommon
cd libfastcommon-master
./make.sh
./make.sh install
创建连接文件到lib
ln -s /usr/lib64/libfastcommon.so /usr/local/lib/
#cd php-fastcommon/

3、步骤
[root@snstest ~]#tar zxvf FastDFS_v3.06.tar.gz
[root@snstest ~]#cd FastDFS
[root@ FastDFS ~]#./make.sh
[root@ FastDFS ~]#./make.sh install
[root@ FastDFS ~]#cd client
[root@ client ~]#make; make install
[root@ client ~]#cd ../php_client

如以上不安装，直接进php-config目录进行编译安装，会报如下错误：
make: *** [fastdfs_client.lo] Error 1

[root@ php_client ~]#/opt/modules/php/bin/phpize //执行php的安装目录下的phpize
[root@ php_client ~]#./configure --with-php-config=/opt/modules/php/bin/php-config
[root@ php_client ~]#make
[root@ php_client ~]#make install

[root@ php_client ~]#cp ../conf/client.conf /etc/fdfs/ ##3.06版本/etc/fdfs/目录下有client.conf
[root@ php_client ~]#mkdir /opt/fastdfs/data/php -p
[root@ php_client ~]#cd /etc/fdfs/
[root@ fdfs ~]#vi client.conf，保存
vim /etc/fdfs/client.conf
	#base_path=/opt/fastdfs/data/php	修改基本路径和存储日志路径
	#tracker_server=172.18.100.171:22122	修改tracker服务器的地址
	#tracker_server=172.18.100.78:22122		备用tracker服务器地址

在php.ini配置文件中加载fastdfs
[root@ fdfs ~]#cd fastdfs-5.05/php_client

[root@ fdfs ~]#cat fastdfs_client.ini >>/opt/modules/php/etc/php.ini

4、重启php-fpm 和 nginx-web服务器即可。在php_client已经有扩展函数说明和程序示例web服务器即可。在php_client已经有扩展函数说明和程序示例

5、验证扩展

[root@ fdfs ~]#cd /opt/soft/FastDFS/php_client
[root@ fdfs ~]#cp fastdfs_test.php /opt/modules/nginx/html/             /opt/modules/nginx/html/是我web服务器目录
打开IE或其它浏览器，输入http://110.172.214.109/fastdfs_test.php，如出现
3.06 fastdfs_tracker_make_all_connections result: 1 array(1) { ["group1"]=> array(12) { ["free_space"]=> int(10542) ["trunk_free_space"]=> int(0) ["server_count"]=> int(2) ["active_count"]=> int(2) ["storage_port"]=> int(23000) ["storage_http_port"]=> int(8888)

如果报以下错，就是没有重启web服务软件，如apache,nginx,fast-php
Fatal error: Call to undefined function fastdfs_client_version() in ï¿½,B on line 6