from pathlib import Path
import subprocess
import sys

ALIASES_PATH = Path.home() / "scripts" / "aliases"

try:
    aliases = [file.name for file in ALIASES_PATH.glob('*.sh')]
    if not aliases:
        print(f"No .sh files found in {ALIASES_PATH}")
        sys.exit(1)
    ALIASES_MAP = dict(enumerate(aliases, 1))
except Exception as e:
    print(f"Error accessing {ALIASES_PATH}: {e}")
    sys.exit(1)

def exit_program():
    print("\nGoodbye!")
    sys.exit(0)

def check_exit(user_input: str):
    if user_input.lower() in ['q', 'exit']:
        exit_program()

def get_path(file: str) -> Path:
    return ALIASES_PATH / file

def prompt_alias():
    print(f"Listing files in {ALIASES_PATH}")
    max_index_width = len(str(len(ALIASES_MAP)))
    formatted_aliases = [
        f"{str(index).rjust(max_index_width)} - {alias}"
        for index, alias in ALIASES_MAP.items()
    ]

    input_string = f"""
Available aliases:

{'\n'.join(formatted_aliases)}

File (1-{len(ALIASES_MAP)}) or 'q': """

    while True:
        choice = input(input_string)
        check_exit(choice)

        try:
            choice_num = int(choice)
            if 1 <= choice_num <= len(ALIASES_MAP):
                file_path = get_path(ALIASES_MAP[choice_num])
                try:
                    print("\nDon't forget to reload your aliases! Run 'source ~/.zshrc' or restart your terminal.")
                    subprocess.run(["vim", "+normal GA", str(file_path)])
                    exit_program()
                except subprocess.SubprocessError as e:
                    print(f"Error opening editor: {e}")
                    sys.exit(1)
            print("\nPlease enter a valid number from the list.")
        except ValueError:
            print("\nPlease enter a valid number or 'q' to exit.")

if __name__ == "__main__":
    try:
        prompt_alias()
    except KeyboardInterrupt:
        exit_program()
