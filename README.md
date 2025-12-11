# PHP CLI Development Docker Image

A development Docker image based on PHP CLI, optimized for command-line PHP application development.

## PHP Extensions

- bcmath
- exif
- gd (with freetype, jpeg, and webp support)
- imagick
- intl
- mailparse
- mbstring
- mysqli
- opcache
- pcntl
- PDO (MySQL, PostgreSQL, SQLite)
- redis
- xml
- xdebug
- zip

## Development Tools

### Shell & Prompt

- **Zsh** with Znap plugin manager
  - zsh-autocomplete
  - zsh-autosuggestions
  - zsh-syntax-highlighting
- **Starship** - Cross-shell prompt

### Version Manager

- **mise** - Polyglot runtime manager (Node.js, Python, etc.)

### CLI Tools

- **eza** - Modern replacement for ls
- **bat** - Cat clone with syntax highlighting
- **ripgrep** - Fast search tool
- **fd-find** - Fast file finder
- **fzf** - Fuzzy finder
- **git-delta** - Syntax highlighting pager for git
- **lazygit** - Terminal UI for git
- **gh** - GitHub CLI
- **btop** - Resource monitor
- **tmux** - Terminal multiplexer
- **jq / yq** - JSON/YAML processors

### Database Clients

- SQLite3
- MariaDB Client
- PostgreSQL Client

## Usage

### Pull from GitHub Container Registry

```sh
docker pull ghcr.io/horatjp/php-cli:8.4
```
