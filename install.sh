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

echo_ok "Configuring Github"

if [[ ! -f ~/.ssh/id_rsa ]]; then
	echo ''
	echo '##### Please enter your github username: '
	read github_user
	echo '##### Please enter your github email address: '
	read github_email

	# setup github
	if [[ $github_user && $github_email ]]; then
		# setup config
		git config --global user.name "$github_user"
		git config --global user.email "$github_email"
		git config --global github.user "$github_user"
		# git config --global github.token your_token_here
		git config --global color.ui true
		git config --global push.default current		

		# set rsa key
		curl -s -O http://github-media-downloads.s3.amazonaws.com/osx/git-credential-osxkeychain
		chmod u+x git-credential-osxkeychain
		sudo mv git-credential-osxkeychain "$(dirname $(which git))/git-credential-osxkeychain"
		git config --global credential.helper osxkeychain

		# generate ssh key
		cd ~/.ssh || exit
		ssh-keygen -t rsa -C "$github_email"
		pbcopy <~/.ssh/id_rsa.pub
		echo ''
		echo '##### The following rsa key has been copied to your clipboard: '
		cat ~/.ssh/id_rsa.pub
		echo '##### Follow step 4 to complete: https://help.github.com/articles/generating-ssh-keys'
		ssh -T git@github.com
	fi
fi

echo_ok "Bootstrapping complete"