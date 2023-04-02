# PingSweeper v0.1 Alpha


Ping Sweeper by Securety is a Bash Script that can be used as an IP Network Scanning tool to map out a given 
network subnet and detect any live/active hosts in it.

The applied technique is called ICMP sweeping or ping scanning and is combined with a free software for network discovery
and security auditing called 'Nmap'. The script automates the port enumeration conducted by Nmap by iterating through all 
the active hosts that have previously been detected during the ICMP sweep/Ping Sweep and passing them to Nmap which does the rest.

PingSweeper does not guarantee 100% accuracy due to the fact that certain hosts use access lists/firewall rules that deny ICMP requests 
which will hide the host from PingSweeper. 

The script is still in it's early development stage and currently made available for testing, inspirational and educational purposes.
As of now the script supports IPv4 /24 subnets only and is being developed on Kali Linux which is a Debian-based Linux distribution. 
The script can still be altered and made compatible with other Linux or Mac OS systems.

Later versions will come with more features, support for all subnet sizes, other OS and potentially ICMPv6 Sweeping capabilities as well.

PingSweeper is OSS (Open-source software) and falls under the GNU General Public License v3.0.


Usage:

Before you can use the Bash script I would recommend to create a seperate folder and place the script in it.
The PingSweeper generates dated cache/result files for each sweep and saves them in the script's directory.


In order to execute the script you will have to make it executable with the following command:


`'sudo chmod 777 pingsweep-v01-0422-debian.sh'`


To launch the script run:

`'source pingsweep-v01-0422-debian.sh'`

or

`'./pingsweep-v01-0422-debian.sh'`


Happy Sweeping!
And you will most definitely encounter bugs and errors. 
Please let me know at this email cysecdevops@proton.me


