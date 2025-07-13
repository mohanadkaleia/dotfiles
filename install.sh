#!/usr/bin/env bash
# Acknowledgment: this file has been forked from here: https://gist.github.com/mrichman/f5c0c6f0c0873392c719265dfd209e12
#
# Bootstrap script for setting up a new OSX machine
# 
# This should be idempotent so it can be run multiple times.

# helpers
function echo_ok() { echo -e '\033[1;32m'"$1"'\033[0m'; }
function echo_warn() { echo -e '\033[1;33m'"$1"'\033[0m'; }
function echo_error() { echo -e '\033[1;31mERROR: '"$1"'\033[0m'; }

echo_ok "Install starting. You may be asked for your password (for sudo)."

# requires xcode and tools!
xcode-select -p || exit "XCode must be installed! (use the app store)"

# homebrew
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
if hash brew &>/dev/null; then
	echo_ok "Homebrew already installed. Getting updates..."
	brew update
	brew doctor
else
	echo_warn "Installing homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
# brew install findutils

PACKAGES=(					
	curl
	flake8	
	git			
	jq			
	node
	openssl	
	pipenv
	python3
	pyenv
	pyenv-virtualenv
	shellcheck			
	tree
	watch
	wget
	xz
	zsh
	zsh-autosuggestions
	zsh-completions
	zsh-syntax-highlighting
    fortune
    cowsay
)

echo_ok "Installing packages..."
brew install "${PACKAGES[@]}"

echo_ok "Cleaning up..."
brew cleanup

echo_ok "Installing Python packages..."
PYTHON_PACKAGES=(
	ipython
	virtualenv
	virtualenvwrapper
)
sudo pip install "${PYTHON_PACKAGES[@]}"

echo "Installing Ruby gems"
RUBY_GEMS=(
	bundler
	rake
)
sudo gem install "${RUBY_GEMS[@]}"

echo_ok "Installing oh my zsh..."

if [[ ! -f ~/.zshrc ]]; then
	echo ''
	echo '##### Installing oh-my-zsh...'
	curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

	cp ~/.zshrc ~/.zshrc.orig
	cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
	chsh -s /bin/zsh
fi

echo_ok "Configuring Git and GitHub"

# Check if git is already configured
if [[ -z "$(git config --global user.name)" ]] || [[ -z "$(git config --global user.email)" ]]; then
	echo ''
	echo '##### Git Configuration #####'
	echo '##### Please enter your github username: '
	read github_user
	echo '##### Please enter your github email address: '
	read github_email

	# setup git config
	if [[ $github_user && $github_email ]]; then
		git config --global user.name "$github_user"
		git config --global user.email "$github_email"
		git config --global color.ui true
		git config --global push.default current
		git config --global init.defaultBranch main
		
		echo_ok "Git configured successfully!"
	fi
fi

# Setup credential helper for macOS
if [[ ! -f "$(dirname $(which git))/git-credential-osxkeychain" ]]; then
	echo_ok "Setting up Git credential helper..."
	curl -s -O https://github-media-downloads.s3.amazonaws.com/osx/git-credential-osxkeychain
	chmod u+x git-credential-osxkeychain
	sudo mv git-credential-osxkeychain "$(dirname $(which git))/git-credential-osxkeychain"
	git config --global credential.helper osxkeychain
	echo_ok "Credential helper installed!"
fi

# Offer SSH key setup as an option
echo ''
echo '##### GitHub Authentication Setup #####'
echo 'Choose your preferred authentication method:'
echo '1. Personal Access Token (Recommended for HTTPS)'
echo '2. SSH Key (Recommended for SSH)'
echo '3. Skip for now'
read -p 'Enter your choice (1-3): ' auth_choice

case $auth_choice in
	1)
		echo ''
		echo '##### Personal Access Token Setup #####'
		echo 'To use Personal Access Token:'
		echo '1. Go to GitHub.com → Settings → Developer settings → Personal access tokens'
		echo '2. Generate a new token with "repo" permissions'
		echo '3. When Git prompts for password, use the token instead'
		echo ''
		echo 'The token will be stored securely in macOS Keychain'
		echo_ok "Personal Access Token setup instructions displayed!"
		;;
	2)
		if [[ ! -f ~/.ssh/id_rsa ]]; then
			echo ''
			echo '##### SSH Key Setup #####'
			echo 'Generating SSH key...'
			cd ~/.ssh || exit
			ssh-keygen -t ed25519 -C "$(git config --global user.email)" -f ~/.ssh/id_rsa
			pbcopy <~/.ssh/id_rsa.pub
			echo ''
			echo '##### SSH public key copied to clipboard! #####'
			echo 'Add it to GitHub:'
			echo '1. Go to GitHub.com → Settings → SSH and GPG keys'
			echo '2. Click "New SSH key"'
			echo '3. Paste the key and save'
			echo ''
			echo 'Testing SSH connection...'
			ssh -T git@github.com
		else
			echo_ok "SSH key already exists!"
		fi
		;;
	3)
		echo_warn "Skipping authentication setup. You can configure it later."
		;;
	*)
		echo_warn "Invalid choice. Skipping authentication setup."
		;;
esac

echo_ok "Bootstrapping complete"