#!/usr/bin/bash
set +x
set -e
PS4='Line ${LINENO}: '
usage () { echo "gen_reports.sh -y YY -m MM"; }
[[ $# -lt 2 ]] && usage
while getopts ":y:m:h" opt; do
   case $opt in
      y)
         YY=$OPTARG
         ;;
      m)
         MM=$OPTARG
         ;;
      h)
         usage
         ;;
      \?)
         usage
         echo "Invalid option: -$OPTARG"
         exit 1
         ;;
      :)
         usage
         echo "Option -$OPTARG needs an argument."
         ;;
   esac
done
set -x

export YYMM=$(echo "$YY$MM")
export YY_MM=$(echo "${YY}_${MM}")
export MM_YY=$(echo "${MM}_${YY}")
export MMp1=$(( $MM + 1))
export YYp1=$(date -d "20${YY}/${MM}/01+1 month" +%y)

YYYYMMDD_to_date() {
   fYY=$(echo $1 | cut -b 1,4)
   fMM=$(echo $1 | cut -b 5,6)
   fDD=$(echo $1 | cut -b 7,8)

   echo "20$fYY/$fMM/$fDD"
}

sreport cluster UserUtilizationByAccount Format=Login%20,Accounts,Used Start=$MM/01/$YY End=$MMp1/01/$YYp1| grep -v -- "---" | sed "s/^  *//" | sed "s/   */,/g" > ActiveUsers_$MM_YY.csv


export start_YYYYMMDD=$(echo "20${YY}${MM}01")
export end_YYYYMMDD=$(date -d "$(YYYYMMDD_to_date $start_YYYYMMDD)+1 month" +%Y%m%d)
export cur_YYYYMMDD=$start_YYYYMMDD
export next_YYYYMMDD=$(date -d "$(YYYYMMDD_to_date $start_YYYYMMDD)+1 day" +%Y%m%d)

echo "JobID,JobName,Partition,TotalCPU" > Jobs_${MM}_${YY}.csv
while [ $cur_YYYYMMDD -lt $end_YYYYMMDD ]; do
   cur_YY=$(echo $cur_YYYYMMDD | cut -b 3,4)
   cur_MM=$(echo $cur_YYYYMMDD | cut -b 5,6)
   cur_DD=$(echo $cur_YYYYMMDD | cut -b 7,8)
   S=$cur_MM$cur_DD$cur_YY

   next_YY=$(echo $next_YYYYMMDD | cut -b 3,4)
   next_MM=$(echo $next_YYYYMMDD | cut -b 5,6)
   next_DD=$(echo $next_YYYYMMDD | cut -b 7,8)
   E=$next_MM$next_DD$next_YY
   echo a$E-a s$S-s
   sacct -S $S -E $E -a -o JobID%20,JobName%80,Partition,TotalCPU%20 | grep -v -- "---\|JobID" | sed -E "s/^  *(\S.*)  *$/\1/" | grep -Ev "^[0-9]*  *" | sed -E "s/,/;/g" | sed -E "s/^(\S*)  *(\S*)   *(\S*)$/\1,\2,,\3/" | grep -v " " >> Jobs_${MM}_$YY.csv
   export cur_YYYYMMDD=$(date -d "$(YYYYMMDD_to_date $cur_YYYYMMDD)+1 day" +%Y%m%d)
   export next_YYYYMMDD=$(date -d "$(YYYYMMDD_to_date $next_YYYYMMDD)+1 day" +%Y%m%d)
done
#echo "JobID,JobName,Partition,TotalCPU" > Jobs_04_21.csv; sacct -S 040121 -E 041021 -a -o JobID%20,JobName%80,Partition,TotalCPU%20 | grep -v -- "---" | sed "s/^  *//" | sed "s/  *$//" | sed -E "s/,/;/g" | sed -E "s/^(\S*)  *(\S*)   *(\S*)$/\1,\2,,\3/" |  sed -E "/^(\S*)  *(\S*)   *(\S*)  *(\S*)$/d" | grep -Ev "^[0-9]*  *" >> Jobs_04_21.csv
#sacct -S 041021 -E 042021 -a -o JobID%20,JobName%80,Partition,TotalCPU%20 | grep -v -- "---" | sed "s/^  *//" | sed "s/  *$//" | sed -E "s/,/;/g" | sed -E "s/^(\S*)  *(\S*)   *(\S*)$/\1,\2,,\3/" |  sed -E "/^(\S*)  *(\S*)   *(\S*)  *(\S*)$/d" | grep -Ev "^[0-9]*  *" >> Jobs_04_21.csv
#sacct -S 042021 -E 050121 -a -o JobID%20,JobName%80,Partition,TotalCPU%20 | grep -v -- "---" | sed "s/^  *//" | sed "s/  *$//" | sed -E "s/,/;/g" | sed -E "s/^(\S*)  *(\S*)   *(\S*)$/\1,\2,,\3/" |  sed -E "/^(\S*)  *(\S*)   *(\S*)  *(\S*)$/d" | grep -Ev "^[0-9]*  *" >> Jobs_04_21.csv
