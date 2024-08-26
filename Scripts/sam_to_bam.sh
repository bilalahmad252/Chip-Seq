#!/bin/bash
#SBATCH --job-name=sam_to_bam conversion
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=100G
#SBATCH --output=sam_to_bam_%j.out
#SBATCH --error=sam_to_bam_%j.err
 module load SAMtools
 for file in /homes/bilala/BedTools/Biocode_ATAC_Seq/results/Bowtie2_alignment/*.sam; 
	do
    		base_file=$(basename $file .sam)
    		echo "Converting ${base_file}.sam to ${base_file}.bam" 
		samtools view -h -S -b \
	 	-o /homes/bilala/BedTools/Biocode_ATAC_Seq/results/Bowtie2_alignment/bams/${base_file}.bam \
 		/homes/bilala/BedTools/Biocode_ATAC_Seq/results/Bowtie2_alignment/${base_file}.sam
	done