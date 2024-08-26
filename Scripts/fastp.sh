#!/bin/bash
#SBATCH --job-name=fastp_trimming
#SBATCH --time=01::00
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --output=fastp_%j.out
#SBATCH --error=fastp_%j.err
raw_files="/homes/bilala/BedTools/Biocode_ATAC_Seq/raw_data/"
adapter_files="/homes/bilala/BedTools/Biocode_ATAC_Seq/raw_data/Adapter_Files"
clean_files="/homes/bilala/BedTools/Biocode_ATAC_Seq/raw_data/clean_data"
#"SRR13755450" "SRR13755451" "SRR13755452"
for file in "SRR13755449" "SRR13755450" "SRR13755451" "SRR13755452"; 
	do
    		echo "Running Fastp on $file"
    
    		fastp -i "$raw_files/${file}_1.fastq" \
          	-I "$raw_files/${file}_2.fastq" \
         	 -o "$clean_files/${file}_1.clean.fastq" \
         	 -O "$clean_files/${file}_2.clean.fastq" \
         	 --adapter_fasta "$adapter_files/${file}_1.fasta" \
          	--detect_adapter_for_pe
	done
