# Snakefile_paired_end

output_dir = "/homes/bilala/BedTools/Chipseq_2024/raw_data"
accession_numbers = [line.strip() for line in open("SRRA.txt")]

# Rule to download paired-end data
rule all_paired_end:
    input:
        expand(output_dir + "/{accession}_1.fastq", output_dir + "/{accession}_2.fastq", accession=accession_numbers)

rule download_paired_end:
    output:
        "{output_dir}/{accession}_1.fastq",
        "{output_dir}/{accession}_2.fastq"
    params:
        accession="{accession}",
        output_dir=output_dir
    shell:
        "fastq-dump --split-files -O {params.output_dir} {params.accession}"