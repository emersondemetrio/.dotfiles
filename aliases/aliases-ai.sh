alias claude="chrome 'https://claude.ai/new'"

alias prompt="~/scripts/src/python/ai.py"
alias ollama_prompt="~/scripts/src/python/ai.py -l 'ollama'"

alias t="prompt --task translate"
alias tp="prompt --task translate -ol 'Portuguese'"
alias grammar="prompt --task grammar"

alias syntax="prompt --task syntax"
alias adsyntax="prompt --task adsyntax"

alias explain="prompt --task explain"

alias summarize="prompt --task summarize --file $1"

alias long="prompt --keep"

alias tone="prompt -t tone --tone"
HARVEST_PROMPT="I will list tasks I completed during my day, and when I say 'I am done,' or iad, you should format them into a markdown list. Please fix any grammar mistakes and add a specific task ID (e.g., [TIME-XXXX]) before each line if I mention one. Once formatted, keep the list concise and well-structured."
alias harvest="prompt --keep \"$HARVEST_PROMPT\""

alias clip-prompt="clippaste | prompt --debug --task prompt"

alias localhost="chrome 'http://localhost:5173'"