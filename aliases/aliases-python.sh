ENV_INSTRUCTIONS="
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
"

alias make_env="echo '$ENV_INSTRUCTIONS';"
