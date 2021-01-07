#!/bin/sh
#
# redis        init file for starting up the redis-sentinel daemon
#
# chkconfig:   - 21 79
# description: Starts and stops the redis-sentinel daemon.

# Source function library.
. /etc/rc.d/init.d/functions

name="redis-sentinel"
exec="/usr/bin/$name"
shut="/usr/bin/redis-shutdown"
pidfile="/var/run/redis/sentinel.pid"
SENTINEL_CONFIG="/etc/redis-sentinel.conf"

#// -e filename 	如果 filename存在，则为真 	[ -e /var/log/syslog ]
#//
[ -e /etc/sysconfig/redis-sentinel ] && . /etc/sysconfig/redis-sentinel
lockfile=/var/lock/subsys/redis

start() {

#  // https://blog.csdn.net/yaoyujie157/article/details/103876408
#// -f FILE：测试文件是否为普通文件
#// exit 6 6???(退出的原因，经过)
    [ -f $SENTINEL_CONFIG ] || exit 6

#    // -x FILE：测试当前用户指定文件是否有执行权限
#// exit 5(退出的原因，经过)
    [ -x $exec ] || exit 5

#    // 否则就开始启动
    echo -n $"Starting $name: "
    daemon --user ${REDIS_USER-redis} "$exec $SENTINEL_CONFIG --daemonize yes --pidfile $pidfile"
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
}

stop() {
    echo -n $"Stopping $name: "
    [ -x $shut ] && $shut $name
    retval=$?
    if [ -f $pidfile ]
    then
        # shutdown haven't work, try old way
        killproc -p $pidfile $name
        retval=$?
    else
        success "$name shutdown"
    fi
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}

restart() {
    stop
    start
}

reload() {
    false
}

rh_status() {
    status -p $pidfile $name
}

rh_status_q() {
    rh_status >/dev/null 2>&1
}


case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
        restart
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart}"
        exit 2
esac
exit $?
