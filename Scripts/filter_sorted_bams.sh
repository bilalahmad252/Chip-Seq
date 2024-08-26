#!/bin/bash
#SBATCH --job-name=filter_sorted_bams
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=100G
#SBATCH --output=filter_sorted_bams_%j.out
#SBATCH --error=filter_sorted_bams_%j.err
sorted_bams=/homes/bilala/BedTools/Biocode_ATAC_Seq/results/Bowtie2_alignment/bams/sorted_bams
filtered_bams=/homes/bilala/BedTools/Biocode_ATAC_Seq/results/Bowtie2_alignment/bams/filtered_sorted_bams

for file in $sorted_bams/*.bam; do
    base_file=$(basename $file _sorted.bam)
    echo "Filtering ${base_file}_sorted.bam"
    sambamba view -h -f bam -t 4 -F "[XS] == null and not unmapped and not duplicate" \
   $sorted_bams/${base_file}_sorted.bam > $filtered_bams/${base_file}_sorted_filtered.bam  
done