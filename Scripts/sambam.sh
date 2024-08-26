#!/bin/bash  #Shibang line
#This script will convert SAM files to BAM files using samtools and then sort the BAM files using samtools and remove duplicates using sambamba tools
#Load SAMtools module
module load SAMtools
#Let us write a for loop to find all the SAM files in the current directory and convert them to BAM files
for file in *.sam; do 
 samtools view -h -S -b -o ${file%.sam}.bam $file   # Putting it all together, ${file%.sam}.bam takes the value stored in the variable file, removes the ".sam" extension (if present), and then appends ".bam" to the resulting string. This is often used to change file extensions or modify filenames in shell scripts. For example, if file is "example.sam", ${file%.sam}.bam would evaluate to "example.bam".
#rm $file #Remove the SAM file
done
#Now let us sort the BAM files
for file in *.bam; 
do
    samtools sort $file -o ${file%.bam}.sorted.bam
done
#Now let us remove duplicates using sambamba
for file in *.sorted.bam;
do
   sambamba view -h -t 2 -f bam \
   -F "[XS] == null and not unmapped and not duplicate" \
   $file ${file%.sorted.bam}.sorted.nodup.bam
done
#-t: number of threads(cores)
#-h: print SAM header before reads
#-f: format of output file (default is SAM)
#-F: set custom filter - we will be using the filter to remove duplicates, multimappers and unmapped reads.
# More filterings options are available in the sambamba documentation https://github.com/biod/sambamba/wiki/%5Bsambamba-view%5D-Filter-expression-syntax