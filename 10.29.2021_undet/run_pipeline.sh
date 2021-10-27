#!/bin/bash

#### START User Input #####
#read1_file='r1.fastq.gz'
#read2_file='r2.fastq.gz'
read1_file='/grid/kinney/home/jkinney/big_data/illumina_runs/21_vakoc/Undetermined_S0_R1_001.fastq.gz'
read2_file='/grid/kinney/home/jkinney/big_data/illumina_runs/21_vakoc/Undetermined_S0_R2_001.fastq.gz'
bc1='AATCCA'
bc2='TTGAAC'
const_seq_read1='AAGTGTCCCAGGAGACTATAGC'
const_seq_read2='GCCATTAAGTCTTGAGTTACTTGTCT'
process_read_seqid_bc=true
merge_seqid_bc_reads=true
#### END User Input #####


res1=$(date +%s.%N)
mkdir -p intermediate

echo "Read1 file: $read1_file"
echo "Read2 file: $read2_file"
echo "Designed barcode 1: $bc1"
echo "Designed barcode 2: $bc2"
echo "Constant sequence in Read1:  $const_seq_read1"
echo "Constant sequence in Read2:  $const_seq_read2"

if $process_read_seqid_bc
then 
    # Run the seq_id, barcode, sequence processing for read1
    bash ./read_seqid_bc.sh $read1_file $bc1 $bc2 $const_seq_read1 \
        ./intermediate/read1_bc_seq.csv
    # Run the seq_id, barcode, sequence processing for read2
    bash ./read_seqid_bc.sh $read2_file $bc1 $bc2 $const_seq_read2 \
        ./intermediate/read2_bc_seq.csv
fi

if $merge_seqid_bc_reads
then 
    bash ./make_merge_file.sh \
        ./intermediate/read1_bc_seq.csv \
        ./intermediate/read2_bc_seq.csv \
        ./intermediate/merge_read1_read2.csv
fi


res2=$(date +%s.%N)
dt=$(echo "$res2 - $res1" | bc)
dd=$(echo "$dt/86400" | bc)
dt2=$(echo "$dt-86400*$dd" | bc)
dh=$(echo "$dt2/3600" | bc)
dt3=$(echo "$dt2-3600*$dh" | bc)
dm=$(echo "$dt3/60" | bc)
ds=$(echo "$dt3-60*$dm" | bc)

echo " "
LC_NUMERIC=C printf "Total pipeline runtime: %02d:%02d:%02.4f\n"  $dh $dm $ds
