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
- Branch management and status checks
- Automated commit and push commands
- Diff utilities and branch cleanup

### AI Tools
- OpenAI/Claude integration
- Translation and grammar checking
- Code syntax assistance
- Task logging with JIRA integration

### Development Tools
- Node/iOS/Android utilities
- String manipulation tools
- Media conversion scripts
- VSCode configurations

## Installation

1. Clone this repository
2. Install required software
3. Run:

```
./sync.sh
```

The sync script will:
- Copy aliases from ~/scripts/aliases/
- Sync source files from ~/scripts/src/
- Back up VSCode settings and extensions
- Remove sensitive files (listed in .gitignore)
- Sanitize personal paths in configurations

## Directory Structure

```
.
├── aliases/          # Shell aliases
├── src/             # Source files
├── vs-settings/     # VSCode configurations
└── sync.sh          # Main sync script
```

## Contributing

Feel free to fork and customize. Pull requests welcome!

## License

MIT
