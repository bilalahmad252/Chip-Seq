# Snakefile

output_dir = "/homes/bilala/BedTools/Chipseq_2024/raw_data"
accession_numbers = [line.strip() for line in open("SRRA.txt")]

# Let us define the rule that will download the raw data
rule all:
    input:
        expand(output_dir + "/{accession}.fastq", accession=accession_numbers)

rule download_raw_data:
    output:
        "{output_dir}/{accession}.fastq"
    params:
        accession="{accession}",
        output_dir=output_dir
    shell:
        """
        if [ -e "{params.output_dir}/{params.accession}_1.fastq" ]; then
            echo "(o) {params.accession} already downloaded"
        else
            echo "(o) Downloading {params.accession}"
            fastq-dump --split-files -O {params.output_dir} {params.accession}
            echo "(o) Downloaded {params.accession}"
            sleep 1
        fi
        """
