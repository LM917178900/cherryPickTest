# 项目名称
APPLICATION="qit-server"

#// 找到应用对应的jar包对应的进程id，并杀掉，（常规,通过端口找到进程id，再杀掉进程）
# 项目启动jar包名称
APPLICATION_JAR="${APPLICATION}.jar"
#// ps -ef 是用标准的格式显示进程，无内存信息
#// ps aux 是用BSD的格式来显示,含内存使用信息
#// https://www.cnblogs.com/mydriverc/p/8303242.html

#// ps -ef |grep qit-server.jar 查询与qit-server.jar相关的进程（得到两条信息，一条是运行java,一条是grep搜索信息）
#// grep -v xx 再搜索结果中排除有关xx的信息
#// grep -v grep 也可以如此 grep java 找出与java有关的信息（按理只有一条数据）
#// awk '{print $2 }'打印改行的第二个参数;第一个是用户名称root,第二个是进程编号；
#// PID=$(XXX)把xxx赋值给局部变量PID
PID=$(ps -ef | grep ${APPLICATION_JAR} | grep -v grep | awk '{ print $2 }')
#// 认证系统：ps -ef|grep mf-auth-center-server-1.0.0.jar |grep java|awk '{print $2}'
#// uat系统：
#//  -z "$PID" PID是否是null
if [ -z "$PID" ]
then
#  // 如果PID是null,输出应用已经停止；
    echo ${APPLICATION} is already stopped

#    // PID 还存在，kill,输出应用已经停止；
else
    echo kill  ${PID}
    kill -9 ${PID}
    echo ${APPLICATION} stopped successfully


#    // 然后,重新启动应用，输出应用启动成功；
fi

#// 设置启动java 应用的初始运行堆内存，最大运行堆内存
nohup java -Xms1g -Xmx1g -jar qit-server.jar > qit-server.out 2>&1 &
#// 输出应用重启成功
echo ${APPLICATION} started successfully
