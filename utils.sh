#!/usr/bin/env bash

# List the computers accessible over a network.
# ./computers target_address netmask rtt grep_address_filter
function computers {
	# $1 is the base address
	# $2 is the netmask
	# $3 is the max round trip time
	# $4 is the address filter
	nmap -sn $1/$2 --max-rtt-timeout $3 | grep "$4" | cut -d' ' -f5
}

# List the computers accessible on the enseeiht network.
function n7_computers {
	computers 147.127.133.1 20 60ms .enseeiht.fr
}

SSH_OPTIONS="-o StrictHostKeyChecking=no \
-o BatchMode=yes \
-o PasswordAuthentication=no \
-o ChallengeResponseAuthentication=no \
-q"

# Check the ssh accessibility of a remote computer.
function access_no_pswd {
	# $1 is username
	# $2 is the remote address
	ssh $SSH_OPTIONS $1@$2 exit
}

# Check all accessible hosts from a list.
function keep_no_pswd_only {
	# $1 is username
	# $2 file containing the list of hosts to test
	# $3 is max number of processes
	cat $2 \
		| xargs -i --max-procs=$3 bash -c "ssh $SSH_OPTIONS $1@{} exit && echo {} || :" \
		| grep -vi warning
}

# Execute a simple script on the hosts
function host_script {
	# $1 is username for ssh connection
	# $2 is the file containing the list of hosts
	# $3 is the max number of processes to use
	# $4 is the script to execute
	xargs -r -a $2 -i --max-procs=$3 \
		bash -c "ssh $SSH_OPTIONS $1@{} '$4 >/dev/null 2>&1 &' && echo {} || :" \
		| grep -vi warning
}

# Create a folder on all hosts
function create_folder {
	# $1 is username
	# $2 is the file containing the list of hosts
	# $3 is the max number of processes to use
	# $4 is the folder path
	xargs -r -a $2 -i --max-procs=$3 \
		bash -c "ssh $SSH_OPTIONS $1@{} 'mkdir -p $4' && echo {} || :" \
		| grep -vi warning
}

# Deploy a file or folder to a destination file or folder to all the hosts.
function deploy {
	# $1 is username for scp connection
	# $2 is a file containing the list of hosts to copy to
	# $3 is the max number of processes to use
	# $4 is file/folder to copy
	# $5 is destination file/folder in host
	xargs -r -a $2 -i --max-procs=$3 \
		bash -c "rsync -qae 'ssh $SSH_OPTIONS' $4 $1@{}:$5 && echo {} || :" \
		| grep -vi warning
}

# Ability to use the functions with ./utils.sh
"$@"
