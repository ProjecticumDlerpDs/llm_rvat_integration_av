# Necessary packages
library(ellmer)
library(tidyverse)

# Check the possible models to choose from
models_ollama()
##              id created_at        size     capabilities
## 1        mixtral 2026-04-17 26443602516       completion
## 2 deepseek-coder 2026-04-17   776080839       completion
## 3           phi3 2026-04-17  2176178913       completion
## 4    llama3.1:8b 2026-04-17  4920753328 completion,tools
## 5        mistral 2026-04-17  4372824384 completion,tools
# Function to connect querychat to ollama using Ellmer, because Ellmer is base
# of querychat. See https://ellmer.tidyverse.org/reference/chat_ollama.html
model <- models_ollama()[7,1]

# Make client to give to querychat. See 
client_ollama <-chat_ollama(
  system_prompt = NULL,
  base_url = Sys.getenv("OLLAMA_BASE_URL", "http://localhost:11434"),
  model = model,
  params = NULL,
  api_args = list(),
  echo = "all",
  api_key = NULL,
  credentials = NULL,
  api_headers = character()
)

## This does work when running 'tutorials/querychat/1_quickstart_querychat'

# In ellmer you can get a structured chat output with multiple prompts by using
# parallel_chat_structured()
chat <- chat_ollama (model = model)
chat$chat("How can I log ellmer responses? Answer in 4 sentences")
prompts <- list("Is the sky blue?",
                "How can I log ellmer responses?")
outpulast_turn()output <- type_object(prompt = type_string(), answer = type_string())
parallel_chat_structured(chat, prompts, output)

