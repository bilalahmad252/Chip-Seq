BiocManager::install("ChIPseeker")
BiocManager::install("TxDb.Hsapiens.UCSC.hg19.knownGene")
BiocManager::install("clusterProfiler")


library(ChIpseeker)

#reading peak files, must end in .bed or .bed.gz
#grep -v "GL" normal.bed | grep -v "KI" > normal.filtered.bed


tumor <- readPeakFile("tumor.filtered.bed")
normal <- readPeakFile("normal.filtered.bed")

#let's find out the location of all the peaks on the entire genome

covplot(tumor, weightCol = "V5")
covplot(normal, weightCol = "V5")

#Comparison of both conditions for coverage
peaks = GenomicRanges::GRangesList((Tumor=tumor),
                                   Normal=normal)
p <- covplot(peaks)
library(ggplot2)
col <- c(Tumor="brown", Normal='Red')
p + facet_grid(chr ~ .id) + scale_color_manual(values=col) + scale_fill_manual(values=col)



#Profile of ChIP peaks binding to TSS regions

#First of all, for calculating the profile of ChIP peaks binding to TSS regions, we should prepare the TSS regions, which are defined as the flanking sequence of the TSS sites. Then align the peaks that are mapping to these regions, and generate the tagMatrix.
txdb = TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene

promoter <- getPromoters(TxDb=txdb, upstream=3000, downstream=3000)
tagMatrix <- getTagMatrix(readPeakFile("normal.bed"), windows=promoter)

tagHeatmap(tagMatrix, xlim=c(-3000, 3000), color="red")
