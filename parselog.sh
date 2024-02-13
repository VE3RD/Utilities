#!/bin/bash
sudo mount -o remount,rw / > /dev/null

T1=$1
T2=$2
S=$3

if [ "$T2" == "" ];  then
 echo Usage : ./parselog.sh StartTime StopTime
 echo ie :   ./parselog.sh 18:00 22:59
 exit
fi

##### Main program #########
#F1=$(tail -n 1000 /var/log/pi-star/MMDVM-20*  )
F1=$(ls -alt /var/log/pi-star/MMDVM-20* | tail -n 1 | cut -d " " -f9)
#echo "$F1" 
DT=$(cat $F1| tail -n 1 | cut -d " " -f2)
#echo "$DT"
Hr=$(cat $F1| tail -n 1 | cut -d " " -f3 | cut -d ":" -f1)
Mi=$(cat $F1| tail -n 1 | cut -d " " -f3 | cut -d ":" -f2)
Tm="$Hr:$Mi"

Calls=$(grep "2024-02-13 [$T1-$T2]" "$F1" | grep 'transmission from' | cut -d " " -f 2,3,14 | sort -k3 | uniq -f 2 -u)

IFS==$(echo -en "\n\b")

for item in $Calls
do
        Line=$(echo "$item")
	Call=$(echo "$item" | cut -d " " -f3)
	Line2=$(grep "$Call" /usr/local/etc/stripped.csv | tail -1 | cut -d "," -f3,4,5,6,7 )
	echo "$Line   $Line2"
	
done

echo "Number of Calls $Calls" | wc -l 



