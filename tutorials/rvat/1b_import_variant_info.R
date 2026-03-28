# This is a walkthrough of the tutorial for the rvat package: 
# https://kennalab.github.io/rvat/articles/basics.html
# Make sure to first run 'tutorials/rvat/1a_setup_gdb.R'

# Necessary packages
library(tidyverse)
library(rvat)
library(rvatData)
library(SummarizedExperiment)
library(renv)

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

# listAnno() shows all variant annotation tables in the gdb
listAnno(gdb)
## name               value                     date
## 1 varInfo interactive_session Sat Mar 28 13:34:08 2026

# getAnno() retrieves a table from the gdb
variant_info <- getAnno(gdb, table = "varinfo")