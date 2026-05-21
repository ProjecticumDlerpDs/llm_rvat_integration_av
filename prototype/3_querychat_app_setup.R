# Necessary packages
library(querychat)
library(rvat)
library(rvatData)
library(DBI)
library(RSQLite)
library(shiny)
library(bslib)
library(DT)
library(tidyverse)

# Before using this script, be sure to first setup the client and gdb and run these
# scripts. If client and gdb setup are already installed with your preferences 
# run these scripts with the following code:
source("prototype/1_client_setup.R")

# source("prototype/2_gdb_setup.R")

# To allow for logging run and type replicate number after rep_nr <- 
source("prototype/0_logging_function.R")
rep_nr <- 1

# Paths with additional prompts for greeting, data_description and extra_instructions
greeting_path <- "prototype/prompts/greeting.md"
data_desc_path <- "prototype/prompts/data_description.md"
extra_instruct_path <- "prototype/prompts/extra_instructions.md"

# Connect to database:
con <- dbConnect(RSQLite::SQLite(), rvat_example("rvatData.gdb"))

# Connect querychat to client and gdb table "varInfo_synthetic". 
qc <- querychat(data_source = con,
                table_name = "varInfo_synthetic",
                client = client,
                greeting = greeting_path,
                data_description = data_desc_path,
                extra_instructions = extra_instruct_path)

# Step 2: Add UI component (basic from querychat tutorial + added 'Save
# Chat History' action button)
ui <- page_sidebar(
  sidebar = qc$sidebar(),
  actionButton("save_chat", "Save Chat History"),
  verbatimTextOutput("chat_history"),
  ## sidebar with LLM 
  card(
    card_header("Data Table"),
    dataTableOutput("table") ## unfiltered dataframe that can be filtered
  ),
  card(
    fill = FALSE,
    card_header("SQL Query"),
    verbatimTextOutput("sql") ## 
  )
)

# Step 3: Use reactive values in server
server <- function(input, output, session) {
  qc_vals <- qc$server()
  
  output$table <- renderDataTable({
    datatable(qc_vals$df(), fillContainer = TRUE)
  })
  
  output$sql <- renderText({
    qc_vals$sql() %||% "SELECT * FROM "
  })
  
  # When save_chat button is clicked convert conversation to tibble with 
  # turns_to_tibble() function
  observeEvent(input$save_chat, {
    chat_client <- qc_vals$client
    # return chat history with $get_turns
    turns <- chat_client$get_turns(include_system_prompt = FALSE)
    # Turn chat history into tibble with turns_to_tibble() function
    turns_to_tibble(turns, rep_nr = rep_nr, file_path = "data/raw_data.rds")
  })

}
shinyApp(ui, server)

# When done run, this also disconnects from database: 
qc$cleanup()

# If logging, update 'prototype/4_making_data_complete.R' with
source("prototype/4_making_data_complete.R")

