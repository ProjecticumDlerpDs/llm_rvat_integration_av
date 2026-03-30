# This is a walkthrough of the tutorial for the rvat package: 
# https://kennalab.github.io/rvat/articles/basics.html

# Necessary packages
library(tidyverse)
library(rvat)
library(rvatData)
library(SummarizedExperiment)
library(renv)

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

## 2026-03-28 13:24:16	Creating gdb tables
## 25000 sample IDs detected
## 2026-03-28 13:24:16	Parsing vcf records
## 2026-03-28 13:24:38	Processing completed for 1000 records. Committing to db.
## 2026-03-28 13:24:53	Processing completed for 1802 records. Committing to db.
## 2026-03-28 13:24:53	Creating var table indexes
## 2026-03-28 13:24:53	Creating SM table index
## 2026-03-28 13:24:53	Creating dosage table index
## 2026-03-28 13:24:53	Creating ranged var table
## 2026-03-28 13:24:53	Completervat gdb object
## Path: /tmp/RtmpjHtl8w/rvat_tutorials.gdb 

# With this function you connect to the gdb
gdb <- gdb(paste0(outdir,"/rvat_tutorials.gdb"))
