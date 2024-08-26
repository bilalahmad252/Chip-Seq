#!/bin/bash

# Define the output directory
output_dir="/homes/bilala/BedTools/Chipseq_2024/results/bowtie2_alignment"

# Loop through all sorted BAM files in the current directory
for file in *.sorted.bam; do
    # Use sambamba to filter and create a new BAM file
    output_file="${output_dir}/${file%.sorted.bam}_sorted_nodup.bam"
    sambamba view -h -t 2 -f bam \
        -F "[XS] == null and not unmapped and not duplicate" \
        "$file" > "$output_file"
done