# This is a walkthrough of the tutorial for the rvat package: 
# https://kennalab.github.io/rvat/articles/basics.html
# Make sure to first run 'tutorials/rvat/1a_setup_gdb.R'

# Necessary packages
library(tidyverse)
library(rvat)
library(rvatData)
library(SummarizedExperiment)

# Use uploadCohort() to add information on phenotype into gdb 
# First we need a path
phenopath <- rvat_example("rvatData.pheno")
pheno <- read.table(phenopath, 
                    header = TRUE)
head(pheno)
## IID sex pheno pop superPop       PC1       PC2        PC3         PC4      age
## 1 ALS1   2     1 PJL      SAS  22.58749  4.738025 38.9157564 -10.1667342 66.01743
## 2 ALS2   2     1 BEB      SAS  26.37370 -1.445903 31.9712989  -6.0222555 66.84306
## 3 ALS3   1     1 TSI      EUR  30.75496 48.866843 -5.4092404  14.9474404 54.35749
## 4 ALS4   2     1 GWD      AFR -87.48035 -6.193628 -0.9504131  -1.2029932 65.09777
## 5 ALS5   1     1 MSL      AFR -87.79310 -5.323925 -1.0353300  -0.7403234 58.94664
## 6 ALS6   1     1 YRI      AFR -86.64071 -3.418417 -1.3964977   1.0561607 63.13635


# Now import it into gdb, name is the name of the table, 
# value is the information that should be uploaded (the table?)
uploadCohort(gdb,
             name = "pheno",
             value = pheno)
## Loading cohort 'pheno' from interactive R session

## 10 fields detected (IID,sex,pheno,pop,superPop,PC1,PC2,PC3,PC4,age)
## 
## 12865 males, 12135 females and 0 unknown gender
## Retained 25000 of 25000 uploaded samples that could be mapped to dosage matrix
## [1] 1

# To check which tables are in the gdb, use listCohort()
listCohort(gdb)
## name               value                     date
## pheno interactive_session Mon Mar 30 15:01:01 2026

# With getCohort() you can retrieve tables from gdb using name of the 
# table (cohort)
pheno_cohort <- getCohort(gdb,
          cohort = "pheno")
head(pheno_cohort)
## IID    sex pheno pop superPop       PC1       PC2        PC3         PC4      age
## ALS1   2     1   PJL      SAS  22.58749  4.738025 38.9157564 -10.1667342 66.01743
## ALS2   2     1   BEB      SAS  26.37370 -1.445903 31.9712989  -6.0222555 66.84306
## ALS3   1     1   TSI      EUR  30.75496 48.866843 -5.4092404  14.9474404 54.35749
## ALS4   2     1   GWD      AFR -87.48035 -6.193628 -0.9504131  -1.2029932 65.09777
## ALS5   1     1   MSL      AFR -87.79310 -5.323925 -1.0353300  -0.7403234 58.94664
## ALS6   1     1   YRI      AFR -86.64071 -3.418417 -1.3964977   1.0561607 63.13635

# Questions: what are PC1, PC2 etc.

