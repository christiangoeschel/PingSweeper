#!/bin/bash

#Creation of the Ping Sweeper folder
#( cd $HOME/PingSweeper )

#Creation and clearing of the Found Hosts file
( touch found_hosts.txt && echo "" > found_hosts.txt )

DPKGS="-s"
NMAPcheckValue=$(dpkg $DPKGS nmap | grep "installed" | cut -d " " -f 4)
#echo "$NMAPcheckValue"

if [ "$NMAPcheckValue" == "installed" ]
then


echo "    ____   ____ _   __ ______                            "
echo "   / __ \ /  _// | / // ____/                            "
echo "  / /_/ / / / /  |/ // / __                              "
echo " / ____/_/ / / /|  // /_/ /                              "
echo "/_/    /___//_/ |_/ \____/                               "
echo "   _____ _       __ ______ ______ ____   ______ ____     "
echo "  / ___/| |     / // ____// ____// __ \ / ____// __ \    "
echo "  \__ \ | | /| / // __/  / __/  / /_/ // __/  / /_/ /    "
echo " ___/ / | |/ |/ // /___ / /___ / ____// /___ / _, _/     "
echo "/____/  |__/|__//_____//_____//_/    /_____//_/ |_|      "
echo "                                                         "
echo "----------------------------------------by Securety------"
echo "------------Scripted by Christian Goeschel Ndjomouo------"
echo "----------------------------------------Version 1.0------"
echo ""
echo "_____________________________________________________________________________"
echo ""
echo "The current PingSweeper version 1.0 only supports IPv4 /24 subnets."
echo "Later versions will come with more features and support for all subnet sizes,"
echo "and potentially IPv6 Sweeping capabilities as well."
echo ""
echo ""
echo "Please report any bugs and feedbacks here: cndjomouo@icloud.com"
echo "_____________________________________________________________________________"
echo ""
echo ""
echo "What is the Network ID of your Target Network (Syntax: XXX.XXX.XXX) ? :"
read input

echo "Do you want to enumerate every Port on the detected active hosts ? (Y / N):"
read nmap


if [ "$input" == "" ]
then
echo "Missing Argument: You forgot to specify an IPv4 Network ID!"
echo "Correct Syntax: XXX.XXX.XXX"
echo "Please try again!"

else
echo "Network ID: " ${input}".0"
echo ""

#This for-loop will iterate from 1 to 254 and ping every possible Host IPv4 address in the specified target network  and if an ICMP reply is detected
#the script will save the active hosts IPv4 in the cache file - found_hosts.txt - 
for ip in `seq 1 254`;
do

( echo $(ping -c 1 $input.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":")  >> found_hosts.txt & )

done

fi

if [ "$nmap" == "Y" ]
then

#NMAP switches that can be added to the nmap command down below if needed. FOr more information check out 
#the NMAP Manual - man nmap
#
#Ascan="-A"
#Oscan="-O"

for ip2 in $(cat found_hosts.txt);
do

echo "Nmap scan for:" $ip2
sudo nmap -T4 -Pn $ip2
echo ""
echo ""

done

echo "Do you want to see the list of active hosts ? (Y/N):"
read printresults

else

echo "Do you want to see the list of active hosts ? (Y/N):"
read printresults

fi

if [ "$printresults" == "Y" ]
then
cat found_hosts.txt | grep $input
echo "" > found_hosts.txt

else
echo "End."
echo "" > found_hosts.txt

fi



else

echo "_________________________________________________________________________________"
echo ""
echo "Please install Nmap on your system in order to use PingSweeper."
echo "Use this command to install Nmap: sudo apt install nmap -y"
echo "_________________________________________________________________________________"
exit 1

fi
