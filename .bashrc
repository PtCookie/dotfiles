# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
*) ;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# Path variable
# XDG_CONFIG_HOME
export ASDF_CONFIG_FILE="$HOME/.config/asdf/asdfrc"
export ASDF_NPM_DEFAULT_PACKAGES_FILE="$HOME/.config/asdf/npm-default-packages"
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$HOME/.config/asdf/pip-default-packages"
export ASDF_GEM_DEFAULT_PACKAGES_FILE="$HOME/.config/asdf/gem-default-packages"
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"

# XDG_CACHE_HOME
export NUGET_PACKAGES="$HOME/.cache/NuGetPackage"
export GOMODCACHE="$HOME/.cache/go/mod"

# XDG_DATA_HOME
export DOTFILES="$HOME/.local/share/dotfiles"
export PASSWORD_STORE_DIR="$HOME/.local/share/pass"
export ASDF_DATA_DIR="$HOME/.local/share/asdf"
export VAGRANT_HOME="$HOME/.local/share/vagrant"
export COREPACK_HOME="$HOME/.local/share/corepack"
export BUN_INSTALL="$HOME/.local/share/bun"
export RUSTUP_HOME="$HOME/.local/share/rustup"
export CARGO_HOME="$HOME/.local/share/cargo"
export GOPATH="$HOME/.local/share/go"
export FLUTTER_ROOT="$HOME/.local/share/flutter"
export UNITY_CLI_HOME="$HOME/.local/share/unity-cli"
export FOUNDRY_DIR="$HOME/.local/share/foundry"

# Android SDK path
if [ -d "$HOME/Library/Android/sdk" ]; then
	export ANDROID_HOME="$HOME/Library/Android/sdk"
elif [ -d "$HOME/Android/Sdk" ]; then
	export ANDROID_HOME="$HOME/Android/Sdk"
fi

# Path
# Homebrew path
if [ -x /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi
export PATH="$HOME/.local/bin:$PATH"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
export PATH="$HOME/.dotnet/tools:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$CARGO_HOME/bin:$PATH"
export PATH="$FLUTTER_ROOT/bin:$PATH"
export PATH="$UNITY_CLI_HOME/bin:$PATH"
export PATH="$FOUNDRY_DIR/bin:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

# Environment variable
export LANG=ko_KR.UTF-8
export EDITOR=$(command -v vim)
export GPG_TTY=$(tty)
if command -v bat &>/dev/null; then
	export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat --language man --paging always'"
fi
if command -v ranger &>/dev/null; then
	export RANGER_LOAD_DEFAULT_RC="FALSE"
fi
if command -v dotnet &>/dev/null; then
	export DOTNET_CLI_TELEMETRY_OPTOUT="true"
	export DOTNET_INTERACTIVE_CLI_TELEMETRY_OPTOUT="true"
fi

# Starship prompt initialization
if command -v starship &>/dev/null; then
	eval "$(starship init bash)"
fi
