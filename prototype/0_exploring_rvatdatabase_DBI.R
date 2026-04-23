# This is a test to see if the rvat database works with DBI functions. This 
# is necessary to connect the database to querychat.
# Make sure to first run 'tutorials/rvat/1a_setup_gdb.R'

# Necessary packages
library(tidyverse)
library(rvat)
library(rvatData)
library(SummarizedExperiment)
library(DBI)
library(RSQLite)

# The way to connect to the database is through the function gdb to check if 
# the gdb s4 class object is a DBIConnection the function inherits() can be 
# used. 
inherits(gdb, "DBIConnection")
## TRUE

# To check if it is possible to use DBI functions we check the following
DBI::dbGetInfo(gdb)
## $db.version
## [1] "3.51.2"
## 
## $dbname
## [1] "/tmp/Rtmp1OdDGk/rvat_tutorials.gdb"
## 
## $username
## [1] NA
## 
## $host
## [1] NA
## 
## $port
## [1] NA

dbIsReadOnly(gdb)
## FALSE

# List tables of the database
DBI::dbListTables(gdb)
## [1] "SM"         "anno"       "cohort"     "dosage"     "meta"       "var"       
## [7] "var_ranges"

# Get the columns of the tables
DBI::dbListFields(gdb, "SM")
## "IID" "sex"
DBI::dbListFields(gdb, "anno")
## "name"  "value" "date" 
DBI::dbListFields(gdb, "cohort")
## "name"  "value" "date" 
DBI::dbListFields(gdb, "dosage")
## "VAR_id" "GT"
DBI::dbListFields(gdb, "meta")
## "name"  "value"
DBI::dbListFields(gdb, "var")
## [1] "VAR_id" "CHROM"  "POS"    "ID"     "REF"    "ALT"    "QUAL"   "FILTER" "INFO"  
## [10] "FORMAT"
DBI::dbListFields(gdb, "var_ranges")
## "CHROM"  "ranges"
## "CHROM"  "ranges"