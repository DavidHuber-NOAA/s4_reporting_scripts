#!/usr/bin/bash
set +x
module load miniconda/3.8-s4

set -x
export y="22"
export m="02"

echo Generating monthly job reports
./gen_reports.sh -y $y -m $m >& gen_reports.out
echo Generating monthly hours by job
./get_monthly_hours.sh >& get_monthly_hours.out
