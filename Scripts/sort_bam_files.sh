#!/bin/bash
#SBATCH --job-name=BAM Sorting
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=100G
#SBATCH --output=sam_to_bam_%j.out
#SBATCH --error=sam_to_bam_%j.err
 module load SAMtools
 for file in /homes/bilala/BedTools/Biocode_ATAC_Seq/results/Bowtie2_alignment/bams/*.bam;
do
    base_file=$(basename $file .bam)
    echo "Sorting ${base_file}.bam" 
    samtools sort -o /homes/bilala/BedTools/Biocode_ATAC_Seq/results/Bowtie2_alignment/bams/sorted_bams/${base_file}_sorted.bam \
    /homes/bilala/BedTools/Biocode_ATAC_Seq/results/Bowtie2_alignment/bams/${base_file}.bam
done