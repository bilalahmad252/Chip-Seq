#!/bin/bash
genome_fasta_file="/homes/bilala/BedTools/Chipseq_2024/reference_data/mm10.fa"
output_dir="/homes/bilala/BedTools/Chipseq_2024/reference_data/genome_index/"
module load Bowtie2
bowtie2-build -f "$genome_fasta_file" "$output_dir/mm10"

echo "Done building the index"