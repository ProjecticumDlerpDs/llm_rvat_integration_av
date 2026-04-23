# Necessary packages
library(ellmer)
library(tidyverse)

# Check the possible models to choose from within ollama
all_models <- models_ollama()
all_models
possible_models <- all_models |>
  filter(str_detect(capabilities, "tools"))
possible_models
## id created_at       size     capabilities
## 1 llama3.1:8b 2026-04-17 4920753328 completion,tools
## 2     mistral 2026-04-17 4372824384 completion,tools

# Choose the model you want to use in querychat by selecting the row number of 
# previous function output where x is the row models_ollama()[x,1]
# When choosing a model make sure to use one with the capapbility 'tools'.
model <- possible_models[4,1] # selecting the 1st model

# Create the client for querychat, you can choose to set certain parameters here
# as well. 
client <-chat_ollama(
  system_prompt = NULL,
  base_url = Sys.getenv("OLLAMA_BASE_URL", "http://localhost:11434"),
  model = model,
  params = NULL,
  api_args = list(),
  echo = NULL,
  api_key = NULL,
  credentials = NULL,
  api_headers = character()
)

?chat_ollama()
