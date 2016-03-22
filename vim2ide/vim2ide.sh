#! /bin/bash

ORIG_DIR=`pwd`
USER=`whoami`

VIM_DIR=$HOME/.vim
TAGLIST_FILE=taglist_46.zip
WINMANAGER_FILE=winmanager.zip
OMNICPP_FILE=omnicppcomplete-0.41.zip

if [ ! -d $VIM_DIR ]
then
	echo "mkdir $VIM_DIR"
	mkdir $VIM_DIR
fi


#copy vim rc file
cp vimrc $HOME/.vimrc
cp ctags.rc $HOME/.ctags


#install ctags
PLATFORM=`uname -i`
CTAGS=''

if [ $PLATFORM = 'x86_64' ]
then
	CTAGS='ctags-5.8-13.el7.x86_64.rpm'
else
	CTAGS='ctags-5.8-2.el6.i686.rpm'
fi
cd $ORIG_DIR/ctags
which ctags > /dev/null
if [ $? -ne 0 ]
then
	if [ $USER != root ]
	then
		echo 'you should be root to install ctags'
		exit 1
	fi
	echo 'install ctags'
	rpm -ivh $CTAGS
	if [ $? -ne 0 ]
	then
		echo 'install failed'
		exit 1
	fi
	echo 'ctags installed'
else
	echo 'ctags already installed'
fi

#install taglist
echo 'install taglist'
cd $ORIG_DIR/taglist
cp $TAGLIST_FILE $VIM_DIR
cd $VIM_DIR
unzip -u $TAGLIST_FILE > /dev/null
rm -f $TAGLIST_FILE

#install WinManager
echo 'install winmanager'
cd $ORIG_DIR/winmanager
cp $WINMANAGER_FILE $VIM_DIR
cd $VIM_DIR
unzip -u $WINMANAGER_FILE > /dev/null
rm -f $WINMANAGER_FILE

#install omnicppcomplete
echo 'install omnicppcomplete'
cd $ORIG_DIR/omnicppcomplete
cp $OMNICPP_FILE $VIM_DIR
cd $VIM_DIR
unzip -u $OMNICPP_FILE > /dev/null
rm -f $OMNICPP_FILE







