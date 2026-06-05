# Necessary packages
library(ellmer)
library(tidyverse)
library(rollama)

# Check if you can access Ollama with rollama::ping_ollama()
# If not first download Ollama here: https://ollama.com/
rollama::ping_ollama()
## Ollama (v0.17.5) is running at <http://localhost:11434>!

# Download any wanted models with rollama::pull_model(model = "name model")

# Check all the models to choose from within ollama
all_models <- models_ollama()
all_models

# Show only the models that are appropiate to use with querychat (it needs to have
# capability "tools")
possible_models <- all_models |>
  filter(str_detect(capabilities, "tools"))
possible_models


# Choose the model you want to use in querychat by selecting the row number of 
# the preferred model as the x in possible_models[x,1].
# The best performing model up until now has been "qwen3:8b". 
model <- possible_models[3,1] # selecting model

# Create the client for querychat by creating an Ellmer chat object through Ellmer's
# chat_ollama() function. You can choose to set certain parameters here
# as well. See more information with: ?chat_ollama()
client <-chat_ollama(
  system_prompt = NULL, ## this will be filled with querychat's system prompt
  base_url = Sys.getenv("OLLAMA_BASE_URL", "http://localhost:11434"),
  model = model, ## the model that was selected
  params = NULL, ## here you can change the temperature and other parameters
  api_args = list(),
  echo = NULL,
  api_key = NULL,
  credentials = NULL,
  api_headers = character()
)
