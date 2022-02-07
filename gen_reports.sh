#!/usr/bin/bash
set -x
sreport cluster UserUtilizationByAccount Format=Login%20,Accounts,Used Start=08/01/21 End=09/01/21| grep -v -- "---" | sed "s/^  *//" | sed "s/   */,/g" > ActiveUsers_08_21.csv
#sreport cluster UserUtilizationByAccount Format=Login%20,Accounts,Used Start=09/01/21 End=10/01/21| grep -v -- "---" | sed "s/^  *//" | sed "s/   */,/g" > 09_21.csv
#sreport cluster UserUtilizationByAccount Format=Login%20,Accounts,Used Start=10/01/21 End=11/01/21| grep -v -- "---" | sed "s/^  *//" | sed "s/   */,/g" > 10_21.csv
#sreport cluster UserUtilizationByAccount Format=Login%20,Accounts,Used Start=11/01/21 End=12/01/21| grep -v -- "---" | sed "s/^  *//" | sed "s/   */,/g" > 11_21.csv
#sreport cluster UserUtilizationByAccount Format=Login%20,Accounts,Used Start=12/01/21 End=01/01/22| grep -v -- "---" | sed "s/^  *//" | sed "s/   */,/g" > 12_21.csv
#sreport cluster UserUtilizationByAccount Format=Login%20,Accounts,Used Start=01/01/22 End=02/01/22| grep -v -- "---" | sed "s/^  *//" | sed "s/   */,/g" > 01_22.csv
#sreport cluster UserUtilizationByAccount Format=Login%20,Accounts,Used Start=08/01/21 End=02/01/22| grep -v -- "---" | sed "s/^  *//" | sed "s/   */,/g" > 08_21_to_01_22.csv
echo "JobID,JobName,Partition,TotalCPU" > Jobs_08_21.csv
sacct -S 080121 -E 090121 -a -o JobID%20,JobName%80,Partition,TotalCPU%20 | grep -v -- "---" | sed "s/^  *//" | sed "s/  *$//" | sed -E "s/,/;/g" | sed -E "s/^(\S*)  *(\S*)   *(\S*)$/\1,\2,,\3/" |  sed -E "/^(\S*)  *(\S*)   *(\S*)  *(\S*)$/d" | grep -Ev "^[0-9]*  *" >> Jobs_08_21.csv
#sacct -S 090121 -E 100121 -a -o JobID%20,JobName%80,Partition,TotalCPU%20 | grep -v -- "---" | sed "s/^  *//" | sed "s/  *$//" | sed -E "s/,/;/g" | sed -E "s/^(\S*)  *(\S*)   *(\S*)$/\1,\2,,\3/" |  sed -E "/^(\S*)  *(\S*)   *(\S*)  *(\S*)$/d" > Jobs_09_21.csv
#sacct -S 100121 -E 110121 -a -o JobID%20,JobName%80,Partition,TotalCPU%20 | grep -v -- "---" | sed "s/^  *//" | sed "s/  *$//" | sed -E "s/,/;/g" | sed -E "s/^(\S*)  *(\S*)   *(\S*)$/\1,\2,,\3/" |  sed -E "/^(\S*)  *(\S*)   *(\S*)  *(\S*)$/d" > Jobs_10_21.csv
#sacct -S 110121 -E 120121 -a -o JobID%20,JobName%80,Partition,TotalCPU%20 | grep -v -- "---" | sed "s/^  *//" | sed "s/  *$//" | sed -E "s/,/;/g" | sed -E "s/^(\S*)  *(\S*)   *(\S*)$/\1,\2,,\3/" |  sed -E "/^(\S*)  *(\S*)   *(\S*)  *(\S*)$/d" > Jobs_11_21.csv
#sacct -S 120121 -E 010122 -a -o JobID%20,JobName%80,Partition,TotalCPU%20 | grep -v -- "---" | sed "s/^  *//" | sed "s/  *$//" | sed -E "s/,/;/g" | sed -E "s/^(\S*)  *(\S*)   *(\S*)$/\1,\2,,\3/" |  sed -E "/^(\S*)  *(\S*)   *(\S*)  *(\S*)$/d" > Jobs_12_21.csv
#sacct -S 010122 -E 020122 -a -o JobID%20,JobName%80,Partition,TotalCPU%20 | grep -v -- "---" | sed "s/^  *//" | sed "s/  *$//" | sed -E "s/,/;/g" | sed -E "s/^(\S*)  *(\S*)   *(\S*)$/\1,\2,,\3/" |  sed -E "/^(\S*)  *(\S*)   *(\S*)  *(\S*)$/d" > Jobs_01_22.csv
