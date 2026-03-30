# This is a walkthrough of the tutorial for the rvat package: 
# https://kennalab.github.io/rvat/articles/basics.html
# Make sure to first run 'tutorials/rvat/1a_setup_gdb.R'

# Necessary packages
library(tidyverse)
library(rvat)
library(rvatData)
library(SummarizedExperiment)

# Subsetting a gdb is possible as follows for the gene ABCA4
subsetGdb(gdb,
          output = paste0(outdir, "/rvat_tutorials_subset.gdb"),
          where = "gene_name = 'ABCA4'",
          intersect = "varinfo",
          overWrite = TRUE) ## if there is a file with same name it overwrites
## 2026-03-30 18:54:34	Complete

gdb_subset <- gdb(paste0(outdir, "/rvat_tutorials_subset.gdb"))
anno_subset <- getAnno(gdb_subset,
                       table = "varinfo")
table(anno_subset$gene_name)
## ABCA4 
## 589 