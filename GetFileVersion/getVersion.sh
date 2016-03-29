#! /bin/bash
#set -e
exec 3>&1
exec 1> /dev/null
exec 2> /dev/null

CUR_DIR=`pwd`
DEST_DIR=''
OUTPUT_FILE=$CUR_DIR/getverison.txt

DEFAULT_VERSION=''
function Help
{
	echo 'hello' >&3
}

function GetDestDir
{
	if [ $# -lt 1 ]
	then
		if ! read -t 60 -p "Please input the directory: " DEST_DIR
		then
			echo 'No input directory and exit' >&3
			exit 1
		fi
	elif [ $# -gt 1 ]
	then
		echo 'Too many parameters!' >&3
		Help
	else
		Help
	fi
}

function ReadVersion
{
	DIR=`dirname $1`
	BASENAME=`basename $1`
	ls -l $1 | grep ^l > /dev/null
	if [ $? -eq 0 ]
	then
		REALFILE=`ls -l $1 | gawk '{print $10}'`  #如果是软链接文件，则打印其真正的文件路径
		echo "$DIR        $BASENAME        $REALFILE" >> $OUTPUT_FILE
	else
		FILENAME=`echo ${BASENAME%.*}`  #获取文件名
		VERSION=`echo $BASENAME|gawk -F . '{print $NF}'`  #获取后缀名
		if [ $VERSION -gt 0 ]
		then
			echo "$DIR        $FILENAME        $VERSION" >> $OUTPUT_FILE
		else
			echo "$DIR        $BASENAME" >> $OUTPUT_FILE
		fi
	fi
}

function ScanDir
{
	for file in `ls $1`
	do
		JUDGE=$1/$file
		if [ -f $JUDGE ]
		then
			ReadVersion $JUDGE  #读取版本信息
		elif [ -d $JUDGE ]
		then
			ScanDir $JUDGE #递归扫描文件夹
		fi
		
	done
}

function Main
{
	DIR=`dirname $1`
	BASENAME=`basename $1`
	ScanDir $DIR/$BASENAME
}

DEST_DIR=$1
Main $1

