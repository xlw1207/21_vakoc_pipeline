#!/bin/bash

# Ignore the last 17 nt from read1
# Ignore the first 17 nt from read2
# Paste read1 and read2 together.
res1=$(date +%s.%N)

echo " "
echo "Assemble final bc reads together"
echo "-> The output is written in $2"
awk '{print $2, substr($3, 0, length($3)-17)substr($4, 18, length($4))}' $1>$2

res2=$(date +%s.%N)
dt=$(echo "$res2 - $res1" | bc)
dd=$(echo "$dt/86400" | bc)
dt2=$(echo "$dt-86400*$dd" | bc)
dh=$(echo "$dt2/3600" | bc)
dt3=$(echo "$dt2-3600*$dh" | bc)
dm=$(echo "$dt3/60" | bc)
ds=$(echo "$dt3-60*$dm" | bc)
LC_NUMERIC=C printf "%s Generate assemble reads $output took: %02d:%02d:%02.4f\n" '->' $dh $dm $ds
