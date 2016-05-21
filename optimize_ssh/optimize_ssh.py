import os
import sys

def FileContentReplace(filename,src,dest,comment='#'):
	'''filename is the file which to find out the src string to replace with dest string'''
	fp=open(filename,'r+')
	fp.seek(0)
	lines=fp.readlines()
	fp.seek(0)
	fp.truncate()
	i=0
	isfind=False
	for line in lines:
		i=i+1
		line.strip()
		if line.find(comment)==0:
			continue
		if line.find(src)>=0:
			print('do %d' % i)
			lines[i-1]=dest
			isfind=True
			break
	if False==isfind:
		lines.append(dest)
	fp.writelines(lines)
	fp.flush()
	fp.close()

def AddContent(filename,content):
	fp=open(filename,'a+')
	fp.seek(0,2)
	fp.write('\n')
	fp.write(content)
	fp.flush()
	fp.close()

def AddRule():
	FileContentReplace('/etc/ssh/ssh_config','GSSAPIAuthentication yes','GSSAPIAuthentication no\n')
	FileContentReplace('/etc/ssh/sshd_config','GSSAPIAuthentication','GSSAPIAuthentication no\n')
	FileContentReplace('/etc/ssh/sshd_config','UseDNS','UseDNS no\n')
	FileContentReplace('/etc/ssh/sshd_config','IgnoreRhosts','IgnoreRhosts yes\n')

def Main():
	print('hello, begin to update config')
	AddRule()
	print('end')

if __name__=='__main__':
	Main()
