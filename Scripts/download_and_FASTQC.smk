# Snakefile_single_end

output_dir = "/homes/bilala/BedTools/Chipseq_2024/raw_data"
accession_numbers = [line.strip() for line in open("SRRA.txt")]

# Rule to download single-end data
rule all_single_end:
    input:
        expand(output_dir + "/{accession}.fastq", accession=accession_numbers)

rule download_single_end:
    output:
        "{output_dir}/{accession}.fastq"
    params:
        accession="{accession}",
        output_dir=output_dir
    shell:
        "fastq-dump -O {params.output_dir} {params.accession}"
rule run_fastqc:
    input:
        "{output_dir}/{accession}.fastq"
    output:
        directory("/homes/bilala/BedTools/Chipseq_2024/results/FASTQC")
    shell:
        "fastqc {input} -o {output}"