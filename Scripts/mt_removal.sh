samtools idxstats SRR13755450_dedup.bam | grep "MT"
samtools view -b SRR13755450_dedup.bam 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 X Y -@ 12 > SRR13755450.noMT.bam
samtools index SRR13755450.noMT.bam
samtools idxstats SRR13755450.noMT.bam | grep "MT"

echo "After MT removal: "
samtools idxstats SRR13755450.noMT.bam
samtools view -b -q 30 -f 2 -F 256 SRR13755450.noMT.bam > SRR13755450.noMT.filtered.bam
samtools index SRR13755450.noMT.filtered.bam
echo "After QC filtration: "
samtools idxstats SRR13755450.noMT.filtered.bam


