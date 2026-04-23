# Necessary packages
library(rvat)
library(rvatData)
library(DBI)
library(RSQLite)

# To use table 'varInfo_synthetic' use the premade script in 
# 'prototype/received_files/create_varInfo_synthetic-1.R'
source("prototype/received_files/create_varInfo_synthetic-1.R")

# Connect to the gdb
con <- dbConnect(RSQLite::SQLite(), rvat_example("rvatData.gdb"))

# Check if there is a table 'varInfo_synthetic'
dbListTables(con)
## [1] "SM"                "anno"              "cohort"            "dosage"           
## [5] "meta"              "pheno"             "var"               "varInfo"          
## [9] "varInfo_synthetic" "var_ranges"

# Check column names in 'varInfo_synthetic'
dbListFields(con, "varInfo_synthetic")
## [1] "VAR_id"         "CHROM"          "POS"            "ID"            
## [5] "REF"            "ALT"            "QUAL"           "FILTER"        
## [9] "AC"             "AN"             "AF"             "gene_name"     
## [13] "HighImpact"     "ModerateImpact" "Synonymous"     "CADDphred"     
## [17] "PolyPhen"       "SIFT"           "ALS_1"          "ALS_2"         
## [21] "ALS_3"          "ALS_4"          "ALS_5"          "Control_1"     
## [25] "Control_2"      "Control_3"      "Control_4"      "Control_5" 

# Check the first 5 rows
dbGetQuery(con, "SELECT * FROM varInfo_synthetic LIMIT 5")
# When done disconnect with following function:
# dbDisconnect(con)
