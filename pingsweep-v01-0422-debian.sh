#!/bin/bash

#Creation of the detected hosts cache file

CACHE_FILE_NAME="pingsweep-$(date +"%FT%H%M")"

( touch $CACHE_FILE_NAME.txt )

#Nmap Availability Check

DPKGS="-s" #This is the -s switch to check on the packages status
NMAPcheckValue=$(dpkg $DPKGS nmap | grep "installed" | cut -d " " -f 4) #If Nmap is installed the return value would be "installed" 

#The core script will only run if Nmap can be detected otherwise the script will be terminated.
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
echo "--------------------------------Version 0.1 (Alpha)------"
echo "---------------------------for Debian-based systems------"
echo "_____________________________________________________________________________"
echo ""
echo "This is the Alpha Testing Version of PingSweeper. As of now the script supports IPv4 /24 subnets only."
echo "Later versions will come with more features and support for all subnet sizes,"
echo "and potentially IPv6 Sweeping capabilities as well."
echo "PingSweeper is OSS (Open-source software) and falls under the GNU General Public License v3.0."
echo ""
echo ""
echo "Please report any bugs and feedbacks here: cysecdevops@proton.me"
echo "_____________________________________________________________________________"
echo ""
echo "----------------------------------START--------------------------------"
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
echo ""
echo "Target Network ID " ${input}".0 is being sweeped and scanned ..."
echo ""

#This for-loop will iterate from 1 to 254 and ping every possible Host IPv4 address in the specified target network  and if an ICMP reply is detected
#the script will save the active hosts IPv4 in the cache file - $CACHE_FILE_NAME.txt - 
for ip in `seq 1 254`;
do

( echo $(ping -c 1 $input.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":")  >> $CACHE_FILE_NAME.txt & )

done

fi

if [ "$nmap" == "Y" ]
then

#NMAP switches that can be added to the nmap command down below if needed. FOr more information check out 
#the NMAP Manual - man nmap
#
#Ascan="-A"
#Oscan="-O"
#Sc="-sC"
#Sv="-sV"
ScanCounter=0
declare -i ScanCounter=1


for ip2 in $(cat $CACHE_FILE_NAME.txt);
do

echo ""
echo $ScanCounter". Nmap scan for:" $ip2
echo "____________________________________________________"
echo ""
sudo nmap -T4 -Pn $ip2
echo ""
echo "____________________________________________________"
ScanCounter=$(( ScanCounter + 1 ))

done
echo ""
echo "Do you want to see the list of active hosts ? (Y/N):"
read printresults

else
echo ""
echo "Do you want to see the list of active hosts ? (Y/N):"
read printresults

fi

#This will print out the found active hosts 
if [ "$printresults" == "Y" ]
then
echo ""
echo "Ping Sweep Results:"
echo ""
cat $CACHE_FILE_NAME.txt | grep $input 
echo ""
echo $(cat $CACHE_FILE_NAME.txt | grep $input | wc -l) "Active Hosts have been found."


else
echo ""
echo "Thank you for using PingSweeper!"

fi
#
#
#This will get executed if Nmap is not detected
else

echo "_________________________________________________________________________________"
echo ""
echo "Please install Nmap on your system in order to use PingSweeper."
echo "Debian-based systems (Ubuntu, Kubuntu, Kali Linux: sudo apt install nmap -y"
echo "RedHat-based systems (Redhat Linux, Rocky Linux, CentOS: sudo dnf install nmap -y"
echo "_________________________________________________________________________________"
exit 1

fi

#End
