# Necessary packages
library(ellmer)
library(tidyverse)

# Check the possible models to choose from
models_ollama()

# 1        sqlcoder 2026-05-23 4108916695                       completion
# 2     duckdb-nsql 2026-05-23 3825898837                       completion
# 3          gemma3 2026-05-22 3338801804                completion,vision
# 4         mistral 2026-05-11 4372824384                 completion,tools
# 5     llama3.1:8b 2026-05-07 4920753328                 completion,tools
# 6          llama3 2026-05-06 4661224676                       completion
# 7        qwen3:8b 2026-05-04 5225388164        completion,tools,thinking
# 8   qwen2.5-coder 2026-04-20 4683087561          completion,tools,insert
# 9       phi4-mini 2026-04-20 2491876774                 completion,tools
# 10 deepseek-r1:8b 2026-04-20 5225376047              completion,thinking
# 11        qwen3.5 2026-04-20 6594474711 completion,vision,tools,thinking
# 12       llama3.2 2026-04-20 2019393189                 completion,tools


# Function to connect querychat to ollama using Ellmer, because Ellmer is at the base
# of querychat. See https://ellmer.tidyverse.org/reference/chat_ollama.html
model <- models_ollama()[7,1] ## Choosing the 7th model

# Make client to give to querychat. 
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

