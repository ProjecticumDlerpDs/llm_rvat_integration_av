# Necessary packages
library(querychat)
library(rvat)
library(rvatData)
library(DBI)
library(RSQLite)

greeting_path <- "prototype/prompts/greeting.md"
data_desc_path <- "prototype/prompts/data_description.md"
# First setup client and gdb
# Connect querychat to client and gdb. 
qc <- querychat(data_source = con,
                table_name = "varInfo_synthetic",
                client = client,
                greeting = greeting_path,
                data_description = data_desc_path,
                cleanup = TRUE)
# Start shiny app
qc_app <- qc$app_obj()
qc_app

qc$console(new = TRUE, , tools = "query", "update")

?querychat
