#LEt us write a code to run FastQC
#!/bin/bash #This a shipang line
#Load the FastQC module
module load FastQC
#Run FastQC on the data
for file in *.fastq ; do
    fastqc -o /homes/bilala/BedTools/Chipseq_2024/results/FASTQC $file
    done