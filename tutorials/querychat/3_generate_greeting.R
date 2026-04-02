# Necessary packages
library(querychat)
library(palmerpenguins)

# First tell querychat which database you want to use
qc <- querychat(mtcars, 
                client = client_ollama)

# Ask LLm to generate the greeting
generated_greeting <- qc$generate_greeting(echo = "text")

# Save this greeting
writeLines(generated_greeting, "tutorials/querychat/0_generated_greeting.md")

# Generate app with the greeting
querychat_app(mtcars,
              client = client_ollama,
              greeting = "tutorials/querychat/0_generated_greeting.md")
