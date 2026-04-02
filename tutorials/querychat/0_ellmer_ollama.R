# Necessary packages
library(ellmer)
library(tidyverse)

# Check the possible models to choose from
models_ollama()
#   id          created_at size       capabilities
# 1 llama3.1:8b 2026-04-01 4920753328 completion,tools
# 2    llama3.1 2026-04-01 4920753328 completion,tools

# Function to connect querychat to ollama using Ellmer, because Ellmer is base
# of querychat. See https://ellmer.tidyverse.org/reference/chat_ollama.html
model <- models_ollama()[1,1]
client_ollama <-chat_ollama(
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

## This does work when running 'tutorials/querychat/1_quickstart_querychat