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
# ./access_no_pswd mon_username remote_address
function access_no_pswd {
	# $1 is username
	# $2 is the remote address
	ssh $SSH_OPTIONS $1@$2 exit
}

# Check all accessible hosts from a list.
# ./keep_no_pswd_only mon_username max_procs hosts_file
function keep_no_pswd_only {
	# $1 is username
	# $2 is max number of processes
	# $3 file containing the list of hosts to test
	cat $3 \
		| xargs -i --max-procs=$2 bash -c "ssh $SSH_OPTIONS $1@{} exit && echo {} || :" \
		| grep -vi warning
}

# Ability to use the functions with ./utils.sh for eg.:
# ./utils.sh keep_no_pswd_only mpizenbe 20 computers.txt
"$@"
