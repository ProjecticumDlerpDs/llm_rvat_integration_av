# This script is used for getting a greater understanding of the genoMatrix type
# used in the rvat-package. For this the SummarizedExperiment tutorial is used
# https://bioconductor.org/packages/release/bioc/vignettes/SummarizedExperiment/inst/doc/SummarizedExperiment.html#common-operations-on-summarizedexperiment

# In the airway package 
library(SummarizedExperiment)
data(airway, package = "airway")

se <- airway
se
# class: RangedSummarizedExperiment 
# dim: 63677 8 
# metadata(1): ''
# assays(1): counts
# rownames(63677): ENSG00000000003 ENSG00000000005 ... ENSG00000273492
# ENSG00000273493
# rowData names(10): gene_id gene_name ... seq_coord_system symbol
# colnames(8): SRR1039508 SRR1039509 ... SRR1039520 SRR1039521
# colData names(9): SampleName cell ... Sample BioSample

head(assays(se))
## List of length 1
## names(1): counts

# Retrieve experiment data from certain assay (in this case the assay counts)
# Each row is a gene transcript, each column one of the samples
head(assays(se)$counts)
##                 SRR1039508 SRR1039509 SRR1039512 SRR1039513 SRR1039516 SRR1039517
## ENSG00000000003        679        448        873        408       1138       1047
## ENSG00000000005          0          0          0          0          0          0
## ENSG00000000419        467        515        621        365        587        799
## ENSG00000000457        260        211        263        164        245        331
## ENSG00000000460         60         55         40         35         78         63
## ENSG00000000938          0          0          2          0          1          0
## SRR1039520 SRR1039521
## ENSG00000000003        770        572
## ENSG00000000005          0          0
## ENSG00000000419        417        508
## ENSG00000000457        233        229
## ENSG00000000460         76         60
## ENSG00000000938          0          0

# 
