#!/bin/bash 
#SBATCH --job-name=bowtie2_alignment
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=100G
#SBATCH --output=bowtie2_alignment_%j.out
#SBATCH --error=bowtie2_alignment_%j.err

module load Bowtie2 # load bowtie2

clean_fastq_files=/homes/bilala/BedTools/Biocode_ATAC_Seq/raw_data/clean_data
genome_index=/homes/bilala/BedTools/Biocode_ATAC_Seq/genome_files/genome_index
output_dir=/homes/bilala/BedTools/Biocode_ATAC_Seq/results/Bowtie2_alignment
#bowtie2 -x $genome_index -1 $clean_fastq_files/ERR458493_1.fastq -2 $clean_fastq_files/ERR458493_2.fastq -S $output_dir/ERR458493.sam
for file in $clean_fastq_files/*.fastq; do
    base_name=$(basename "$file" "_1_clean.fastq")
    echo "Aligning ${base_name}_1_clean.fastq and ${base_name}_2_clean.fastq to the genome"
    bowtie2 -x $genome_index/hs --threads 4 -1 $clean_fastq_files/${base_name}_1_clean.fastq -2 $clean_fastq_files/${base_name}_2_clean.fastq -S $output_dir/${base_name}.sam
done
