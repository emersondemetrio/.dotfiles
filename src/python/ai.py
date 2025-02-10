#!/usr/bin/env python3
"""
A CLI tool for interacting with language models (OpenAI and Ollama).
Supports various tasks like translation, grammar checking, and code syntax examples.
Features an interactive chat mode with history.
"""

import os
import sys
import socket
from dataclasses import dataclass, field
from typing import Optional, Literal, Dict, List
from pathlib import Path
import argparse

from openai import OpenAI
from dotenv import load_dotenv
import ollama

# Type definitions
TaskType = Literal["translate", "grammar", "syntax", "adsyntax", "explain", "summarize", "chat", "tone"]
Message = Dict[str, str]

@dataclass
class Config:
    """Configuration for the language model interaction."""
    prompt: str
    context: Optional[str] = None
    file: Optional[Path] = None
    library: str = "openai"
    output_file: Optional[Path] = None
    task: TaskType = "chat"
    output_lang: str = "en"
    debug: bool = False
    keep_alive: bool = False
    max_history: int = 20
    tone: str = "casual"
    conversation_history: List[Message] = field(default_factory=list)

class PromptTemplates:
    """Collection of prompt templates for different tasks."""

    @staticmethod
    def translate(lang: str) -> str:
        return f"Only give me the translation to {lang} of the following text: "

    @staticmethod
    def tone(tone_style: str) -> str:
        return f"Rewrite the following text in a {tone_style} tone while preserving its meaning and applying grammar fixes: "

    GRAMMAR = "Unless there's nothing to fix, only reply with the applied english grammar checks and corrections to the following text: "
    SYNTAX = "Only reply with the most simple example syntax of the following prompt: "
    AD_SYNTAX = "Only reply with the example syntax of the following prompt: "
    EXPLAIN = "Only reply with the explanation of the following subject: "
    SUMMARIZE = "Only reply with the summary of the file: "

class LLMClient:
    """Base class for language model interactions."""

    def generate_response(self, prompt: str, context: Optional[str], conversation_history: Optional[List[Message]] = None) -> str:
        raise NotImplementedError

class OllamaClient(LLMClient):
    """Client for interacting with Ollama API."""

    def generate_response(self, prompt: str, context: Optional[str], conversation_history: Optional[List[Message]] = None) -> str:
        try:
            messages = conversation_history.copy() if conversation_history else []

            if context:
                messages.append({"role": "user", "content": context})
            messages.append({"role": "user", "content": prompt})

            response = ollama.chat(model="llava", messages=messages)
            return response["message"]["content"]

        except Exception:
            sys.exit(
                "Could not connect to Ollama API. Is it running?\n"
                "> ollama run llama3.2"
            )

class OpenAIClient(LLMClient):
    """Client for interacting with OpenAI API."""

    def __init__(self):
        self.client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

    def generate_response(self, prompt: str, context: Optional[str], conversation_history: Optional[List[Message]] = None) -> str:
        messages = conversation_history.copy() if conversation_history else []

        if context:
            messages.append({"role": "user", "content": context})
        messages.append({"role": "user", "content": prompt})

        result = self.client.chat.completions.create(
            model="gpt-4",
            messages=messages
        )
        return result.choices[0].message.content

def check_internet_connection() -> None:
    """Check if there's an active internet connection."""
    try:
        socket.create_connection(("8.8.8.8", 53), timeout=5)
    except OSError:
        sys.exit("No internet connection.")

def process_output(output: str, output_file: Optional[Path], config: Config) -> None:
    """Process and display or save the output."""
    if output_file:
        output_file.write_text(output)
        print(f"Output written to file {output_file}")
    else:
        separator = '- ' * 40
        print(f"\n{separator}\n\n{output}\n\n{separator}\n")

        if config.keep_alive:
            remaining_messages = config.max_history - len(config.conversation_history) // 2
            if config.debug:
                print(f"Remaining messages in conversation: {remaining_messages}")

def get_prompt_for_task(config: Config) -> str:
    """Get the appropriate prompt template based on the task."""
    templates = PromptTemplates()

    task_prompts = {
        "translate": templates.translate(config.output_lang),
        "grammar": templates.GRAMMAR,
        "syntax": templates.SYNTAX,
        "adsyntax": templates.AD_SYNTAX,
        "explain": templates.EXPLAIN,
        "summarize": templates.SUMMARIZE if config.file else "",
        "tone": templates.tone(config.tone)
    }

    return f"{task_prompts.get(config.task, '')}{config.prompt}"

def parse_arguments() -> Config:
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description="Language Model CLI Tool")

    parser.add_argument("file_or_prompt", nargs='?', help="File path for summarize task or prompt for other tasks")
    parser.add_argument("-c", "--context", help="Additional context")
    parser.add_argument("-f", "--file", type=Path, help="Input file path")
    parser.add_argument("-l", "--lib", default="openai", help="Library to use (openai/ollama)")
    parser.add_argument("-o", "--output", type=Path, help="Output file path")
    parser.add_argument(
        "-t",
        "--task",
        choices=["translate", "grammar", "syntax", "adsyntax", "explain", "summarize", "chat", "tone"],
        default="chat",
        help="Task to perform"
    )
    parser.add_argument("-ol", "--output-lang", default="en", help="Output language")
    parser.add_argument("-d", "--debug", action="store_true", help="Debug mode")
    parser.add_argument("--keep", action="store_true", help="Enable interactive chat mode with conversation history")
    parser.add_argument("--max-history", type=int, default=100, help="Maximum number of messages in chat history")
    parser.add_argument(
        "--tone",
        help="Specify the tone for text rewriting (e.g., formal, casual, professional)",
        default="casual"
    )

    args = parser.parse_args()

    # Handle file argument based on task
    file_path = None
    prompt = args.file_or_prompt if args.file_or_prompt else ""

    if args.task == "summarize":
        # For summarize task, treat positional argument as file
        if args.file_or_prompt:
            file_path = Path(args.file_or_prompt)
        elif args.file:
            file_path = args.file
    else:
        # For other tasks, treat positional argument as prompt
        file_path = args.file

    return Config(
        prompt=prompt,
        context=args.context,
        file=file_path,
        library=args.lib,
        output_file=args.output,
        task=args.task,
        output_lang=args.output_lang,
        debug=args.debug,
        keep_alive=args.keep,
        max_history=args.max_history,
        tone=args.tone
    )

def update_conversation_history(config: Config, prompt: str, response: str) -> None:
    """Update the conversation history while maintaining the message limit."""
    if not config.keep_alive:
        return

    # Add the new message pair to the history
    config.conversation_history.append({"role": "user", "content": prompt})
    config.conversation_history.append({"role": "assistant", "content": response})

    # Trim history if it exceeds the maximum length
    while len(config.conversation_history) > config.max_history * 2:  # *2 because each exchange has 2 messages
        config.conversation_history.pop(0)  # Remove oldest message

def interactive_chat(config: Config, client: LLMClient) -> None:
    """Handle interactive chat mode."""
    print("\nInteractive chat mode enabled. Type 'exit' or 'quit' to end the session.")
    if config.debug:
        print(f"Message history limit: {config.max_history}")
    first_cycle = True

    while True:
        try:
            if first_cycle and config.prompt:
                user_input = config.prompt
                first_cycle = False
            else:
                user_input = input("\n> ")

            if user_input.lower() in ['exit', 'quit']:
                break

            if not user_input.strip():
                continue

            config.prompt = user_input
            prompt = get_prompt_for_task(config)

            # Generate and process response
            result = client.generate_response(prompt, config.context, config.conversation_history)
            update_conversation_history(config, prompt, result)
            process_output(result, config.output_file, config)

        except KeyboardInterrupt:
            print("\nChat session ended.")
            break
        except EOFError:
            print("\nChat session ended.")
            break

def main() -> None:
    """Main execution function."""
    # Load environment variables and check prerequisites
    load_dotenv()
    if not os.getenv("OPENAI_API_KEY"):
        sys.exit("OPENAI_API_KEY is not set")
    check_internet_connection()

    # Parse arguments and prepare configuration
    config = parse_arguments()

    # Get file content if specified
    if config.file:
        config.context = config.file.read_text()

    # Select appropriate client
    client = OllamaClient() if config.library in {"o", "ollama"} else OpenAIClient()

    # Log debug information
    if config.debug:
        print(f"Task: {config.task} | Context: {config.context} | Prompt: {config.prompt} | "
              f"File: {config.file} | Keep Alive: {config.keep_alive} | Tone: {config.tone}")

    if config.keep_alive:
        # Run in interactive mode
        interactive_chat(config, client)
    else:
        # Run in single-response mode
        prompt = get_prompt_for_task(config)
        result = client.generate_response(prompt, config.context)
        process_output(result, config.output_file, config)

if __name__ == "__main__":
    main()
