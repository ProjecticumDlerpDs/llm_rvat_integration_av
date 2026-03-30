# This is a walkthrough of the tutorial for the rvat package: 
# https://kennalab.github.io/rvat/articles/basics.html
# Make sure to first run 'tutorials/rvat/1a_setup_gdb.R' and 
# 'tutorials/rvat/1d_construct_genomatrix.R'

# Necessary packages
library(tidyverse)
library(rvat)
library(rvatData)
library(SummarizedExperiment)

# Get variant allel frequencies from GT
getAF(GT)
## 1268         1270         1271         1273         1275         1276 
## 1.260187e-04 2.021591e-05 2.252049e-05 1.007293e-04 2.000000e-05 2.056428e-05 
## 1277         1278         1279         1281         1282         1283 
## 2.000000e-05 2.157404e-05 2.000000e-05 2.183025e-05 2.162256e-05 2.237237e-05 
## 1284         1285         1287         1288         1289         1290 
## 2.000000e-05 2.000000e-05 2.128656e-05 2.052798e-05 2.000000e-05 1.420000e-03 
## 1291         1292         1293         1294         1296         1297 
## 2.003928e-05 2.045157e-05 2.193463e-05 2.029386e-05 2.133834e-05 8.000000e-05 
## 1298         1299         1300         1304         1305         1306 
## 2.139129e-05 2.850859e-04 2.008355e-05 2.015560e-05 2.115059e-05 2.050945e-05 
## 1307         1308         1309         1312         1313         1314 
## 2.000000e-05 4.648568e-05 2.072024e-05 4.112688e-05 2.297689e-05 2.025686e-05 
## 1315         1316 
## 4.123031e-05 2.115507e-05

# Get the alternate allel counts
getAC(GT)
## 1268 1270 1271 1273 1275 1276 1277 1278 1279 1281 1282 1283 1284 1285 1287 1288 1289 
## 6    1    1    5    1    1    1    1    1    1    1    1    1    1    1    1    1 
## 1290 1291 1292 1293 1294 1296 1297 1298 1299 1300 1304 1305 1306 1307 1308 1309 1312 
## 71    1    1    1    1    1    4    1   14    1    1    1    1    1    2    1    2 
## 1313 1314 1315 1316 
## 1    1    2    1 

# Flip genotype dosages (having 0, 1, or 2 of the allels) so all values represent
# minor allele counts: flipToMinor()
GT_flip <- flipToMinor(GT)

# Return variant summary summariseGeno()
sumgeno <- summariseGeno(GT)
head(sumgeno)
## VAR_id           AF callRate geno0 geno1 geno2 hweP
## 1268   1268 1.260187e-04  0.95224 23800     6     0    1
## 1270   1270 2.021591e-05  0.98932 24732     1     0    1
## 1271   1271 2.252049e-05  0.88808 22201     1     0    1
## 1273   1273 1.007293e-04  0.99276 24814     5     0    1
## 1275   1275 2.000000e-05  1.00000 24999     1     0    1
## 1276   1276 2.056428e-05  0.97256 24313     1     0    1

# Meanimpute genotype dosage (changing empty values to mean) with recode()
recode(GT, imputeMethod = "meanImpute")
## rvat genoMatrix Object
## class: genoMatrix 
## dim: 38 25000 
## metadata(11): gdb gdbId ... geneticModel imputeMethod
## assays(1): GT
## rownames(38): 1268 1270 ... 1315 1316
## rowData names(2): ploidy w
## colnames(25000): ALS1 ALS2 ... CTRL19999 CTRL20000
## colData names(10): IID sex ... PC4 age

# Apply dominent model* with recode()
# *There are other genetic models:
# 1. Additive: 0, 1, 2 (effect proportional to allele count)
# 2. Dominant: 0 if no minor allele, 1 if at least one minor allele
# 3. Recessive: 0 if less than two minor alleles, 1 if homozygous minor
recode(GT, geneticModel = "dominant")

## rvat genoMatrix Object
## class: genoMatrix 
## dim: 38 25000 
## metadata(11): gdb gdbId ... geneticModel imputeMethod
## assays(1): GT
## rownames(38): 1268 1270 ... 1315 1316
## rowData names(2): ploidy w
## colnames(25000): ALS1 ALS2 ... CTRL19999 CTRL20000
## colData names(10): IID sex ... PC4 age

# Aggregate genotype counts across variants, this creates one aggregate score 
# per individual (a burden score)
GT_agg <- aggregate(recode(GT, imputeMethod = "meanImpute"), 
                    returnGT = TRUE)
summary(GT_agg$aggregate)
## Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
## 0.000e+00 4.102e-05 4.595e-05 5.531e-03 1.275e-04 2.000e+00 

# Retrieve ID's of carriers per variant with getCarriers()
getCarriers(GT, 
            colDataFields = c("pop", "age"))[1:10,]
# VAR_id       IID genotype pop      age
# 1    1268   ALS1811        1 YRI 56.59491
# 2    1268   ALS2109        1 LWK 53.64514
# 3    1268   ALS2155        1 GIH 45.68899
# 4    1268   ALS3076        1 YRI 60.34504
# 5    1268   ALS4396        1 GWD 74.22662
# 6    1268   ALS4476        1 CHB 62.46120
# 7    1270 CTRL14060        1 KHV 67.61440
# 8    1271 CTRL18522        1 PUR 47.41249
# 9    1273   ALS1117        1 IBS 49.17095
# 10   1273   ALS3310        1 FIN 50.09404

# Association testing briefly:
burden_results <- assocTest(GT,
                            pheno = "pheno",
                            covar = c("PC1", "PC2", "PC3", "PC4"),
                            test = c("firth", "skat", "acatv"),
                            name = "analysis")

## Keeping 25000/25000 available samples for analysis.
## 38/38 variants are retained for analysis
## Warning message:
##   In .rvat_ACAT(pvals[is.keep], weights.transformed[is.keep]) :
##   There are p-values that are exactly 0!

burden_results
## rvbResult with 3 rows and 24 columns
## unit cohort varSetName     name pheno           covar geneticModel MAFweight
## <character>  <Rle>      <Rle>    <Rle> <Rle>           <Rle>        <Rle>     <Rle>
## 1     unnamed  pheno    unnamed analysis pheno PC1,PC2,PC3,PC4      allelic         1
## 2     unnamed  pheno    unnamed analysis pheno PC1,PC2,PC3,PC4      allelic         1
## 3     unnamed  pheno    unnamed analysis pheno PC1,PC2,PC3,PC4      allelic         1
## test      nvar caseCarriers ctrlCarriers meanCaseScore meanCtrlScore     caseN
## <Rle> <numeric>    <numeric>    <numeric>     <numeric>     <numeric> <numeric>
## 1 firth        38           77           51     0.0170918    0.00264118      5000
## 2 skat         38           77           51     0.0170918    0.00264118      5000
## 3 acatv        38           77           51     0.0170918    0.00264118      5000
## ctrlN caseCallRate ctrlCallRate    effect  effectSE effectCIlower effectCIupper
## <numeric>    <numeric>    <numeric> <numeric> <numeric>     <numeric>     <numeric>
##   1     20000     0.962705     0.962584   1.75552  0.176317       1.41495       2.10837
## 2     20000     0.962705     0.962584        NA        NA            NA            NA
## 3     20000     0.962705     0.962584        NA        NA            NA            NA
## OR          P
## <numeric>  <numeric>
##   1   5.78647 0.0000e+00
## 2        NA 2.1049e-10
## 3        NA 0.0000e+00
