#!/usr/bin/bash
set +x
set -e
module load miniconda/3.8-s4
#PS4='Line ${LINENO}: '
usage () {
   echo "report_driver.sh [-y YY -m MM]"
   echo "-y YY, 2-digit year"
   echo "-m MM, 2-digit month"
   echo "If a month and year are not supplied, stats for the previous month are generated"
}

#set -x
#Set defaults
last_month=$(date -d "today-1 month" +%y/%m)
export YY=$(echo $last_month | cut -b 1,2)
export MM=$(echo $last_month | cut -b 4,5)

set +x
[[ $# -eq 2 ]] && usage && exit 2
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

if [[ -z $YY || -z $MM ]]; then
   usage
   exit
fi

#set -x
export y=$YY
export m=$MM

echo Generating monthly job reports.  This will take several minutes.
./gen_reports.sh >& gen_reports.out
echo Generating monthly hours by job.
./get_monthly_hours.sh >& get_monthly_hours.out
echo Done
