# 1、通过键盘输入字符，如果是大写字母就表示大写字母，小写即为小写字母。
#!/bin/bash
#https://blog.51cto.com/woyaoxuelinux/1866118
#----- $1 变量值 ,$1 没有后限定长度？？？
case $1 in

#// 如果是数字就输出"it is digit"
[0-9])

  echo "it is digit"

  ;;
  #// 如果是小写就输出"it id lower"
[a-z])

  echo "it is lower"

  ;;
  #// 如果是大写就输出"it is Upper"
[A-Z])

  echo "it is Upper"

  ;;
  #// 其他，输出"it is Unknown"
*)

  echo "it is Unknown"

  ;;

esac

#  2、只接受参数start ,stop,restart,shutdown.

#!/bin/bash

#

#program
#// $1 in 'start'表示'start'==$1
#// 'start'==$1 就输出"start server"
case $1 in

'start')

  echo "start server..."
  ;;

  #// 'restart'==$1 就输出"restart server"
'restart')

  echo "restart server..."
  ;;

  #// 'stop'==$1 就输出"stop server"
'stop')

  echo "stop server..."
  ;;

  #'status'==$1 就输出"Running"
'status')

  echo "Running..."
  ;;

  #// 其他`basename $0`值显示当前脚本或命令的名字；$0显示会包括当前脚本或命令的路径
*)

  echo "$(basename $0) {start|stop|restart|status}"
  ;;

esac

#3、写一个脚本，可以接受选项参数，而后能获取每一个选项，及选项的参数，
#并能根据选项及参数做出特定的操作。

#!/bin/bash

#// declare声明变量并设置变量的属性
#// "-"可用来指定变量的属性，"+"则是取消变量所设的属性。
declare -i SHOWNUM=0

declare -i SHOWUSERS=0

#// $#：返回所有脚本参数的个数。
#// seq 1 n 遍历1-n这些数值

for I in $(seq 1 $#); do

  if [ $# -gt 0 ]; then

    case $1 in

    -h | --help)

      echo "Usage: $(basename$0) -h|--help -c|--count -v|--verbose"

      exit 0
      ;;

    -v | --verbose)

      let SHOWUSERS=1

      shift
      ;;

    -c | --count)

      let SHOWNUM=1

      shift
      ;;

    *)

      echo "Usage: $(basename$0) -h|--help -c|--count -v|--verbose"

      exit 8
      ;;

    esac

  fi

done

if [ $SHOWNUM -eq 1 ]; then

  echo "Logged users: $(who | wc -l)."

  if [ $SHOWUSERS -eq 1 ]; then

    echo "They are:"

    who

  fi

fi
