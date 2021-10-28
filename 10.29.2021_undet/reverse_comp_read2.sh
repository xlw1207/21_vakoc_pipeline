# TODO: THIS IS NOT EFFICIENT AT ALL
# Find the reverse complement of read2 sequences in the merge file
# Replace the merge file read2_seq column with the reverse complement
res1=$(date +%s.%N)

echo " "
echo "Reverse Complement the read2 sequences."
echo "-> write the reverse read2_seq merge file in $2"

awk '{print $4}' $1|tr ACGTacgt TGCAtgca|rev>./intermediate/temp.txt
awk 'FNR==NR{a[NR]=$1;next}{$4=a[FNR]}1' ./intermediate/temp.txt $1>$2
rm ./intermediate/temp.txt

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

LC_NUMERIC=C printf "%s Reverse complementing for $2 took: %02d:%02d:%02.4f\n"  '->' $dh $dm $ds
