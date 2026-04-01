# Necessary packages
library(querychat)
library(palmerpenguins)

# Trying to connect with rollama doesn't work (first run 'tutorials/querychat/0_rollama')
querychat_app(penguins, client = model)
## Error in `as_querychat_client()`:
## ! `client` must be an ellmer <Chat> object or a function that returns one

# Must be an ellmer chat object. (first run 'tutorials/querychat/0_ellmer)
querychat_app(penguins, client = client_ollama)
## Listening on http://127.0.0.1:4514
## Warning: No `greeting` provided to `QueryChat()`. Using the LLM `client` to generate one now.
## ℹ For faster startup, lower cost, and determinism, consider providing a `greeting` to
## `QueryChat()`.
## ℹ You can use your querychat::QueryChat object's `$generate_greeting()` method to
##   generate a greeting.