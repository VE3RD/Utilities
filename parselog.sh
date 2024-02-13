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
echo "$F1" 
DT=$(cat $F1| tail -n 1 | cut -d " " -f2)
echo "$DT"
Hr=$(cat $F1| tail -n 1 | cut -d " " -f3 | cut -d ":" -f1)
Mi=$(cat $F1| tail -n 1 | cut -d " " -f3 | cut -d ":" -f2)
Tm="$Hr:$Mi"

echo "$Tm"

#Calls=$(grep "2024-02-13 [10:00-14:59]" "$F1" | grep 'transmission from' | cut -d " " -f 2,3,14 | sort | uniq)
Calls=$(grep "2024-02-13 [$T1-$T2]" "$F1" | grep 'transmission from' | cut -d " " -f 2,3,14 | sort -k3)


if [ "$S" == 1 ]; then
	Calls2=$(echo "$Calls" | sort -k2 | uniq -u)

else
	Calls2=$(echo "$Calls" | uniq -f 2 -u)


fi
echo "$Calls2"

echo "Count = $Calls2" |wc -l
