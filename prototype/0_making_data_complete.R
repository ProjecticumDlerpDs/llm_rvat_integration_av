# Necessary packages
library(tidyverse)

# Extract questions from greeting.md
text <- as.vector(read_file("prototype/prompts/greeting.md"))
clean_questions <- as_tibble(str_extract_all(text, 
                                   "<span class=\"suggestion\">.*</span>", 
                                   simplify = TRUE))

# Make data tidy 
clean_questions <- pivot_longer(clean_questions, 
                                cols = V1:V17,  
                                names_to = "question_nr",
                                values_to = "question")

# Delete the <span class=\"suggestion\"> and </span> part of the string
clean_questions$question <- clean_questions$question |>
  str_replace_all(pattern = "<span class=\"suggestion\">", replacement = "") |>
  str_replace(pattern = "</span>", replacement = "")

# Make tibble with question number, question 
# and type of question (lookup, analytic or negative control (nc))
control_questions <- tibble(question_nr = seq(1:17),
       question = clean_questions$question)

# The first 5 questions are lookup questions, questions 6 to 11 are analytical questions
# Question 12 to 17 are negative control questions (nc). 
control_questions <- control_questions |>
  mutate(type_question = case_when(
    control_questions$question_nr <= 5 ~ "lookup",
    control_questions$question_nr > 5 & control_questions$question_nr <= 11 ~ "analytical",
    TRUE ~ "nc"
  ))

# Add type_question and question_nr to the raw_data table and call it data_complete.
raw_data <- readRDS("data/raw_data.rds")
data_complete <- left_join(raw_data,
                           control_questions,
                           by = join_by(prompt == question))
write_rds(data_complete, "data/data_complete.rds")                           
