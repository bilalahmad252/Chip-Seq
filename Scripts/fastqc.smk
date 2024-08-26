# FASTQC quality check
# Rule to specify concrete files for the workflow
input_directory ="/homes/bilala/BedTools/Chipseq_2024/raw_data"
output_directory= "/homes/bilala/BedTools/Chipseq_2024/results/FASTQC"
rule all:
    input:
        expand("/homes/bilala/BedTools/Chipseq_2024/results/FASTQC/{sample}_fastqc.html", sample=glob_wildcards("/homes/bilala/BedTools/Chipseq_2024/raw_data/{sample}.fastq").sample),
        expand("/homes/bilala/BedTools/Chipseq_2024/results/FASTQC/{sample}_fastqc.zip", sample=glob_wildcards("/homes/bilala/BedTools/Chipseq_2024/raw_data/{sample}.fastq").sample)

rule fastqc:
    input:
        "input_directory/{sample}.fastq"
       
    output:
        html="ooutput_directory/{sample}_fastqc.html",
        zip="output_directory/{sample}_fastqc.zip"
        
    shell:
        "fastqc {input}  -o  output_directory"

