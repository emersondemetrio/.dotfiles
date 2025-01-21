#!/opt/homebrew/bin/python3

import os
from openai import OpenAI
from dotenv import load_dotenv
import ollama
import argparse

"""
# Instructions (how to install and use)
pip3 install python-dotenv --break-system-packages
pip3 install openai --break-system-packages
pip3 install ollama --break-system-packages # requires models. Run ollama run llama3.2
"""

load_dotenv()

if not os.getenv("OPENAI_API_KEY"):
    raise ValueError("OPENAI_API_KEY is not set")

def get_translation_prompt(lang="english"):
    return f"Only give me the translation to {lang} of the following text: "


GRAMMAR_PROMPT=f"Only reply with the applied english grammar checks and corrections to the following text: "
SYNTAX_PROMPT="Only reply with the most simple example syntax of the following prompt: "
AD_SYNTAX_PROMPT="Only reply with the example syntax of the following prompt: "

OpenAIClient = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))


def ollama_prompt(prompt: str, content: str) -> str:
    try:
        messages = [
            {
                "role": "user",
                "content": prompt,
            }
        ]

        if content:
            messages.append({"role": "user", "content": content})

        res = ollama.chat(
            model="llava",
            messages=messages
        )

        response = res["message"]["content"]

        return response
    except Exception as e:
        print()
        print("Could not connect to Ollama API. Is it running?")
        print()
        print("> ollama run llama3.2 ")


def openai_prompt(prompt: str, content: str) -> str:
    messages = [
        {
            "role": "user",
            "content": prompt,
        }
    ]

    if content:
        messages.append({"role": "user", "content": content})

    result = OpenAIClient.chat.completions.create(
        model="gpt-4o",
        messages=messages
    )

    return result.choices[0].message.content


parser = argparse.ArgumentParser()


parser.add_argument("prompt", help="Prompt", nargs='?',
                    default="default prompt")
parser.add_argument("-p", "--prompt", help="Prompt")
parser.add_argument("-c", "--context", help="Context", default=None)
parser.add_argument("-f", "--file", help="File")
parser.add_argument("-l", "--lib", help="Library to use", default="openai")
parser.add_argument("-o", "--output", help="Output file", default=None)
parser.add_argument("-t", "--task", help="Task to perform", default="chat")
parser.add_argument("-ol", "--output-lang", help="Output language", default="en")

args = parser.parse_args()

def process_output(output: str, dest: str):
    if dest != "print":
        with open(args.output, "w") as file:
            file.write(output)
            print(f"Output written to file {args.output}")
    else:
        print()
        print('- ' * 40)
        print()
        print(output)
        print()
        print('- ' * 40)
        print()

def get_file_content(file: str) -> str:
    with open(file, "r") as file:
        return file.read()

context = None
task = args.task
prompt = args.prompt
output_lang = args.output_lang

if task == "translate":
    prompt = f"{get_translation_prompt(output_lang)}{prompt}"

if task == "grammar":
    prompt = f"{GRAMMAR_PROMPT}{prompt}"

if task == "syntax":
    prompt = f"{SYNTAX_PROMPT}{prompt}"

if task == "adsyntax":
    prompt = f"{AD_SYNTAX_PROMPT}{prompt}"

if args.file:
    context = get_file_content(args.file)

if args.context:
    context = args.context

result = None

if args.lib == "o" or args.lib == "ollama":
    result = ollama_prompt(prompt, context)
else:
    result = openai_prompt(prompt, context)

if args.output:
    process_output(result, args.output)
else:
    process_output(result, "print")
