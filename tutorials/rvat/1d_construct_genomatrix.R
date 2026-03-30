# This is a walkthrough of the tutorial for the rvat package: 
# https://kennalab.github.io/rvat/articles/basics.html
# Make sure to first run 'tutorials/rvat/1a_setup_gdb.R'

# Necessary packages
library(tidyverse)
library(rvat)
library(rvatData)
library(SummarizedExperiment)

# There are different ways to construct a genomatrix, by directly passing varID's
# By providing a set of genomic ranges or by supplying a varSet(this isn't done
# in this script but in the second rvat tutorial)
# 1. Directly passing varID's, first select which VAR_id's you want 
varinfo_sub <- getAnno(gdb,
                       table = "varinfo",
                       where = "gene_name = 'SOD1' and ModerateImpact = 1")
# Making a genomatrix based on the cohort "pheno" and with varinfo_sub VAR_id's
GT <- getGT(gdb,
            VAR_id = varinfo_sub$VAR_id,
            cohort = "pheno")

GT
## rvat genoMatrix Object
## class: genoMatrix 
## dim: 38 25000 
## metadata(11): gdb gdbId ... geneticModel imputeMethod
## assays(1): GT
## rownames(38): 1268 1270 ... 1315 1316
## rowData names(2): ploidy w
## colnames(25000): ALS1 ALS2 ... CTRL19999 CTRL20000
## colData names(10): IID sex ... PC4 age

# 2. Retrieve variants within a certain range, also include annotations by using
# anno in the getGT() function, here the fields we want from the annotations are
# also given
GT_ranges <- getGT(
  gdb,
  ranges = data.frame(CHROM = "chr21",
                      start = 31659666,
                      end = 31668931),
  cohort = "pheno",
  anno = "varInfo",
  annoFields = c("VAR_id", "CHROM", "POS", "REF", "ALT", "HighImpact", 
                 "ModerateImpact", "Synonymous")
)
## Retrieved genotypes for 49 variants
GT_ranges

## rvat genoMatrix Object
## class: genoMatrix 
## dim: 49 25000 
## metadata(11): gdb gdbId ... geneticModel imputeMethod
## assays(1): GT
## rownames(49): 1268 1269 ... 1315 1316
## rowData names(9): ploidy w ... ModerateImpact Synonymous
## colnames(25000): ALS1 ALS2 ... CTRL19999 CTRL20000
## colData names(10): IID sex ... PC4 age

# Selecting only VARid's with moderate impact of 1. 
GT_ranges_impact1 <- GT_ranges[rowData(GT_ranges)$ModerateImpact == 1,]

GT_ranges_impact1
## rvat genoMatrix Object
## class: genoMatrix 
## dim: 38 25000 
## metadata(11): gdb gdbId ... geneticModel imputeMethod
## assays(1): GT
## rownames(38): 1268 1270 ... 1315 1316
## rowData names(9): ploidy w ... ModerateImpact Synonymous
## colnames(25000): ALS1 ALS2 ... CTRL19999 CTRL20000
## colData names(10): IID sex ... PC4 age