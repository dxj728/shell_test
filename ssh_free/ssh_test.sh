#!/bin/bash

apt install -y ssh expect

LINE=`cat IP | egrep -v '^\s*$' | wc -l`

if [[ -e /root/.ssh/id_rsa.pub && -e /root/.ssh/id_rsa && -e /root/.ssh/authorized_keys ]]
then
	cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys 
else
	ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
	cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys
fi

I=1
while (( $I < $LINE ))
do
	I=`expr $I + 1`
	IP=$(awk 'NR=='$I' {print $1}' ./IP)
	PASSWORD=$(awk 'NR=='$I' {print $2}' ./IP)
	expect -c "
		set timeout -1;
		spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@$IP;
		expect {
			\"(yes/no)?\" { send \"yes\r\"; }
			\"*assword:\" { send \"$PASSWORD\r\"; }
		};
		expect \"*assword:\" 
		send \"$PASSWORD\r\";
		expect EOF " 
done
