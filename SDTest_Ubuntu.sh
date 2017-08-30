#!/bin/bash

#variants definition
SD_PATH="/storage/sdcard0"
COUNTS=1000
INTERNAL_PATH="/data/local/tmp"
LOGFILE="phone.log"
CACHEFILE="temp.log"
COPYFILE="M.mp4"
LOG_PATH="`pwd`"

#write testing
function writing
{ 
  echo "Wtriting test start at `date +"%H:%M:%S %m/%d/%Y"`."
  echo "Wtriting test start at `date +"%H:%M:%S %m/%d/%Y"`." >> $LOG_PATH/$LOGFILE
  adb shell sync
  adb shell dd if=/dev/zero of=$SD_PATH/$CACHEFILE bs=500k count=1024 >> $LOG_PATH/$LOGFILE 2>&1
  if [ "$?" -eq 0 ]; then
    echo "Writing finished!"
  else 
    echo "Writing ERROR!!! pleas check."
  fi
  echo "*" >> $LOG_PATH/$LOGFILE
  echo ""
}

#read testing
function reading
{
  echo "Reading test start at `date +"%H:%M:%S %m/%d/%Y"`."
  echo "Reading test start at `date +"%H:%M:%S %m/%d/%Y"`." >> $LOG_PATH/$LOGFILE
  adb shell sync
  adb shell dd if=$SD_PATH/$CACHEFILE of=/dev/null bs=500k count=1024 >> $LOG_PATH/$LOGFILE 2>&1
  if [ "$?" -eq 0 ]; then
    echo "Reading Finished!" 
  else
    echo "Reading ERROR!!!please check."
  fi
  echo "*" >> $LOG_PATH/$LOGFILE
  echo ""
}

#file copy to SD card testing
function file_copy_to_SDcard
{
  echo "File writing start at `date +"%H:%M:%S %m/%d/%Y"`."
  echo "File writing start at `date +"%H:%M:%S %m/%d/%Y"`." >> $LOG_PATH/$LOGFILE
  adb shell sync
  adb shell cp "$INTERNAL_PATH/$COPYFILE" "$SD_PATH" >> $LOG_PATH/$LOGFILE 2>&1
  if [ "$?" -eq 0 ]; then
    echo "File writing finished!"
	echo "File copy to SD card successed!!!" >> $LOG_PATH/$LOGFILE 
  else
    echo "File  writing ERROR!!!"
  fi
  echo "*" >> $LOG_PATH/$LOGFILE
  echo ""
}

#file copy from SD card testing
function file_copy_from_SDcard
{
  echo "File reading start at `date +"%H:%M:%S %m/%d/%Y"`."
  echo "File reading start at `date +"%H:%M:%S %m/%d/%Y"`." >> $LOG_PATH/$LOGFILE
  adb shell sync
  adb shell cp "$SD_PATH/$COPYFILE" "$INTERNAL_PATH" >> $LOG_PATH/$LOGFILE 2>&1
  if [ "$?" -eq 0 ]; then
	echo "File copy from SD card successed!!!" >> $LOG_PATH/$LOGFILE
    echo "File reading finished!"
  else
    echo "File reading ERROR!!!"
  fi
  echo "*" >> $LOG_PATH/$LOGFILE
  echo ""
}

function main
{
  for((i=1; i<=COUNTS; i++))
  do
    writing
    sleep 2
    reading
    sleep 2
    file_copy_from_SDcard
    sleep 2
    file_copy_to_SDcard
    sleep 2
	echo ">>>>>>>>>>>>>>>>>>>>>>>>>" >> $LOG_PATH/$LOGFILE
    echo "<<< $1 round testuing finished! >>>"
  done
  echo "Testing end!!!"
  echo "**************************************"
}

echo "Testing start now!!!!"
main
