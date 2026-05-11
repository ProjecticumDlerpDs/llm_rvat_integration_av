# Necessary packages
library(ellmer)
library(tidyverse)

# Check the possible models to choose from within ollama
all_models <- models_ollama()
all_models
possible_models <- all_models |>
  filter(str_detect(capabilities, "tools"))
possible_models
## id created_at       size                     capabilities
## 1 qwen2.5-coder 2026-04-20 4683087561          completion,tools,insert
## 2     phi4-mini 2026-04-20 2491876774                 completion,tools
## 3       mistral 2026-04-20 4372824384                 completion,tools
## 4       qwen3.5 2026-04-20 6594474711 completion,vision,tools,thinking
## 5      llama3.2 2026-04-20 2019393189                 completion,tools
## 6   llama3.1:8b 2026-04-17 4920753328                 completion,tools

# Choose the model you want to use in querychat by selecting the row number of 
# previous function output where x is the row models_ollama()[x,1]
# When choosing a model make sure to use one with the capapbility 'tools'.
model <- possible_models[2,1] # selecting model

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
