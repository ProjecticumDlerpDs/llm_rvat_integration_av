# First run '1_quickstart_querychat' Exploring the server of querychat
library(shiny)
library(bslib)
library(querychat)
library(DT)
library(palmerpenguins)

# The following code is partly from Querychat: 
# https://posit-dev.github.io/querychat/r/articles/build.html
# Step 1: Create querychat object
qc <- QueryChat$new(penguins, 
                    client = client_ollama, 
                    greeting = "tutorials/querychat/0_greeting.md"
                    )

# Step 2: Add UI component 
ui <- page_sidebar(
  sidebar = qc$sidebar(), ## sidebar with LLM 
  card(
    card_header("Data Table"),
    dataTableOutput("table") ## unfiltered dataframe that can be filtered
  ),
  card(
    fill = FALSE,
    card_header("SQL Query"),
    verbatimTextOutput("sql") ## 
  ),
  card(
    fill = FALSE,
    card_header("Status"),
    verbatimTextOutput("status")
  )
  
  ## Possibly add reactive prompt + answer that can be trigger for observe()
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
  observe({
    invalidateLater(60000, session)  # Check every minute
    
    # Get the last turn
    last_turn <- qc_vals$client$last_turn()
    
    # Check if it's not NULL and has contents
    if (!is.null(last_turn) && !is.null(last_turn@contents)) {
      for (content in last_turn@contents) {
        if (inherits(content, "ellmer::ContentToolRequest")) {
          cat("Tool called: ", content@name, "\n")
          cat("Arguments: ", content@arguments, "\n")
          # Add your custom logic here
        }
      }
    }
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
