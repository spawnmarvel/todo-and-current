#!/bin/bash

# get the date time
dt=$(date)
echo $dt

# append it to a file
echo $dt >> cron_log.txt


