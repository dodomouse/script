#! /bin/bash

#set -e

function CheckRoot()
{
	#check if current use is root
	CUR_USER=`whoami`
	if [ $CUR_USER != 'root' ]
	then
		echo 'The operation will modify system files, you should be root!!!'
		exit 1
	fi
}

function MkDir()
{
	if [ ! -d $1 ]
	then
		mkdir $1 > /dev/null
	fi
}

function Rollback()
{
	ORIG_DIR=`pwd`
	cd /etc/yum.repos.d > /dev/null
	MkDir /etc/yum.repos.d/configYum_rb
	mv *.repo configYum_rb/ > /dev/null
	mv backup/*.repo . > /dev/null
	rm -fr backup/ configYum_rb/ > /dev/null
	yum clean all > /dev/null
	yum makecache > /dev/null
	yum repolist all 
}

function Create()
{
	echo 'begin to create local yum source........'
	ORIG_DIR=`pwd`
	#backup current config
	if [ ! -d "/etc/yum.repos.d" ]
	then
		echo '/etc/yum.repos.d is not existed, please check your system!!!'
		exit 1
	fi
	cd /etc/yum.repos.d > /etc/null

	MkDir /etc/yum.repos.d/backup
	mv  ./*.repo backup

	#create local.repo
	touch local.repo
	echo '[localrepo]' >> local.repo
	echo 'name=localrepo' >> local.repo
	echo "baseurl=file://$1" >> local.repo
	echo 'gpgcheck=0' >> local.repo
	echo 'enabled=1' >> local.repo
	#cp $ORIG_DIR/local.repo /etc/yum.repos.d/ > /dev/null


	#check if createrepo is existed
	which createrepo > /dev/null
	if [ $? -eq 1 ]
	then
		rpm -ivh createrepo-0.9.9-22.el6.noarch.rpm > dev/null
		if [ $? -ne 0 ]
		then
			echo ' install createrepo failed '
			exit 1
		fi
	fi

	createrepo $1 > /dev/null

	if [ $? -ne 0 ]
	then
		echo 'create repo failed'
		exit 1
	fi

	yum clean all > /dev/null
	yum makecache > /dev/null

	yum repolist all
}



function Help()
{
	echo 'There are ways to call this script, for example:'
	echo '1. To create a local Yum source: ./configYum.sh /tmp/packages'
	echo '2. To rollback previous operation: ./configYum.sh b'
}

function Main()
{
	if [ $# -ne 1 ]
	then
		Help
	elif [ -d $1 ]
	then
		CheckRoot
		Create $*
	elif [ $1 = 'b' ]
	then
		CheckRoot
		Rollback
	else
		Help
	fi
}

Main $*
