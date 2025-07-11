#!/bin/bash
sudo mount -o remount,rw / > /dev/null

T1=$1
T2=$2
St=$3

count=0

Dat=$(date +%Y/%m/%d)

if [ "$T2" == "" ];  then
 echo Usage : ./parselog.sh StartTime StopTime Switch
 echo ie :   ./parselog.sh 18:00 22:59 
 echo Switch = "Null - No Filter", "C (Call)", or "U (Unique)"
 exit
fi

echo "Options Null, [C]all,  [U]nique"
dts1="$Dat $T1:00"
dts2="$Dat $T2:00"

timestamp1=$(date -d "$dts1" +%s)
timestamp2=$(date -d "$dts2" +%s)
echo "Start Time:$dts1 $timestamp1"
echo "End Time:$dts2 $timestamp2"

#echo "TS1:$timestamp1"
#echo "TS2:$timestamp2"

epoch1=$(date -s "@$timestamp1" +%s)
epoch2=$(date -d "@$timestamp2" +%s)
#echo "EP1:$epoch1"
#echo "EP2:$epoch2"

##### Main program #########

#F1=$(ls -altr /var/log/pi-star/MMDVM-20* | tail -n 1 |cut -d ' ' -f12)
#ls -altr /var/log/pi-star/MMDVM-20* | tail -n 1 | cut -d ' ' -f12,12

Line=$(cat /var/log/pi-star/MMDVM-20* | grep 'transmission from')

#echo "$Line"

if [ "$3" == "U" ]; then 
   echo "Mode = Sort and filter on Call - Unique"
#	Calls=$(echo "$Line" | cut -d " " -f 2,3,14,18 | sort -k3 | uniq -f 3 -u )
	Calls=$(echo "$Line" | cut -d " " -f 2,3,14,18 | sort -k3,3 -u )

elif [ "$3" == "C" ]; then
    echo "Mode = Sort on Call"
#	Calls=$(echo "$Line" | cut -d " " -f 2,3,14,18 | sort -t " " -k2,2 )
	Calls=$(echo "$Line" | cut -d " " -f 2,3,14,18 | sort -k3,3)
else
	echo "Mode = No Filter "
	Calls=$(echo "$Line" | cut -d " " -f 2,3,14,18 )
fi 

IFS==$(echo -en "\n\b")

for item in $Calls
do
	LineDT=$(echo "$item" | cut -d ' ' -f1,2)
	Dur=$(echo "$item" | cut -d ' ' -f4,4 )

ltm=$(date -d "${LineDT:0:-1} UTC" '+%Y/%m/%d %R')
#echo "LineTM:$LineDT"
#echo "LocTM:$ltm"

#echo "Item:$item"
#echo "Dur:$Dur"
	timestamp0=$(date -d "$ltm" +%s)
	if [[ "$timestamp0" -gt "$timestamp1" ]] && [[ "$timestamp0" -lt "$timestamp2" ]]; then 
        	
			#echo "Start Time:$dts1 $timestamp1"
			#echo "Record Time:                   $timestamp0"
			#echo "End Time:$dts2   $timestamp2"

		Line=$(echo "$item") 

			#echo "$Line"		
		Call=$(echo "$item" | cut -d " " -f3) 
			#echo "$Call"
		Line2=$(grep "$Call" /usr/local/etc/stripped.csv | tail -1 | cut -d "," -f3,4,5,6,7 ) 
		echo "$ltm $Call $Dur $Line2" 
#		echo "$Item $Line2" 
		((count++))		
	fi
done
echo "Count = $count"




