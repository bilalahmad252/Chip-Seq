#!/bin/bash
#SBATCH --job-name=Bowtie2_index
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=50G
#SBATCH --mail-type=ALL
#SBATCH --output=index_output.txt
#SBATCH --error=index_error.txt

module load Bowtie2
bowtie2-build /homes/bilala/BedTools/Biocode_ATAC_Seq/genome_files/hs_genome_fasta.fasta /homes/bilala/BedTools/Biocode_ATAC_Seq/genome_files/genome_index/hs