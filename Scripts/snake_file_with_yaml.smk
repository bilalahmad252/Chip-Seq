# Snakefile

import os

# Configuration file
configfile: "config.yaml"

# Read SRA accession numbers from file
sample_files = config['samples_files']

# Let us make an empty list to store the accession numbers
samples = []

# Let us open the file and read the accession numbers
with open(sample_files, 'r') as file:
    for line in file:
        samples.append(line.strip())

# Let us read the names of files in a directory and append them to a list called final_samples
final_samples = []
final_files_path = os.path.join(config['root_results'], config['alignment'], config['sorted_redup_bam'])
for file in os.listdir(final_files_path):
    if file.endswith(".bam") and not file.startswith("SRR"):
        final_samples.append(file.split("_")[0])
##############################################################

rule all:
    input:
        expand(os.path.join(config['data'], config['raw_data'], "{sample}.fastq"), sample=samples),
        expand(os.path.join(config['root_results'], config['FASTQC'], "{sample}_fastqc.html"), sample=samples),
        expand(os.path.join(config['root_results'], config['FASTQC'], "{sample}_fastqc.zip"), sample=samples),
        expand(os.path.join(config['data'], config['trimmed_data'], "{sample}_fastp.fastq"), sample=samples),
        expand(os.path.join(config['data'], config['reference_data'], config['genome_index'], "mm10.{index}.{file_extension}"), index=["1", "2", "3", "4", "rev.1", "rev.2"], file_extension=["bt2"], sample=samples),
        expand(os.path.join(config['root_results'], config['alignment'], config['bowtie2_alignment'], "{sample}.bam"), sample=samples),
        expand(os.path.join(config['root_results'], config['alignment'], config['sorted_bam'], "{sample}_sorted.bam"), sample=samples),
        expand(os.path.join(config['root_results'], config['alignment'], config['sorted_redup_bam'], "{sample}_sorted_rmdup.bam"), sample=samples),
        expand(os.path.join(config['root_results'], config['Peaks'], "{sample}_{reads}_peaks.narrowPeak"), sample=final_samples, reads=["rep1", "rep2"]),
        expand(os.path.join(config['root_results'], config['Final_peaks'], "{sample}_filtered_peaks.narrowPeak"), sample=final_samples),
        expand(os.path.join(config['root_results'], config['alignment'], config['sorted_redup_bam_indices'], "{sample}_input_{reads}.bai"), sample=final_samples, reads=["rep1", "rep2"]),
        expand(os.path.join(config['root_results'], config['alignment'], config['sorted_redup_bam_indices'], "{sample}_chip_{reads}.bai"), sample=final_samples, reads=["rep1", "rep2"]),
        expand(os.path.join(config['root_results'], config['visualization'], config['bigWig'], "{sample}_input_{reads}.bw"), sample=final_samples, reads=["rep1", "rep2"]),
        expand(os.path.join(config['root_results'], config['visualization'], config['bigWig'], "{sample}_chip_{reads}.bw"), sample=final_samples, reads=["rep1", "rep2"]),
        expand(os.path.join(config['root_results'], config['visualization'], config['Bed_Files'], "{sample}_{reads}_peaks.bed"), sample=final_samples, reads=["rep1", "rep2"]),
        expand(os.path.join(config['root_results'], config['visualization'], config['Final_Peaks_BED'], "{sample}_final_peaks.bed"), sample=final_samples)


rule fastq_dump:
    output:
        os.path.join(config['data'], config['raw_data'], "{sample}.fastq")
    params:
        output_directory=os.path.join(config['data'], config['raw_data']),  # Make sure this is set to the correct directory
        accession="{sample}"
    shell:
        """
        module load SRA-Toolkit
        fastq-dump {params.accession} -O {params.output_directory}
        """

rule runfastqc:
    input:
        os.path.join(config['data'], config['raw_data'], "{sample}.fastq")
    output:
        os.path.join(config['root_results'], config['FASTQC'], "{sample}_fastqc.html"),
        os.path.join(config['root_results'], config['FASTQC'], "{sample}_fastqc.zip")
    params:
        fastqc_output_directory=os.path.join(config['root_results'], config['FASTQC'])
    log:
        os.path.join(config['root_results'], config['FASTQC'], "{sample}_fastqc.log")
    threads: 12
    message: "Running FastQC on {input}"
    shell:
        """
        module load FastQC
        fastqc {input} -o {params.fastqc_output_directory}
        """

rule run_fastp:
    input:
        os.path.join(config['data'], config['raw_data'], "{sample}.fastq")
    output:
        os.path.join(config['data'], config['trimmed_data'], "{sample}_fastp.fastq")
    log:
        os.path.join(config['data'], config['trimmed_data'], "{sample}_fastp.log")
    threads: 12
    message: "Running Fastp on {input}"
    shell:
        """
        fastp -i {input} -o {output}
        """

rule build_index:
    input:
        os.path.join(config['data'], config['reference_data'], config['genome']),
    output:
        expand(os.path.join(config['data'], config['reference_data'], config['genome_index'], "mm10.{index}.{file_extension}"), index=["1", "2", "3", "4", "rev.1", "rev.2"], file_extension=["bt2"])
    params:
        output_directory=os.path.join(config['data'], config['reference_data'], config['genome_index'], "mm10")
    shell:
        """
        module load Bowtie2
        bowtie2-build {input} {params.output_directory}
        """

rule bowtie2_alignment:
    input:
        fastq_files=os.path.join(config['data'], config['trimmed_data'], "{sample}_fastp.fastq")
    output:
        os.path.join(config['root_results'], config['alignment'], config['bowtie2_alignment'], "{sample}.bam")
    log:
        os.path.join(config['root_results'], config['alignment'], config['bowtie2_alignment'], "{sample}.log")
    params:
        genome_index=os.path.join(config['data'], config['reference_data'], config['genome_index'], "mm10")
    threads: 12
    message: "Running Bowtie2 on {input}"
    shell:
        """
        module load Bowtie2
        module load SAMtools
        bowtie2 -x {params.genome_index} -U {input.fastq_files} | samtools view -bS - > {output}
        """

rule sort_bam:
    input:
        os.path.join(config['root_results'], config['alignment'], config['bowtie2_alignment'], "{sample}.bam")
    output:
        os.path.join(config['root_results'], config['alignment'], config['sorted_bam'], "{sample}_sorted.bam")
    shell:
        """
        module load SAMtools
        samtools sort -o {output} {input}
        """

rule remove_duplicates:
    input:
        os.path.join(config['root_results'], config['alignment'], config['sorted_bam'], "{sample}_sorted.bam")
    output:
        os.path.join(config['root_results'], config['alignment'], config['sorted_redup_bam'], "{sample}_sorted_rmdup.bam")
    shell:
        """
        sambamba view -h -t 12 -f bam -F "[XS] == null and not unmapped and not duplicate" {input} > {output}
        """

rule peak_calling:
    input:
        input_bam=os.path.join(config['root_results'], config['alignment'], config['sorted_redup_bam'], "{sample}_input_{reads}.bam"),
        chip_bam=os.path.join(config['root_results'], config['alignment'], config['sorted_redup_bam'], "{sample}_chip_{reads}.bam")
    output:
        os.path.join(config['root_results'], config['Peaks'], "{sample}_{reads}_peaks.narrowPeak")
    params:
        genome_size="mm",
        out_dir=os.path.join(config['root_results'], config['Peaks'])
    shell:
        """
        # module load MACS2
        macs2 callpeak -t {input.chip_bam} \
         -c {input.input_bam} \
          -f BAM \
          -g {params.genome_size} \
          -n {wildcards.sample}_{wildcards.reads} \
          --outdir {params.out_dir}
        """
rule filter_peaks:
    input:
        rep1=os.path.join(config['root_results'], config['Peaks'], "{sample}_rep1_peaks.narrowPeak"),
        rep2=os.path.join(config['root_results'], config['Peaks'], "{sample}_rep2_peaks.narrowPeak")
    output:
        os.path.join(config['root_results'], config['Final_peaks'], "{sample}_filtered_peaks.narrowPeak")
    params:
        blacklist=config['blacklist']
    shell:
        """
        bedtools intersect -wo -f 0.30 -r -a {input.rep1} -b {input.rep2} | bedtools intersect -v -a stdin -b {params.blacklist} > {output}
        """
rule bam_index:
    input:
        input_bam=os.path.join(config['root_results'], config['alignment'], config['sorted_redup_bam'], "{sample}_input_{reads}.bam"),
        chip_bam=os.path.join(config['root_results'], config['alignment'], config['sorted_redup_bam'], "{sample}_chip_{reads}.bam")
    output:
        input_index=os.path.join(config['root_results'], config['alignment'], config['sorted_redup_bam_indices'], "{sample}_input_{reads}.bai"),
        chip_index=os.path.join(config['root_results'], config['alignment'], config['sorted_redup_bam_indices'], "{sample}_chip_{reads}.bai")
    shell:
        """
        module load SAMtools
        samtools index {input.input_bam} -c {output.input_index}
        samtools index {input.chip_bam} -c {output.chip_index}
        """

rule bam_to_bigwig:
    input:
        input_bam=os.path.join(config['root_results'], config['alignment'], config['sorted_redup_bam'], "{sample}_input_{reads}.bam"),
        chip_bam=os.path.join(config['root_results'], config['alignment'], config['sorted_redup_bam'], "{sample}_chip_{reads}.bam"),
        input_bam_index=os.path.join(config['root_results'], config['alignment'], config['sorted_redup_bam_indices'], "{sample}_input_{reads}.bai"),
        chip_bam_index=os.path.join(config['root_results'], config['alignment'], config['sorted_redup_bam_indices'], "{sample}_chip_{reads}.bai")
    output:
        os.path.join(config['root_results'], config['visualization'], config['bigWig'], "{sample}_input_{reads}.bw"),
        os.path.join(config['root_results'], config['visualization'], config['bigWig'], "{sample}_chip_{reads}.bw")
    params:
        bam_directory=os.path.join(config['root_results'], config['alignment'], config['sorted_redup_bam'])
    
    shell:
        """
        # module load deepTools
        cp {input.input_bam_index}  {params.bam_directory}
        cp {input.chip_bam_index}  {params.bam_directory}
        bamCoverage -b {input.input_bam} --binSize 20 --outFileFormat bigwig --outFileName {output[0]}
        bamCoverage -b {input.chip_bam} --binSize 20 --outFileFormat bigwig --outFileName {output[1]}
        """

rule narrowpeak_to_bed:
    input:
        os.path.join(config['root_results'], config['Peaks'],"{sample}_{reads}_peaks.narrowPeak")
    output:
       os.path.join(config['root_results'], config['visualization'], config['Bed_Files'], "{sample}_{reads}_peaks.bed")
    shell:
        """
        cut -f 1-6 {input} > {output}
        """
#Rule to ocnvert Final Peaks in narrowPeak format to bed format
rule final_peaks_to_bed:
    input:
        os.path.join(config['root_results'], config['Final_peaks'], "{sample}_filtered_peaks.narrowPeak")
    output:
        os.path.join(config['root_results'], config['visualization'], config['Final_Peaks_BED'], "{sample}_final_peaks.bed")
    shell:
        """
        cut -f 1-6 {input} > {output}
        """
