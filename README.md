# Distributed Computing Tools

This repository aims at easing the process to execute many tasks
on many computers accessible on a network.

## The workflow

In general, the workflow to execute your tasks will be the following:
```
:==================:
|  YOUR   MACHINE  |
:==================:
    |        /|\ 11. retrieve the results
    |  1. copy|this bash toolbox (scp or ssh+git)
    |  2. copy|python code for distributed computing (scp or ssh+git)
    |  3. copy|tasks list file (scp)
   \|/ 4. get to the server machine (ssh)
:==================: 5. [not required] launch a Tmux in case of disconnection
|  SERVER MACHINE  | 9. launch server with tasks (cf start_computing_server)
:==================:
    |  6. get the list of accessible machines without password (cf n7_computers and keep_no_pswd_only)
    |  7. [not required if accessible in shared home] deploy python code for distributed computing (cf deploy)
    |  8. deploy resources needed for computations (cf create_folder and deploy)
   \|/ 10. start all clients (cf mix of host_script and start_computing_client)
:==================:
| CLIENTS MACHINES |
:------------------:
| CLIENTS MACHINES |
:==================:
```

## Useful tools

### nmap: the network mapper

nmap is a security used to discover hosts and services on a computer network.
For more info about nmap, see [the nmap website](https://nmap.org/)
and [wikipedia page](https://en.wikipedia.org/wiki/Nmap).

See for exemple on the n7 network, the following command:
```bash
$ nmap -sn 147.127.133.1/20 --max-rtt-timeout 60ms

Starting Nmap 7.12 ( https://nmap.org ) at 2016-09-05 22:17 CEST
Nmap scan report for cumulus.enseeiht.fr (147.127.128.3)
Host is up (0.046s latency).
Nmap scan report for stratus.enseeiht.fr (147.127.128.4)
Host is up (0.046s latency).
...
Nmap done: 4096 IP addresses (221 hosts up) scanned in 9.79 seconds
```

### ssh: remote access witchcraft

Just kidding!
Still ssh is a very powerful tool.
I will put here some useful sample command lines.
```bash
# Generate public and private ssh keys.
ssh-keygen

# Connect to vador.enseeiht.fr via ssh and copy your public ssh key
# to the authorized_keys file in your home in vador (to the dark side).
# This enables you to connect later without needing your password.
ssh-copy-id mon_username@vador.enseeiht.fr

# Connect to a machine (la base !).
ssh mon_username@magicarpe.enseeiht.fr # after 400 connections, leviator.enseeiht.fr becomes available

# Execute a local script (sing.sh) on a distant machine (beatles).
ssh me@beatles.enseeiht.fr "bash -s" < sing.sh

# Test if a host is accessible without password (check return code $?)
ssh -o PasswordAuthentication=no -q mpizenbe@kenobi.enseeiht.fr exit
echo $?
```

### fabric: run commands on distant machines

fabric ([website](http://www.fabfile.org/),
[doc](http://docs.fabfile.org/en/latest/index.html))
is a python 2.7 module to run commands on distant machines.

## Contact

Matthieu Pizenberg: matthieu.pizenberg@gmail.com
