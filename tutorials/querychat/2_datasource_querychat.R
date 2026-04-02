# Necessary packages
library(querychat)
library(DBI)
library(RSQLite)

# You can use a dataframe like mtcars
class(mtcars) ## [1] "data.frame"
qc <- querychat(mtcars, 
                client = client_ollama)

# The focus will be on SQLite databases, because that is the base of the RVAT 
# package


