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
