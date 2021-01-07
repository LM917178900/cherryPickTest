#!/bin/bash

source /etc/profile

echo "-- 进入SQM后端工程目录"
cd /data/sqm-app/server/sqm/project/SQM

if [ ! -n "$1" ]; then
    echo "-- param is null, so checkout master"
    git checkout master
else
    echo "-- git checkout $1"
    git checkout $1
fi

echo "-- git pull"
git pull

echo "-- 编译并跳过单元测试"
mvn clean package -Puat -Dmaven.test.skip=true -P test

echo "-- 删除sqm旧的jar"
rm -rf /data/sqm-app/server/sqm/sqm-app.jar

echo "-- 拷贝新的jar包到指定安装目录下"
cp /data/sqm-app/server/sqm/project/SQM/sqm-app/target/sqm-app.jar  /data/sqm-app/server/sqm/sqm-app.jar


# 根据SQM进程名称杀死SQM进程号
echo '-- kill SQM process start'
SQM_PID=`ps -ef|grep sqm-app.jar|grep -v grep|grep -v PPID|awk '{ print $2}'`
echo 'found SQM PID list:' $SQM_PID
for pid in $SQM_PID
    do
    # 杀掉进程
    kill -9 $pid
    echo "killed $pid"
    done
echo "-- kill SQM process end"


echo "-- 进入指定目录重新启动工程"
cd /data/sqm-app/server/sqm/
nohup java -jar sqm-app.jar > sqm-app.out 2>&1 &

# 显示日志
tail -200f sqm-app.out





