# Necessary packages
library(querychat)
library(palmerpenguins)

# Add greeting tutorials/querychat/0_greeting.md
greeting_path <- "tutorials/querychat/0_greeting.md"

# The client must be an ellmer chat object (first run 'tutorials/querychat/0_ellmer)
qc <- querychat(penguins, 
                client = client_ollama,
                greeting = greeting_path)

# Start querychat app with the following code
qc$app()


