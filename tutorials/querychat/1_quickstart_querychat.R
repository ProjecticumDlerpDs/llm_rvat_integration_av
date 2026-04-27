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
# You can also start a console

