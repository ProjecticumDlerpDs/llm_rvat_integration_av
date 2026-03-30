# This is a walkthrough of the tutorial for the rvat package: 
# https://kennalab.github.io/rvat/articles/basics.html
# Make sure to first run 'tutorials/rvat/1a_setup_gdb.R' and 
# 'tutorials/rvat/1d_construct_genomatrix.R'

# Necessary packages
library(tidyverse)
library(rvat)
library(rvatData)
library(SummarizedExperiment)

# Retrieving colData() from GT (sample info)
head(colData(GT))
## IID       sex     pheno         pop    superPop       PC1       PC2
## <character> <numeric> <integer> <character> <character> <numeric> <numeric>
## ALS1        ALS1         2         1         PJL         SAS   22.5875   4.73803
## ALS2        ALS2         2         1         BEB         SAS   26.3737  -1.44590
## ALS3        ALS3         1         1         TSI         EUR   30.7550  48.86684
## ALS4        ALS4         2         1         GWD         AFR  -87.4804  -6.19363
## ALS5        ALS5         1         1         MSL         AFR  -87.7931  -5.32393
## ALS6        ALS6         1         1         YRI         AFR  -86.6407  -3.41842
## PC3        PC4       age
## <numeric>  <numeric> <numeric>
##   ALS1 38.915756 -10.166734   66.0174
## ALS2 31.971299  -6.022256   66.8431
## ALS3 -5.409240  14.947440   54.3575
## ALS4 -0.950413  -1.202993   65.0973
## ALS5 -1.035330  -0.740323   58.9466
## ALS6 -1.396498   1.056161   63.1363

# Retrieving variant info (rowData())
head(rowData(GT))
## DataFrame with 6 rows and 2 columns
## ploidy         w
## <character> <numeric>
## 1268     diploid         1
## 1270     diploid         1
## 1271     diploid         1
## 1273     diploid         1
## 1275     diploid         1
## 1276     diploid         1

# Show metadata
metadata(GT)
## $gdb
## [1] "/tmp/RtmpD1iGg9/rvat_tutorials.gdb"
## 
## $gdbId
## [1] "tw280xcgq5uz7auiulfikkvpv9cv"
## 
## $genomeBuild
## [1] "GRCh38"
## 
## $ploidyLevels
## [1] "diploid"
## 
## $m
## [1] 25000
## 
## $nvar
## [1] 38
## 
## $varSetName
## [1] "unnamed"
##
## $unit
## [1] "unnamed"
## 
## $cohort
## [1] "pheno"
## 
## $geneticModel
## [1] "allelic"
## 
## $imputeMethod
## [1] "none"

# Making subsets works the same with a dataframe (object[rows, columns])
GT[1:5, 1:5] ## get row 1 to 5 and column 1 to 5 from GT

## rvat genoMatrix Object
## class: genoMatrix 
## dim: 5 5 
## metadata(11): gdb gdbId ... geneticModel imputeMethod
## assays(1): GT
## rownames(5): 1268 1270 1271 1273 1275
## rowData names(2): ploidy w
## colnames(5): ALS1 ALS2 ALS3 ALS4 ALS5
## colData names(10): IID sex ... PC4 age

# Make subset where pheno == 1
GT[,GT$pheno == 1]
## rvat genoMatrix Object
## class: genoMatrix 
## dim: 38 5000 
## metadata(11): gdb gdbId ... geneticModel imputeMethod
## assays(1): GT
## rownames(38): 1268 1270 ... 1315 1316
## rowData names(2): ploidy w
## colnames(5000): ALS1 ALS2 ... ALS4999 ALS5000
## colData names(10): IID sex ... PC4 age

## subset first 2 variants with subjects older than 70
GT[1:2, GT$age > 70]
## rvat genoMatrix Object
## class: genoMatrix 
## dim: 2 3910 
## metadata(11): gdb gdbId ... geneticModel imputeMethod
## assays(1): GT
## rownames(2): 1268 1270
## rowData names(2): ploidy w
## colnames(3910): ALS17 ALS31 ... CTRL19990 CTRL19995
## colData names(10): IID sex ... PC4 age

# genotypes can be retrieved like this:
assays(GT)$GT[1:5,1:5]
## ALS1 ALS2 ALS3 ALS4 ALS5
## 1268    0    0    0    0    0
## 1270    0    0    0    0    0
## 1271    0    0    0    0    0
## 1273    0    0    0    0    0
## 1275    0    0    0    0    0