#!/bin/bash

#Variable declaration for the dated cache filename
CACHE_FILE_NAME="pingsweep-$(date +"%FT%H%M")"

#Variable declaration for SCAN RESULTS folder

#To find the Ping Sweeper folder and save the test results in
PS_DIR="$(find / -type d -name PingSweeper-main 2>/dev/null)"

#The PATH to the newly created Scan results subfolder
newScanResultsDirPATH="$PS_DIR/scanresults/scan-$(date +"%FT%H%M")"

#Cache file creation and full permission assignment
( sudo touch $PS_DIR/cache/$CACHE_FILE_NAME.txt && sudo chmod 777 $PS_DIR/cache/$CACHE_FILE_NAME.txt )

#Nmap Availability Check
DPKGS="-s" #This is the -s switch to check on the packages status
NMAPcheckValue=$(dpkg $DPKGS nmap | grep "installed" | cut -d " " -f 4) #If Nmap is installed the return value would be "installed" 

#The core script will only run if Nmap can be detected otherwise the script will be terminated.
if [ "$NMAPcheckValue" == "installed" ]
then

echo "    ____   ____ _   __ ______                            "
echo "   / __ \ /  _// | / // ____/ ™                          "
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
echo "--------------------------------Version 0.2 (Alpha)------"
echo "---------------------------for Debian-based systems------"
echo "_____________________________________________________________________________"
echo ""
echo "This is the Alpha Testing Version of PingSweeper™. As of now the script supports IPv4 /24 subnets only."
echo "Later versions will come with more features and support for all subnet sizes,"
echo "and potentially IPv6 Sweeping capabilities as well."
echo "PingSweeper™ is OSS (Open-source software) and falls under the GNU General Public License v3.0."
echo ""
echo ""
echo "Please report any bugs and feedbacks here: cysecdevops@proton.me"
echo "_____________________________________________________________________________"
echo ""
#Creation of the dated test result folder and corresponding files 
( sudo mkdir $newScanResultsDirPATH && sudo chmod 777 $newScanResultsDirPATH )
echo "Folder creation of" $newScanResultsDirPATH "...."
echo ""
sleep 2

echo "---------------------------------START---------------------------------"
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

( echo $(ping -c 1 $input.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":")  >> $PS_DIR/cache/$CACHE_FILE_NAME.txt & )

done

fi

if [ "$nmap" == "Y" ]
then

#NMAP switches that can be added to the nmap command down below if needed. For more information check out the NMAP Manual - man nmap
#
#Ascan="-A"
#Oscan="-O"
#Sc="-sC"
#Sv="-sV"
#p="-p-"

declare -i ScanCounter=1

echo ""
echo "NMAP RESULTS:"
echo ""

for ip2 in $(cat $PS_DIR/cache/$CACHE_FILE_NAME.txt);
do

#Directory creation for scanned Host
( mkdir $newScanResultsDirPATH/$ip2 && sudo chmod 777 $newScanResultsDirPATH/$ip2 )

#NMAP scan result file creation
( sudo touch $newScanResultsDirPATH/$ip2/scanresults-$ip2.txt && sudo chmod 777 $newScanResultsDirPATH/$ip2/scanresults-$ip2.txt )

echo ""
echo $ScanCounter". Nmap scan for:" $ip2
echo ""
#
#NMAP COMMAND
#
#echo $(sudo nmap -Pn -iL $CACHE_FILE_NAME.txt $ip2) > scanresults-$ip2.txt
sudo nmap -T4 -Pn $ip2
#
#
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
cat $PS_DIR/cache/$CACHE_FILE_NAME.txt | grep $input 
echo ""
echo $(cat $PS_DIR/cache/$CACHE_FILE_NAME.txt | grep $input | wc -l) "Active Hosts have been found."


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
