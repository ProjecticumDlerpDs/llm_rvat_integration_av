# Necessary packages
library(tidyverse)
library(rvat)
library(rvatData)
library(SummarizedExperiment)

# These are the in-memory datasets 
data(package = "rvatData")$results[,"Item"]
## [1] "GT"         "GTsmall"    "rvbresults"

# Paths to on-disk datasets can be retrieved like this (this gives the names of
# existing example files)
rvat_example()
## [1] "rvatData_varsetfile.txt.gz" "rvatData.gdb"              
## [3] "rvatData.pheno"             "rvatData.varinfo"          
## [5] "rvatData.vcf.gz"

# Makes an object of the path of the gdb file in example files
gdbpath <- rvat_example("rvatData.gdb")

# To make sure output gets stored in a temporary direction this code is used
outdir <- tempdir()

# How to create a gdb from VCF file?
vcfpath <- rvat_example("rvatData.vcf.gz") ## Contains path example VCF file
buildGdb(vcf = vcfpath,
         output = paste0(outdir,"/rvat_tutorials.gdb"), 
         overWrite = TRUE,
         genomeBuild = "GRCh38")

## 2026-03-16 17:47:32	Creating gdb tables
## 25000 sample IDs detected
## 2026-03-16 17:47:32	Parsing vcf records
## 2026-03-16 17:47:56	Processing completed for 1000 records. Committing to db.
## 2026-03-16 17:48:11	Processing completed for 1802 records. Committing to db.
## 2026-03-16 17:48:11	Creating var table indexes
## 2026-03-16 17:48:11	Creating SM table index
## 2026-03-16 17:48:11	Creating dosage table index
## 2026-03-16 17:48:11	Creating ranged var table
## 2026-03-16 17:48:11	Completervat gdb object
## Path: /tmp/Rtmp0ta3DS/rvat_tutorials.gdb 
## Warning message:
## call dbDisconnect() when finished working with a connection 

# With this function you connect to the gdb
gdb <- gdb(paste0(outdir,"/rvat_tutorials.gdb"))

# Import variant info with uploadAnno()
# example file including info such as chromosomal location, annotated gene and variant impact.
varinfopath <- rvat_example("rvatData.varinfo")
varinfo <- read.table(varinfopath, header = TRUE)
head(varinfo)
## CHROM      POS          ID REF ALT     QUAL FILTER AC    AN           AF
## 1  chr1 11013912        <NA>   A   G   722.13     NA  1 45484 0.0000219858
## 2  chr1 11013928 rs755357622   C   T  2598.23     NA  1 49194 0.0000203277
## 3  chr1 11013936        <NA>   A   C  4135.36     NA  1 50000 0.0000200000
## 4  chr1 11013936        <NA>   A   G  4135.36     NA  1 42636 0.0000234544
## 5  chr1 11013952        <NA>   C   G   517.13     NA  1 49574 0.0000201719
## 6  chr1 11016874  rs80356715   C   T 64910.10     NA 32 49766 0.0006430093
## gene_name HighImpact ModerateImpact Synonymous CADDphred PolyPhen SIFT
## 1    TARDBP          0              1          0      24.8        P    D
## 2    TARDBP          0              0          1         .        .    .
## 3    TARDBP          0              1          0      24.1        B    T
## 4    TARDBP          0              1          0      22.6        B    T
## 5    TARDBP          0              0          1         .        .    .
## 6    TARDBP          0              1          0      22.2        B    T

# the `name` parameter specifies the name of the table in the gdb, 
# the variant info that should be imported is specified using the `value` parameter
uploadAnno(object = gdb, name = "varInfo",value = varinfo)
## Loading table 'varInfo' from interactive R session'
## 17 fields detected (CHROM,POS,ID,REF,ALT,QUAL,FILTER,AC,AN,AF,gene_name,
## HighImpact,ModerateImpact,Synonymous,CADDphred,PolyPhen,SIFT)
## [1] 1

