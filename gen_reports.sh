#!/usr/bin/bash
set +x
set -e
PS4='Line ${LINENO}: '
set -x

MM_YY=$(echo "${m}_${y}")
MMp1=$(date -d "20$y/$m/01+1 month" +%m)
YYp1=$(date -d "20$y/$m/01+1 month" +%y)

start_YYYYMMDD="20${y}${m}01"
end_YYYYMMDD="20${YYp1}${MMp1}01"

YYYYMMDD_to_date() {
   fYY=$(echo $1 | cut -b 1-4)
   fMM=$(echo $1 | cut -b 5,6)
   fDD=$(echo $1 | cut -b 7,8)

   echo "$fYY/$fMM/$fDD"
}

sreport cluster UserUtilizationByAccount Format=Login%20,Accounts,Used Start=$m/01/$y End=$MMp1/01/$YYp1| grep -v -- "---" | sed "s/^  *//" | sed "s/   */,/g" > ActiveUsers_$MM_YY.csv


cur_YYYYMMDD=$start_YYYYMMDD
next_YYYYMMDD=$(date -d "$(YYYYMMDD_to_date $start_YYYYMMDD)+1 day" +%Y%m%d)

echo "JobID,JobName,Partition,TotalCPU" > Jobs_${m}_${y}.csv
while [ $cur_YYYYMMDD -lt $end_YYYYMMDD ]; do
   cur_YY=$(echo $cur_YYYYMMDD | cut -b 3,4)
   cur_MM=$(echo $cur_YYYYMMDD | cut -b 5,6)
   cur_DD=$(echo $cur_YYYYMMDD | cut -b 7,8)
   S=$cur_MM$cur_DD$cur_YY

   next_YY=$(echo $next_YYYYMMDD | cut -b 3,4)
   next_MM=$(echo $next_YYYYMMDD | cut -b 5,6)
   next_DD=$(echo $next_YYYYMMDD | cut -b 7,8)
   E=$next_MM$next_DD$next_YY

   sacct -S $S -E $E -a -o JobID%20,JobName%80,Partition,TotalCPU%20 | grep -v -- "---\|JobID" | sed -E "s/^  *(\S.*)  *$/\1/" | grep -Ev "^[0-9]*  *" | sed -E "s/,/;/g" | sed -E "s/^(\S*)  *(\S*)   *(\S*)$/\1,\2,,\3/" | grep -v " " >> Jobs_${MM}_$y.csv
   cur_YYYYMMDD=$(date -d "$(YYYYMMDD_to_date $cur_YYYYMMDD)+1 day" +%Y%m%d)
   next_YYYYMMDD=$(date -d "$(YYYYMMDD_to_date $next_YYYYMMDD)+1 day" +%Y%m%d)
done
