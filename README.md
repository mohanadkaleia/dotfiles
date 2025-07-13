# .dotfiles 👾
For long time I wanted to sync my dotfiles with my git account. Well, here it is! In this repo, I'm 
sharing my environment's dotfiles.

## ✨ Features

### 🛠️ Development Tools
- **Python**: pyenv, pipenv, virtualenv, ipython
- **Node.js**: Latest LTS version
- **Go**: Complete Go development environment
- **Git**: Configured with colors and credential helper
- **Ruby**: Bundler and Rake gems

### 🐚 Shell Environment (Zsh + Oh My Zsh)
- **Theme**: af-magic (clean and informative)
- **Plugins**: git, virtualenv
- **Enhancements**: 
  - zsh-autosuggestions
  - zsh-completions  
  - zsh-syntax-highlighting
  - fortune + cowsay for fun terminal greetings

### 🔧 Useful Tools
- **Code Quality**: flake8, shellcheck
- **File Operations**: tree, watch, wget, curl
- **System**: jq, openssl, xz
- **Fun**: fortune, cowsay

### 📝 Vim Configuration
- **Plugin Manager**: Vundle
- **File Navigation**: NERDTree, CtrlP, TagBar
- **UI Enhancement**: Airline, Lightline, Color schemes
- **Language Support**: Python, Go, XML/HTML, ReStructuredText
- **Productivity**: Snippets, Surround, Commentary
- **Code Quality**: Syntastic, Python-mode

### 🎨 Custom Aliases & Functions
- **Navigation**: Quick directory shortcuts (`..`, `...`, `home`)
- **Python**: Virtual environment management (`venv`, `vac`)
- **Tmux**: IDE-like pane management (`xide`)
- **System**: Enhanced `ls`, process search

## 🚀 Quick Start

### Prerequisites
- macOS (currently only supported OS)
- Python 3.x
- Xcode Command Line Tools

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git
   cd dotfiles
   ```

2. **Install everything**:
   ```bash
   python main.py
   ```
   
   The script will:
   - Ask if you want to bootstrap your OS (install tools)
   - Backup your existing dotfiles
   - Link the dotfiles from this repo to your home directory

### Modifying Vim Configuration
Edit `.vimrc` to add or remove plugins. After changes, run in Vim:
```vim
:PluginInstall
```

# How it works
This will ask you to bootstrap your OS by installing a bunch of tools (you can see and customize whatever you need by modifying `install.sh` file). You can skip this step if you want. Then the script will backup your dotfiles specified by the `FILES_TO_TRACK` variable in the `main.py` file. Then will link the dot files from this project with your home directory. 

# Prerequisit
Nothing, only `Python` 🐍

1. **Permission Denied**: Make sure you have Xcode Command Line Tools installed
   ```bash
   xcode-select --install
   ```

2. **Homebrew Issues**: If Homebrew fails to install, try:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **GitHub Authentication Issues**: 
   - For HTTPS: Use Personal Access Token instead of password
   - For SSH: Ensure SSH key is added to GitHub account
   - See GitHub's authentication documentation for details

4. **Vim Plugins Not Working**: Run in Vim:
   ```vim
   :PluginInstall
   ```

# License
Well, rights are lefted here, you can freely fork and use this project. (lol I doubt anyone would do that anyway)