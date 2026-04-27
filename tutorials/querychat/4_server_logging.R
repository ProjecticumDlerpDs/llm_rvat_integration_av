# First run '1_quickstart_querychat' Exploring the server of querychat
library(shiny)
library(bslib)
library(querychat)
library(DT)
library(palmerpenguins)
library(tidyverse)

# The following code is partly from Querychat: 
# https://posit-dev.github.io/querychat/r/articles/build.html
# Step 1: Create querychat object
qc <- QueryChat$new(penguins, 
                    client = client_ollama, 
                    greeting = "tutorials/querychat/0_greeting.md"
                    )

# Step 2: Add UI component 
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
    qc_vals$sql() %||% "SELECT * FROM penguins"
  })
  
  # When save_chat button is clicked convert conversation to tibble with 
  # turns_to_tibble() function
  observeEvent(input$save_chat, {
    chat_client <- qc_vals$client
    turns <- chat_client$get_turns(include_system_prompt = FALSE)
    chat_tibble <- turns_to_tibble(turns)
    # Display the tibble as a table
    # output$chat_table <- renderDT({
    #   DT::datatable(chat_tibble, options = list(scrollX = TRUE))
    # })
    write.csv(chat_tibble, "tutorials/querychat/tool_requests_history.csv", row.names = FALSE)
    # chevk structure 
    str(chat_tibble)
    })
  # observe({
  #   if (!is.null(qc_vals$sql())) {
  #     str(qc_vals$client$last_turn())
  #     # Check if 'querychat_penguins-chat_user_input' exists in input
  #   # if ("querychat_penguins-chat_user_input" %in% names(input)) {
  #     # print(names(qc_vals$client))}
  #     # cat("Input user:\n")
  #     # print(input$'querychat_penguins-chat_user_input')  # Print user prompt
  #     # cat("\nOutput names:\n")
  #     # print(names(output))  # Print output names
  #    }
  # })
}
shinyApp(ui, server)
## Create reactive object
## Use observe() to know when querychat had final message 
## Use promises to have asynchronous logging -> better for not blocking UI
?shinyApp
