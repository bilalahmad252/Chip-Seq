#!/bin/bash
#LET US COMBINE THE PEAKS FROM THE TWO REPLICATES

module load BEDTools # Load the BEDTools module from Beocat
bedtools intersect -wo -f 0.30 -r \
-a /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/WT_rep1_peaks_filtered.bed \
-b /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/WT_rep2_peaks_filtered.bed \
> /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/WT_final_peaks.bed

#Same thing for the mutant samples
bedtools intersect -wo -f 0.30 -r \
-a /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/mut_rep1_peaks_filtered.bed \
-b /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/mut_rep2_peaks_filtered.bed \
> /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/mut_final_peaks.bed
#The final peaks will be used for further analysis, such as motif discovery, annotation, and visualization.
#The -wo option will output the original A and B entries plus the number of base pairs of overlap between the two entries. 
#The -f 0.30 option will require at least 30% of the shorter peak to be overlapped by the longer peak. 
#The -r option will require that the fraction of overlap be reciprocal for both A and B.
#The final peaks will be used for further analysis, such as motif discovery, annotation, and visualization.
