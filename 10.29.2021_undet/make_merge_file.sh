# Find the sequences which both 
# sequence_id and barcode are the same in the 
# csv files produced in the above step.
# Sequence id will help us to get the line number since both
# read1 and read2 should be located in the same positions in the fastq file.
# The read_merge file has the [seq_id, barcode, sequence_from_read1, sequence_from_read2]
res1=$(date +%s.%N)

echo " "
echo "Merging two reads on the sequence_id and barcode."
echo "-> write the merge file in $3"
awk 'NR==FNR{a[$1,$2]=$3;next} ($1,$2) in a{print $0, a[$1,$2]}' $2 $1>$3

res2=$(date +%s.%N)
dt=$(echo "$res2 - $res1" | bc)
dd=$(echo "$dt/86400" | bc)
dt2=$(echo "$dt-86400*$dd" | bc)
dh=$(echo "$dt2/3600" | bc)
dt3=$(echo "$dt2-3600*$dh" | bc)
dm=$(echo "$dt3/60" | bc)
ds=$(echo "$dt3-60*$dm" | bc)

n_records=$(wc -l $3)
echo "-> Total number of records are $n_records"

LC_NUMERIC=C printf "%s Merging to $3 took: %02d:%02d:%02.4f\n"  '->' $dh $dm $ds
