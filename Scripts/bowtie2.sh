#!/bin/bash
module load Bowtie2
genome_index="/homes/bilala/BedTools/Chipseq_2024/reference_data/genome_index/mm10"
fastq_dir="/homes/bilala/BedTools/Chipseq_2024/raw_data"
output_dir="/homes/bilala/BedTools/Chipseq_2024/results/bowtie2_alignment"
for file in $fastq_dir/*.fastq; do
    base=$(basename $file .fastq)
    echo "Processing file $base"
    bowtie2 -p 4 --local -q \
    -x $genome_index \
    -U $file \
    -S $output_dir/$base.sam 2> $output_dir/$base.log
    echo "Done processing file $base"
    
done