params.input = "SRRA.txt"
params.singleEnd = 1
params.outputDirectory = "/homes/bilala/BedTools/Nextflow/fastq"
params.fastqc_results = "/homes/bilala/BedTools/Nextflow/fastqc_results"
nextflow.enable.dsl=2
params.fastp_results = "/homes/bilala/BedTools/Nextflow/fastp_results"
params.accession = file(params.input).text.trim().split("\n")

process DownloadData {
    tag "Download data from SRA"
    publishDir params.outputDirectory, mode: 'copy'

    input:
    path accession_file

    output:
    path "*.fastq" 

    script:
    """    
    module load SRA-Toolkit
    cat ${accession_file} | xargs -I {} fastq-dump {}
    """
}

process run_fastqc {
    tag "Running FastQC"
    publishDir params.fastqc_results, mode: 'copy'

    input:
    path reads

    output:
    path "${reads.baseName}_fastqc.html"

    script:
    """  
    echo ${reads}
    module load FastQC
    fastqc ${reads}
    """
}

process run_fastp {
    tag "Running Fastp"
    publishDir params.fastp_results, mode: 'copy'

    input:
    path reads

    output:
    path "${reads.baseName}_fastp.fastq"

    script:
    """  
    echo ${reads}
    
    fastp -i ${reads} -o ${reads.baseName}_fastp.fastq
    """
}

workflow {
    SRRA_file = file(params.input)
    fastq_downloaded_files=DownloadData(SRRA_file)
    //fastq_downloaded_files.view()
    fastq_downloaded_files_flatten=fastq_downloaded_files.flatten() //.flatten() is used to convert the list of list to list
    fastq_downloaded_files_flatten.view()
    fastqc_files=run_fastqc(fastq_downloaded_files_flatten)
    fastp_files=run_fastp(fastq_downloaded_files_flatten)
    //fastq_files_ch = Channel.fromFilePairs(params.outputDirectory + "/*.fastq", size: 1, singleEnd: params.singleEnd)
    //fastq_files_ch.view()
    
}
