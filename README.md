# script
some scripts

vim2ide: 
This script can help vim become an IDE, it support ctags, taglist, winmanager and omnicpp now. 
I just test it in centos because it use rpm to install ctags. If you want to use it in Debian or Ubuntu, you can install ctags by yourself.
Actually, this script just install zip files and copy some config files to the place. :)


configYum:
This script just to help config a local yum source. It will backup all existed repo files under /etc/yum.repos.d/ and will only have a local source.
This script just help my maintenance colleagues to set a local yum source quickly to install software.
Usage:
config a local source: ./configYum.sh /home/Packages
rollback: ./configYum.sh b


GetFileVersion:
This script will go loop of one folder to get the file version.
Usage:
sh getVersion.sh /home/mouse
Then it will put split all files' path, file name and version into one file.
Detailed info refer to the script :)

optimize_ssh:
This script is a python tool to optimize ssh. It just to replace some config in /etc/ssh folder. 
You can run it by "python optimize_ssh.py"
