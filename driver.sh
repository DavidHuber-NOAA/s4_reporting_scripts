#!/usr/bin/bash
set +x
module load miniconda/3.8-s4

set -x

echo Generating monthly job reports
./gen_reports.sh >& gen_reports.out
echo Generating monthly hours by job
./gen_names.sh >& gen_names.out
