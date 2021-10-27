#!/bin/bash

# Processing the read1 file:
## 1. First it will grep out 
##    a) all the sequence number (id)
##    b) barcode for that sequence 
##    c) sequnce itself
## 2. It will remove lines which barcodes are not match to the designed barcodes.
## 3. It will remove lines if they do not start with constant sequence.
## 4. It will remove sequences if there is an "N" character in them.
## 5. It will write the result in the csv file with [seq_id, barcode, seq] columns

res1=$(date +%s.%N)

read_file=$1
bc1=$2
bc2=$3
const_seq_read=$4
output=$5

echo " "
echo "Processing read: $read_file"
echo "-> get seq_id, barcode, seq from fastq file" 
echo "-> match barcodes to the designed barcodes" 
echo "-> match constant sequence" 
echo "-> drop seqs with N char" 
echo "-> write the read1_seq_bc.csv in $output" 
zcat $read_file|awk  '(/@/) {printf "%s\t %s\t", int(NR/4)+1, \
                      substr($0, length($0)-5, length($0)); \
                      getline; printf "%s\n", $0}'| \
                awk -v bc1=$bc1 -v bc2=$bc2 '$2==bc1||$2==bc2'| \
                awk -v const_seq="^$const_seq_read1" '$3 ~ const_seq'|\
                grep -v "N">$output

n_records=$(wc -l $output)
echo "-> Total number of records are $n_records"
res2=$(date +%s.%N)
dt=$(echo "$res2 - $res1" | bc)
dd=$(echo "$dt/86400" | bc)
dt2=$(echo "$dt-86400*$dd" | bc)
dh=$(echo "$dt2/3600" | bc)
dt3=$(echo "$dt2-3600*$dh" | bc)
dm=$(echo "$dt3/60" | bc)
ds=$(echo "$dt3-60*$dm" | bc)
LC_NUMERIC=C printf "%s Generate $output took: %02d:%02d:%02.4f\n" '->' $dh $dm $ds
