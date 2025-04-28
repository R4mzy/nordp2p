# nordp2p 
## Deprecating, Archiving
Unmaintained, unused, unloved (sniff), unnecessary, un...
Nord has better Linux support, I don't use them anymore, I stopped using this long before I stopped using them...
;) JJF-250428

### a script for connecting to NordVPN P2P servers with OpenVPN on Linux (Ubuntu) 
It will also launch a daemon for transmission (a BitTorrent client).  
  
Should the VPN connection be terminated or fail, OpenVPN will kill the transmission daemon too. 
  
Built for Ubuntu Linux. It will probably work elsewhere but you may need to edit some things. 
  
## Installation and usage info: 
### Depends on OpenVPN being installed: 

  	$ sudo apt-get install openvpn
Assuming OpenVPN is installed at its default location of `/etc/openvpn/`. 
  
### You will need a NordVPN subscription, and you'll need to download their OpenVPN files.  

  	$ wget https://nordvpn.com/api/files/zip
Those files should be extracted to `/etc/openvpn/nordvpn/`. Here's a one-liner:    

  	 $ sudo mkdir /etc/openvpn/nordvpn && sudo mv zip /etc/openvpn/nordvpn/ && sudo unzip /etc/openvpn/nordvpn/zip && sudo rm /etc/openvpn/nordvpn/zip
  
### Clone/download this repo, and copy the files to where they should go. 
Typically, *nordvpn.up* and *nordp2p.list* would go to `/etc/openvpn`, while *nordp2p.sh* would go to `/usr/local/sbin`. That *nordp2p.sh* file should also be executable.  

This one-liner will do that for you:  

    $ git clone https://github.com/R4mzy/nordp2p.git && sudo cp ./nordp2p/nordvpn.up ./nordp2p/nordp2p.list /etc/openvpn/ && sudo cp ./nordp2p/nordp2p.sh /usr/local/sbin/ && sudo chmod +x /usr/local/sbin/nordp2p.sh
  
The *nordvpn.list* file was last generated on *17 July 2017*. Nord might have changed their P2P servers since then.  
The generation of the list has not been automated because I haven't figured out how to do that yet.  
  *HELP WANTED*   
  
### Supply your NordVPN credentials in the *nordvpn.up* file, which is now in `/etc/openvpn/`.  
See the notes included in the file for more info. I like vim. Use whatever editor you prefer.

    $ sudo vim /etc/openvpn/nordvpn.up

Once you have entered your credentials into the file, you might want to lock it down: 

    $ sudo chmod 640 /etc/nordvpn/nordvpn.up && sudo chown root:root /etc/nordvpn/nordvpn.up 
  
TODO: confirm this file still works with the commented lines included.  
  
### You're mostly done. 
Assuming `/usr/local/sbin` is included in your $PATH variable, you can call the script with:  

    $ sudo nordp2p.sh
That will give you the usage instructions. You basically just use *start* and *stop*. 
  
### Automate the thing so it runs on boot (if you want).  
Edit your root user's crontab:  

    $ sudo crontab -e
Add this line to it:  

    @reboot sudo /usr/local/sbin/nordp2p.sh start
    
### Look at the script file.  
If you want to customise things. Or improve them. Suggestions are welcome.  
