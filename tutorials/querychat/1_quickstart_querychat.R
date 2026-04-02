# Necessary packages
library(querychat)
library(palmerpenguins)

greeting_path <- "tutorials/querychat/0_greeting.md"
# Must be an ellmer chat object. (first run 'tutorials/querychat/0_ellmer)
qc <- querychat(penguins, 
                client = client_ollama,
                greeting = greeting_path)

# Start querychat app
qc$app()
## Listening on http://127.0.0.1:4514
## Warning: No `greeting` provided to `QueryChat()`. Using the LLM `client` to generate one now.
## ℹ For faster startup, lower cost, and determinism, consider providing a `greeting` to
## `QueryChat()`.
## ℹ You can use your querychat::QueryChat object's `$generate_greeting()` method to
##   generate a greeting.
