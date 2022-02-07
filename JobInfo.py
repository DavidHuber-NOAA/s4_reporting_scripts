#! /usr/bin/env python
import sys
import pandas
import os.path

def job_info(filename,date):

    data = pandas.read_csv(filename, delimiter=',', dtype={"JobID": "string", "JobName": "string", "Partition": "string", "TotalCPU": "string"})

    if(not os.path.isfile("JobNames.txt")):
        names = []
    else:
        with open("JobNames.txt","r") as f:
            names = [line.strip() for line in f.readlines()]

    with open("JobNames.txt","a") as f:
        for JobName in data['JobName']:
            if(JobName not in names):
                names.append(JobName)
                f.write(JobName + "\n")

    coreHours = []
    for time in data['TotalCPU']:
        if "-" in time:
            (days,hhmmss) = time.split("-")
            (hh,mm,ss) = hhmmss.split(":")
        elif time.count(":") == 2:
            (hh,mm,ss) = time.split(":")
            days = 0
        else:
            (mm,ss) = time.split(":")
            (hh,days) = (0,0)

        coreHours.append(float(days) * 24.0 + float(hh) + float(mm) / 60.0 + float(ss) / 3600.00)

    data['Core Hours'] = coreHours

    with open("JobInfo_" + date + ".csv", "w") as f:
        f.write("Job Name,Total Core-Hours\n")
        for name in names:
            unique_hours = sum(data.loc[data['JobName'] == name]['Core Hours'])
            if(unique_hours != 0):
                f.write(name + "," + str(unique_hours) + "\n")

if __name__ == "__main__":
    if(len(sys.argv) != 3):
        print("Requires 2 argmument (CSV filename, date in MM_YY format)")
    job_info(sys.argv[1], sys.argv[2])
