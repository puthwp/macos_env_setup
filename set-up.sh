#!/bin/bash

# Set up Tools and Environments for Mobile Developer
echo "Setting up ...."
CUR_PATH=$(pwd)
RES_PATH=$(pwd)/resources



check_cmd() {
	-x "$(which $1)"
	return $?
}

figlet_head() {
	[[ -f "/opt/brew/bin/figlet" ]] && figlet -c "${1}" || echo "${1}"
}

divider() {
	# Print Divider
	printf %"$COLUMNS"s | tr " " "="
}

install_ssh_setup() {

	[[ ! -d "${HOME}/.ssh" ]] || return
	# install ssh and generated
	divider

	figlet_head "now SSH!"
	eval "ssh-agent"
	ssh-keygen -t ed25519 -f $HOME/.ssh/id_ed25519 -N ''
	ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -N ''
	ssh-add $HOME/.ssh/id_ed25519
	ssh-add $HOME/.ssh/id_rsa
}

setup_git() {
	divider
	echo "Git config name "
	[[ ! $(git config --get user.name) ]] || return
	# set git global variables
	divider

	figlet_head "Name on Git"
	echo "What's your Name?"
	read -p "Name:" NAME 
	echo "What about Email?"
	read -p "Email:" EMAIL

	git config --global user.name "${NAME}"
	git config --global user.email "${EMAIL}"

}

backup_zsh() {

	# Set up oh my zsh and plugins
	# BK_DIR="${HOME}/.bak/$(date +%Y%m%d_%H%M%S)"

	# if [ -d "${BK_DIR}" ]; then
	# 	mkdir -p "$BK_DIR"
	# fi

	# if [[ -f "${HOME}/.oh-my-zsh" ]]; then
	# 	mv $HOME/.oh-my-zsh $BK_DIR/.oh-my-zsh

	# if [[ -f "${HOME}/.zshrc" ]]; then
	# 	mv $HOME/.zshrc $BK_DIR/.zshrc
	# fi

	# if [[ -f "${HOME}/.zprofile" ]]; then
	# 	mv $HOME/.zprofile $BK_DIR/.zprofile
	# fi

	# divider
	echo "Backup DONE"
}

install_zsh() {

	divider
	echo "install oh my zsh"

	[[ ! -d "${HOME}/.oh-my-zsh" ]] || return

	# install ohmyzsh
	curl -fsSL -o "installer.sh" "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
	sh installer.sh --unattended

	git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestion

	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

	git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM/plugins/fast-syntax-highlighting

	git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete

	ADD_LIST='zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete'

	sed -e "s/plugins=(\(.*\))/plugins=(\1 ${ADD_LIST})/g" $HOME/.zshrc >>$HOME/.zshrc

	divider

	# zsh
}

install_homebrew() {
	divider
	echo "Installing brew"

	[[ ! -f "/opt/brew/bin" ]] || return

	# install homebrew
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	echo "export PATH=/opt/homebrew/bin:$PATH" >>$HOME/.zprofile
	echo "eval "$(/opt/homebrew/bin/brew shellenv)"" >>$HOME/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"

	brew doctor

	[[ $? -eq 0 ]] || brew install git zsh figlet &
	# zsh
	divider
	figlet_head "Lets Start!"
	echo "finally I can say someting..."
	divider
	# read "Ready to go..any keys"

}

install_xcode() {
	divider
	echo "It's time for Xcode"
	# Make Xcode installation
	mas lucky xcode

	sudo xcode-select --install
	softwareupdate --install-rosetta

	mkdir -p ~/Library/Developer/Xcode/UserData/FontAndColorThemes/
	cp resources/xcode_themes/* ~/Library/Developer/Xcode/UserData/FontAndColorThemes/
	divider
}

setup_rbenv() {

	divider
	echo "Now Ruby gem"
	# install needed packages
	brew install git ruby ruby-build rbenv

	# sudo chsh -s $(which zsh) $USER

	# set up rbenv environment
	rbenv install 3.2.2
	rbenv global 3.2.2
	rbenv rehash
	local env='eval "$(${HOME}/.rbenv/bin/rbenv init - zsh)"'
	echo "${env}" >>$HOME/.zprofile
	${env}

	divider
	# zsh
}

setup_nvm() {
	divider
	echo "NVM for npm packages"

	# Install NVM
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

	NVM='export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm'

	echo "${NVM}" >>$HOME/.zprofile

	${NVM}

	nvm install 18
	nvm use 18

	divider
	# zsh
}

bundler_brew() {
	divider
	divider
	echo "It'll take sometimes with 'Brewfile' 'Gemfile'"
	divider
	divider
	# install bundler and Brewfile
	sudo gem install bundler
	bundle install

	divider

	brew bundle install --file $CUR_PATH/Brewfile

	divider
}

install_python3() {
	divider
	echo "Python3 coming right away..."
	# install python3
	curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	python3 get-pip.py

	divider
}

# install npm
setup_docker() {
	divider
	echo "Finally last The Docker"
	# install docker
	figlet_head "Docker"
	sh -fsSL get.docker.com | sh
}

paperwm() {
	divider
	echo "Let do some mod with interface"
	# Install paperwm
	# PaperWM liked tiling windows
	mkdir -p $HOME/.hammerspoon/Spoons/

	rm -rf $HOME/.hammerspoon/Spoons/PaperWM.spoon

	git clone -q https://github.com/mogenson/PaperWM.spoon ~/.hammerspoon/Spoons/PaperWM.spoon

	cp $RES_PATH/init.lua $HOME/.hammerspoon/init.lua

	open -a /Applications/Hammerspoon.app
}

done_print() {
	#Done Process

	figlet_head "Finally Complete"
	echo "What've done is done....(any keys to reboot)"
	read
	echo "rebooting..."
	sudo shutdown -r now
	read "see ya..."
	exit 0

}

full_install() {
	divider
	install_ssh_setup
	divider
	install_homebrew
	divider
	setup_git
	divider
	backup_zsh
	divider
	install_zsh
	divider
	setup_rbenv
	divider
	bundler_brew
	divider
	install_xcode
	divider
	setup_nvm
	divider
	install_python3
	divider
	paperwm
	divider
	setup_docker
	divider
	done_print
}

full_install