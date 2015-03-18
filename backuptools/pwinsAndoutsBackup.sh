#!/bin/bash
# -------------------
# sh backup.sh
# -------------------

mydir=`pwd`
DATE=`date +%Y-%m-%d`
HOSTNAME=`hostname`


mkdir -p ${mydir}/backup
shopt -s extglob


# looking for all files ending with .in and .out to tar 
find ~/!(src) -name *.in > ${mydir}/tmpfilelist
find ~/!(src) -name *.out >> ${mydir}/tmpfilelist
find ~/!(src) -name run* >> ${mydir}/tmpfilelist
find ${SCRATCH} -name *.in >> ${mydir}/tmpfilelist
find ${SCRATCH} -name *.out >> ${mydir}/tmpfilelist
find ${SCRATCH} -name run* >> ${mydir}/tmpfilelist


# creating file structure to tar up
while read line
do
  cp -v --parents $line ${mydir}/backup
done < tmpfilelist


# if backup exists than update else create new file
# note: tar can't update with -z option!
if [ -e  $mydir/backup_${HOSTNAME}.tar.gz ]
then
  tar -uvf backup_${HOSTNAME}.tar.gz ${mydir}/backup
  echo ""
  echo "tar file updated"
  echo ""
else
  tar -cvf backup_${HOSTNAME}.tar.gz ${mydir}/backup 
  echo ""
  echo "new tar file created"
  echo ""
fi


echo "last update ${DATE}" >> $mydir/updatelog


rm -v ${mydir}/tmpfilelist
