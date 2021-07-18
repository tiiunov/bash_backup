#!/bin/bash
#Creator: Vladimir Tiunov
echo "Path to directory, EXAMPLE:/home/admin00/Desktop/aaa"
read pathToDirectory
echo "Rasshirenie, EXAMPLE:.txt"
read rasshirenie
#firstly, create directory for all backup files
mkdir JUSTFORBACKUP
mkdir FORHASHSUM
while true
do
	#pathToDirectory="/home/admin00/Desktop/aaa"
	#rasshirenie=".txt"
	#for fast tests without "read"
	maxCopiesCount=5
	#write Copies count higher, now 5
	currentDate=$(date +%Y-%m-%d-%S)
	#remove seconds if you don't need it


	#archivate
	tar -cf JUSTFORBACKUP/ArchiveForBackup$currentDate.tar $pathToDirectory/*$rasshirenie


	#check if archive is bad
	#tar -xf JUSTFORBACKUP/ArchiveForBackup$currentDate.tar >> /dev/null; echo $?
	md5sum JUSTFORBACKUP/ArchiveForBackup$currentDate.tar > FORHASHSUM/HashSum$currentDate.txt
	#for each backup you can find the control sum in the same directory 


	#delete old copies
	allCount=$((ls -f JUSTFORBACKUP)|(wc -l))
	copiesCount=$(($allCount-2))  
	#get Copies count
	cd JUSTFORBACKUP/
	#I use for because if you run the program without deliting old copies and
	#after that you want to use this function, function will delete all that is more than right count 
	for i in $(find -type f -name "*.tar" | sort)
	do
	if [[ $copiesCount < $(($maxCopiesCount+1)) ]]
	then
	#echo $copiesCount
	break
	else
	rm $i
	copiesCount=$(($copiesCount-1))
	#echo $copiesCount
	fi
	done
	cd ..


	sleep 10
	#now do backup every 10 seconds
	#do backup every day - sleep 1d
	#do backup every hour - sleep 1h	
done
#you can set time in terminal without "while true"
#(crontab -l; echo "0 0 * * 5/home/admin00/Desktop/backup.sh") | crontab -
#for example, it does backup every friday
# in terminal: crontab -e, then 0 0 * * 5/home/admin00/Desktop/backup.sh