#!/bin/bash
declare -f showHelp
declare -f parse

showHelp()
{
cat <<EOF
usage: $0 [-s server] [-h] [-v] <-p port>
	-s server
	-p port,80 or 1000-2000 (from 1000 to 2000)
	-h display this help and exit
EOF
exit 1
}

# 解析参数
parse()
{
	verbose=false
	while getopts ":s:p:h" arg
	do
		case $arg in
			s)
				server=$OPTARG
				;;
			p)
				port=$OPTARG
				;;
			h)
				showHelp
				;;
			:|?|*)
				showHelp
				;;
		esac
	done

}

isDigit()
{
	if [[ $# -lt 1 ]]
	then
		return 1
	fi
	target=$1
	if [[ $1 =~ ^[0-9]+$ ]]
	then
		return 0
	else
		return 1
	fi
}

checkArgs()
{
	# 检查参数是否成功输入
	if [[ -z "$server" ]]
	then
		server=localhost
	fi

	while [[ -z "$port" ]]
	do
		read -p "Please type port: " port
	done	
	split=(${port//-/ }) # 字符串替换，把-替换成空格，结果成为数组的值
	if [[ ${#split[@]} -ge 2 ]]
	then
		from=${split[0]}
		to=${split[1]}
	else
		from=${split[0]}
		to=${split[0]}
	fi
	if ! isDigit $from
	then
		echo ERROR: $from is not a valid port!
		exit 1
	fi
	if ! isDigit $to
	then
		echo ERROR: $to is not a valid port!
		exit 1
	fi
}

scan()
{
	if [[ $# -lt 2 ]]
	then
		showHelp
	fi
	if [[ $# -ge 3 ]]
	then
		local -r server=$1
		local -r from=$2
		local -r to=$3
	else
		local -r server=$1
		local -r from=$2
		local -r to=$from
	fi
	nc -zv $server $from-$to 2>&1 \
	       	| grep -v -i "Connection refused" \
	       	| awk -F' ' 'BEGIN{printf("%-15s\t%-5s\t%-15s\n", "Server","Port","Protocol");}{printf("%-15s\t%-5d\t%-15s\n", $3,$4,$6)}'
}

parse $@
checkArgs $@
time scan $server $from $to
