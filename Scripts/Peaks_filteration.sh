#!/bin/bash
#Filtering peaks to remove blacklisted regions
module load BEDTools # Load the BEDTools module from Beocat
#The ENCODE project has identified regions of the genome that are problematic for ChIP-seq analysis. These regions are called blacklisted regions. We will use the bedtools intersect command to remove peaks that overlap with these regions.
#The blacklisted regions for the mm10 genome are available from the ENCODE project. We will use the mm10.blacklist.bed file to filter the peaks.
#The bedtools intersect command will remove peaks that overlap with the blacklisted regions. The -v option will output the peaks that do not overlap with the blacklisted regions.
#The -a option specifies the input file, and the -b option specifies the file to be used for filtering.
#-v option will output the peaks that do not overlap with the blacklisted regions.

bedtools intersect  -v \
-a /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/WT_rep1_peaks_chr.narrowPeak \
-b /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/mm10.blacklist.bed \
> /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/WT_rep1_peaks_filtered.bed

#For the WT_rep2 sample
bedtools intersect  -v \
-a /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/WT_rep2_peaks_chr.narrowPeak \
-b /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/mm10.blacklist.bed \
> /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/WT_rep2_peaks_filtered.bed

#For the Mut_rep1 sample
bedtools intersect  -v \
-a /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/mut_rep1_peaks_chr.narrowPeak \
-b /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/mm10.blacklist.bed \
> /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/mut_rep1_peaks_filtered.bed

#For the Mut_rep2 sample
bedtools intersect  -v \
-a /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/mut_rep2_peaks_chr.narrowPeak \
-b /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/mm10.blacklist.bed \
> /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks/mut_rep2_peaks_filtered.bed
#The filtered peaks will be used for further analysis, such as motif discovery, annotation, and visualization.