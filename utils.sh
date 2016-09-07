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

# Check the ssh accessibility of a remote computer.
# ./access_no_pswd mon_username remote_address
function access_no_pswd {
	# $1 is username
	# $2 is the remote address
	ssh -o StrictHostKeyChecking=no \
		-o BatchMode=yes \
		-o PasswordAuthentication=no \
		-o ChallengeResponseAuthentication=no \
		-q $1@$2 exit
}

# Check all accessible hosts from a list.
# ./keep_no_pswd_only mon_username hosts_list...
function keep_no_pswd_only {
	# $1 is username
	# ("${@:2}") (the rest) is the list of hosts to test
	username=$1
	hosts=("${@:2}")
	for host in "${hosts[@]}" ; do
		access_no_pswd $1 $host
		if [ $? -eq 0 ]; then
			echo "$host"
		fi
	done
}
