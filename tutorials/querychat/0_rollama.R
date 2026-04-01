# Necassary packages
library(rollama)

# Shows if you can access Ollama
rollama::ping_ollama()
## Ollama (v0.17.5) is running at <http://localhost:11434>!

# Shows which models are available
rollama::list_models()
## # A tibble: 1 × 11
## name        model       modified_at   size digest parent_model format family families
## <chr>       <chr>       <chr>        <dbl> <chr>  <chr>        <chr>  <chr>  <list>  
##  1 llama3.1:8b llama3.1:8b 2026-03-02… 4.92e9 46e0c… ""           gguf   llama  <chr>   
##  # ℹ 2 more variables: parameter_size <chr>, quantization_level <chr>

# Select a model
model <- pull_model(model = "llama3.1:8b")
## ✔ pulling manifest [24ms]
## ✔ verifying sha256 digest [11ms]
## ✔ writing manifest [11ms]
## ✔ model llama3.1 pulled successfully!

# Ask a question with query(). It is just for this one question.
query("Why is the sky blue? Answer in one sentence", output = "text")
## The sky appears blue because of a phenomenon called Rayleigh scattering, 
## where sunlight scatters off tiny molecules of gases in the Earth's atmosphere, 
## causing shorter (blue) wavelengths to be reflected more than longer (red) 
## wavelengths.

# Start a chat with chat()
chat("Why is the sky blue? Answer in 3 sentences.")
## The sky appears blue because of a phenomenon called Rayleigh scattering, 
## where shorter (blue) wavelengths of light are scattered more than longer 
## (red) wavelengths by the tiny molecules of gases in the atmosphere. 
## This scattering effect gives the sky its blue color during the daytime when 
## the sun is overhead. At sunrise and sunset, the light has to travel through 
## more of the Earth's atmosphere, which scatters the shorter wavelengths, 
## making the sky appear red or orange instead.

chat("Why is seawater in some places more bright blue than other places? Answer 
     in one sentence")
## The brightness and intensity of seawater's blue color can be attributed to the 
## amount of sediment, algae, and other particles present in the water, which 
## scatter light in a way that affects its apparent color.

chat("Is this related to why the sky is blue? Answer in max 2 sentences")
## Yes, the phenomenon of scattering shorter wavelengths of light by tiny 
## molecules or particles is related to why both the sky and seawater can 
## appear blue. The difference lies in the size and type of particles involved: 
## atmospheric gases for the sky, and sediment, algae, and other waterborne 
## particles for seawater.

# Make a tibble with the chat history (could be of use later)
chat_history()
# A tibble: 6 × 3
## role      content                                                 time               
## <chr>     <chr>                                                   <dttm>             
##   1 user      "Why is the sky blue? Answer in 3 sentences."           2026-04-01 20:50:34
## 2 assistant "The sky appears blue because of a phenomenon called s… 2026-04-01 20:50:43
## 3 user      "Why is seawater in some places more bright blue than … 2026-04-01 20:50:53
## 4 assistant "Seawater appears brighter and bluer in certain areas … 2026-04-01 20:50:58
## 5 user      "Is this related to why the sky is blue? Answer in max… 2026-04-01 20:51:01
## 6 assistant "Yes, the reason seawater appears brighter blue in som… 2026-04-01 20:51:09


# Start a new chat with new_chat()
new_chat()

# Possible workflow could be querychat chats through chat() -> chat_history() 
# makes tibble from input and output -> new_chat() makes it available for 
# new question

chat_history()
