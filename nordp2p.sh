#!/bin/bash

# global daemon name
daemonName="nordp2p"

case "$1" in
	start)
		
		# variables for OpenVPN and NordVPN configuration and log files
		openvpnFiles=/etc/openvpn
		nordvpnFiles=$openvpnFiles/nordvpn
		nordvpnCreds=$openvpnFiles/nordvpn.up
		nordp2pLog=/var/log/nordp2p.log
		
		# pick a P2P server for this instance
		p2pList=$openvpnFiles/nordp2p.list
		p2pServer=$(shuf -n 1 $p2pList)
		
		echo 'Starting OpenVPN using '$p2pServer' and then starting the transmission-daemon...'
		sudo openvpn \
			--daemon $daemonName \
			--config $nordvpnFiles/$p2pServer'.udp1194.ovpn' \
			--auth-user-pass $nordvpnCreds \
			--log nordp2pLog \
			--script-security 2 \
			--up "/etc/init.d/transmission-daemon start" \
			--down "/etc/init.d/transmission-daemon stop"
		echo
		echo 'VPN session established, P2P transfers are now safe(r)!'
		echo To kill, run: nordp2p.sh stop
		echo \(sudo will probably be necessary\)
		sleep 1
		;;
	stop)
		echo Killing previously-started OpenVPN daemons matching the name \'$daemonName\'...
		sudo pkill -SIGTERM -f $daemonName
		echo ... done.
		sleep 1
		;;
	*)
		echo Usage: nordp2p.sh start\|stop
		echo start: initiates an OpenVPN daemon to connect to a randomly selected NordVPN P2P server from the nordp2p.list file, \
			 then initialises the BitTorrent transmission-daemon.
		echo stop: sends the SIGTERM signal to any process whose name matches the \'$daemonName\' pattern. \
			OpenVPN processes that are started using this script will also end the transmission-daemon service as part of their interface teardown.
		exit 1
		;;
esac

exit 0

#
# TODO
#	existenc-checks for /etc/openvpn/ dir, /etc/openvpn/nordvpn/ dir, nordvpn.up file, nordp2p.list file, others...
#		nordvpn.up: if no file, prompt the user for username and password and generate a file
#			ensure some timeout on the prompt so that the script won't prevent startup for too long
#		other files: abort script (send to log)
#	make the up/down actions more general to support not-just-transmission
#		build a variable for listing up/down actions 
#			maybe link that to another config file (/etc/nordp2p/nordp2p.conf)?
#			if we do this, we need existence-checks for the config file too
#	record the PID of processes launched by this script
#		then rework 'stop' to end only those processes, rather than 'name-matching'
#