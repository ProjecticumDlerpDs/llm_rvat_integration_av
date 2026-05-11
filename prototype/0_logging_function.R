# Necessary packages
library(tidyverse)

# This is a function to turn an ellmer::get_turns object into a tibble for 
# data-analysis. It get's triggered when clicking the 'Save Chat History' button.
# It also writes this tibble to raw_data.rds. Within the function there are three
# arguments. 

turns_to_tibble <- function(turns, rep_nr = 1, file_path = "data/raw_data.rds") {
  result <- list()
  current_cycle <- NULL
  current_turns <- 0
  last_tool_call <- NULL
  last_tool_error <- NULL
  
  for (turn in turns) {
    current_turns <- current_turns + 1
    
    # User turn: start a new cycle
    if (turn@role == "user" && !is.null(turn@text) && nchar(turn@text) > 0) {
      if (!is.null(current_cycle)) {
        result <- c(result, list(current_cycle))
      }
      current_cycle <- list(
        prompt = as.character(turn@text),
        query = NA_character_,
        tool_name = NA_character_,
        tool_error = NA_character_,
        model = NA_character_,
        total_turns = 0,
        assistant_text = NA_character_,
        timestamp = Sys.time()  # Add timestamp for the cycle
        
      )
      current_turns <- 1
      last_tool_call <- NULL
      last_tool_error <- NULL
    }
    
    # Assistant turn: check for tool calls or final response
    if (turn@role == "assistant") {
      # Check for tool calls
      if (!is.null(turn@contents)) {
        for (content in turn@contents) {
          if (inherits(content, "ellmer::ContentToolRequest")) {
            last_tool_call <- list(
              name = as.character(content@name),
              query = as.character(content@arguments$query)
            )
          }
        }
      }
      
      # Check for final response
      if (!is.null(turn@json) && turn@json$choices[[1]]$finish_reason == "stop") {
        current_cycle$model <- as.character(turn@json$model)
        current_cycle$total_turns <- current_turns
        current_cycle$assistant_text <- as.character(turn@text)
        if (!is.null(last_tool_call)) {
          current_cycle$query <- as.character(last_tool_call$query)
          current_cycle$tool_name <- as.character(last_tool_call$name)
        }
        if (!is.null(last_tool_error)) {
          current_cycle$tool_error <- as.character(last_tool_error)
        }
      }
    }
    
    # User turn with tool result: check for errors
    if (turn@role == "user" && !is.null(turn@contents)) {
      for (content in turn@contents) {
        if (inherits(content, "ellmer::ContentToolResult") && !is.null(content@error)) {
          last_tool_error <- as.character(content@error$message)
        }
      }
    }
  }
  
  # Add the last cycle
  if (!is.null(current_cycle)) {
    result <- c(result, list(current_cycle))
  }
  
  # Convert to tibble
  new_tibble <- tibble::tibble(
    prompt = vapply(result, function(x) as.character(x$prompt), FUN.VALUE = character(1)),
    query = vapply(result, function(x) as.character(x$query), FUN.VALUE = character(1)),
    tool_name = vapply(result, function(x) as.character(x$tool_name), FUN.VALUE = character(1)),
    tool_error = vapply(result, function(x) as.character(x$tool_error), FUN.VALUE = character(1)),
    model = vapply(result, function(x) as.character(x$model), FUN.VALUE = character(1)),
    total_turns = vapply(result, function(x) as.numeric(x$total_turns), FUN.VALUE = numeric(1)),
    assistant_text = vapply(result, function(x) as.character(x$assistant_text), FUN.VALUE = character(1)),
    replicate = rep_nr,
    timestamp = vapply(result, function(x) as.numeric(x$timestamp), FUN.VALUE = numeric(1))
  )
  # Check if the file exists
  if (file.exists(file_path)) {
    # Load the existing tibble
    existing_tibble <- readRDS(file_path)
    # Append new rows
    updated_tibble <- bind_rows(existing_tibble, new_tibble)
  }
  else {
    # No existing file, use the new tibble
    updated_tibble <- new_tibble
  }
  
  # Save the updated tibble
  saveRDS(updated_tibble, file_path)
}
