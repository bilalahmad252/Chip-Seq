#!/bin/bash 
#conda activate rna_seq
#MACS2 parameters
#There are seven major functions available in MACS2 serving as sub-commands. We will only cover callpeak in this lesson, but you can use macs2 COMMAND -h to find out more, if you are interested.

#callpeak is the main function in MACS2 and can be invoked by typing macs2 callpeak. If you type this command without parameters, you will see a full description of commandline options. Here is a shorter list of the commonly used ones:

#Input file options

#-t: The ChIP data file (this is the only REQUIRED parameter for MACS)
#-c: The control or mock data file
#-f: format of input file; Default is "AUTO", which will allow MACS to decide the format automatically.
#-g: mappable genome size, which is defined as the genome size that can be sequenced (1.0e+9 or 1000000000, are both accepted formats). Some precompiled values are provided (i.e. 'hs' for human (2.7e9), 'mm' for mouse (1.87e9), 'ce' for C. elegans (9e7) and 'dm' for fruitfly (1.2e8))
#https://github.com/hbctraining/Intro-to-ChIPseq-flipped/blob/main/lessons/06_peak_calling_macs.md
#Let us write the MACS2 command for all WT and mut reps for peak calling

macs2 callpeak -t /homes/bilala/BedTools/Chipseq_2024/results/bowtie2_alignment/WT_rep1_sorted_nodup.bam \
-c /homes/bilala/BedTools/Chipseq_2024/results/bowtie2_alignment/WT_input_rep1_sorted_nodup.bam \
-f BAM \
-g mm \
-n WT_rep1 \
--outdir /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks 2> WT_rep1.log
########################################################################################3
macs2 callpeak -t /homes/bilala/BedTools/Chipseq_2024/results/bowtie2_alignment/WT_rep2_sorted_nodup.bam \
-c /homes/bilala/BedTools/Chipseq_2024/results/bowtie2_alignment/WT_input_rep2_sorted_nodup.bam \
-f BAM \
-g mm \
-n WT_rep2 \
--outdir /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks 2> WT_rep2.log
#Mutant replicates#########

macs2 callpeak -t /homes/bilala/BedTools/Chipseq_2024/results/bowtie2_alignment/Mut_rep1_sorted_nodup.bam \
-c //homes/bilala/BedTools/Chipseq_2024/results/bowtie2_alignment/Mut_input_rep1_sorted_nodup.bam \
-f BAM \
-g mm \
-n mut_rep1 \
--outdir /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks 2> mut_rep1.log
#########################################33333s
macs2 callpeak -t /homes/bilala/BedTools/Chipseq_2024/results/bowtie2_alignment/Mut_rep2_sorted_nodup.bam \
-c /homes/bilala/BedTools/Chipseq_2024/results/bowtie2_alignment/Mut_input_rep2_sorted_nodup.bam \
-f BAM \
-g mm \
-n mut_rep2 \
--outdir /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks 2> mut_rep2.log
#The above commands will generate a lot of output files. The most important ones are the narrowPeak files, which contain the peak locations and their scores. These files can be used for further analysis, such as motif discovery, annotation, and visualization.
#The output files will be in the /homes/bilala/BedTools/Chipseq_2024/results/macs2_peaks directory. You can use the ls command to see the files that were generated.
