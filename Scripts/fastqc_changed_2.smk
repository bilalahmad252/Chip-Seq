# FASTQC quality check
# Rule to specify concrete files for the workflow
input_directory = "/homes/bilala/BedTools/Chipseq_2024/raw_data"
output_directory = "/homes/bilala/BedTools/Chipseq_2024/results/FASTQC"

from snakemake.io import expand, glob_wildcards
def input_files(wildcards):
     files = glob_wildcards(f"{input_directory}/{wildcards.sample}.fastq")
     return [f"{input_directory}/{sample}.fastq" for file in files.sample]



rule all:
    input:
        expand("{output_directory}/{{sample}}_fastqc.html", output_directory=output_directory, sample=glob_wildcards(f"{input_directory}/{{sample}}.fastq").sample),
        expand("{output_directory}/{{sample}}_fastqc.zip", output_directory=output_directory, sample=glob_wildcards(f"{input_directory}/{{sample}}.fastq").sample)

rule fastqc:
    input:
        input_files
       
    output:
        html="{output_directory}/{{sample}}_fastqc.html",
        zip="{output_directory}/{{sample}}_fastqc.zip"
        
    shell:
        "fastqc {input} -o {output_directory}" 
