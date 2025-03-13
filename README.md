# .dotfiles (MacOS) Development Toolkit

A collection of productivity tools and aliases for macOS development workflow.

## Required Software

- [Homebrew](https://brew.sh/)
- [ZSH](https://www.zsh.org/) + [Oh My Zsh](https://ohmyz.sh/) (optional)
- [jq](https://formulae.brew.sh/formula/jq)
- [ffmpeg](https://formulae.brew.sh/formula/ffmpeg#default)
- [Google Chrome](https://www.google.com/chrome/)
- [Git](https://git-scm.com/download/mac)
- [Node.js](https://nodejs.org/en/download/)
- [NVM](https://github.com/nvm-sh/nvm)
- [Yarn](https://classic.yarnpkg.com/lang/en/docs/install/)

## Features

### Git Workflow
- Comprehensive git aliases and utilities
- Branch management and status checks
- Automated commit and push commands
- Diff utilities and branch cleanup
- Custom git configurations

### Development Tools
- Multi-language support (TypeScript, JavaScript, Python, Go)
- React Native development utilities
- Android development tools
- Docker management commands
- Backend development helpers
- String manipulation tools
- Python linting and utilities
- VSCode configurations

### AI and Productivity
- OpenAI/Claude integration
- AI-assisted development tools
- Project-specific shortcuts
- Folder navigation helpers
- Apple-specific utilities

## Installation

1. Clone this repository
2. Install required software
3. Copy files to your home.


## Directory Structure

```
.
├── aliases/                  # Shell aliases
│   ├── aliases-android.sh    # Android development aliases
│   ├── aliases-docker.sh     # Docker management
│   ├── aliases-git.sh        # Git workflow
│   ├── aliases-ai.sh        # AI tools integration
│   ├── aliases-python.sh    # Python development
│   ├── aliases-utils.sh     # General utilities
│   └── ... (other aliases)
├── src/                     # Source files
│   ├── typescript/         # TypeScript utilities
│   ├── js/                # JavaScript utilities
│   ├── python/            # Python scripts
│   ├── sh/                # Shell scripts
│   └── go/                # Go utilities
├── vs-settings/            # VSCode configurations
├── android-release-suite/  # Android release tools
└── sync.sh                # Main sync script
```
