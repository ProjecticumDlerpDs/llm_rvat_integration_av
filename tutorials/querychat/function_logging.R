library(tidyverse)

#' Convert ellmer::get_turns object to a tibble
#'
#' @param turns An ellmer::get_turns object
#' @return A tibble with one row per user-assistant cycle
#' 
#'
#'
turns_to_tibble <- function(turns) {
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
        assistant_text = NA_character_
      )
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
          current_cycle$query <- last_tool_call$query
          current_cycle$tool_name <- last_tool_call$name
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
  tibble::tibble(
    prompt = sapply(result, function(x) x$prompt),
    query = sapply(result, function(x) x$query),
    tool_name = sapply(result, function(x) x$tool_name),
    tool_error = sapply(result, function(x) x$tool_error),
    model = sapply(result, function(x) x$model),
    total_turns = sapply(result, function(x) x$total_turns),
    assistant_text = sapply(result, function(x) x$assistant_text)
  )
}
