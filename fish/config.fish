# Path variable
# XDG_CONFIG_HOME
set -x ASDF_CONFIG_FILE $HOME/.config/asdf/asdfrc
set -x ASDF_NPM_DEFAULT_PACKAGES_FILE $HOME/.config/asdf/npm-default-packages
set -x ASDF_PYTHON_DEFAULT_PACKAGES_FILE $HOME/.config/asdf/pip-default-packages
set -x ASDF_GEM_DEFAULT_PACKAGES_FILE $HOME/.config/asdf/gem-default-packages
set -x NPM_CONFIG_USERCONFIG $HOME/.config/npm/npmrc

# XDG_CACHE_HOME
set -x NUGET_PACKAGES $HOME/.cache/NuGetPackage
set -x GOMODCACHE $HOME/.cache/go/mod

# XDG_DATA_HOME
set -x DOTFILES $HOME/.local/share/dotfiles
set -x PASSWORD_STORE_DIR $HOME/.local/share/pass
set -x ASDF_DATA_DIR $HOME/.local/share/asdf
set -x VAGRANT_HOME $HOME/.local/share/vagrant
set -x COREPACK_HOME $HOME/.local/share/corepack
set -x BUN_INSTALL $HOME/.local/share/bun
set -x DENO_INSTALL $HOME/.local/share/deno
set -x RUSTUP_HOME $HOME/.local/share/rustup
set -x CARGO_HOME $HOME/.local/share/cargo
set -x GOPATH $HOME/.local/share/go
set -x FLUTTER_ROOT $HOME/.local/share/flutter

# Android SDK path
if test -d $HOME/Library/Android/sdk
	set -x ANDROID_HOME $HOME/Library/Android/sdk
else if test -d $HOME/Android/Sdk
	set -x ANDROID_HOME $HOME/Android/Sdk
end

# Path
fish_add_path -g /opt/homebrew/bin
fish_add_path -g $HOME/.local/bin
fish_add_path -g $ASDF_DATA_DIR/shims
fish_add_path -g $HOME/.dotnet/tools
fish_add_path -g $FLUTTER_ROOT/bin
fish_add_path -g $CARGO_HOME/bin
fish_add_path -g $DENO_INSTALL/bin
fish_add_path -g $BUN_INSTALL/bin
fish_add_path -g $ANDROID_HOME/emulator
fish_add_path -g $ANDROID_HOME/platform-tools

# Environment variable
set -x LANG ko_KR.UTF-8
set -x EDITOR (which vim)
set -x GPG_TTY (tty)
if type -q bat
	set -x MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat --language man --paging always'"
end
if type -q ranger
	set -x RANGER_LOAD_DEFAULT_RC FALSE
end
# .NET telemetry opt out
if type -q dotnet
	set -x DOTNET_CLI_TELEMETRY_OPTOUT true
	set -x DOTNET_INTERACTIVE_CLI_TELEMETRY_OPTOUT true
end

if status is-interactive
	# Functions
	function workdir
		# Move to workdir
		if set -q WORKDIR
			cd $WORKDIR
		else if test -d $HOME/Workspaces
			cd $HOME/Workspaces
		else
			echo "Error: WORKDIR or Workspaces not found."
		end
	end

	function gpg-change-key
		# Update start card status
		if type -q gpg-connect-agent
			gpg-connect-agent "scd serialno" "learn --force" /bye
		else
			echo "Error: gpg-connect-agent not found."
		end
	end

	function user-path
		# Show PATH with fish_user_paths highlighted
		set -x GREP_COLORS 'mt=1;34'
		echo $PATH | grep (echo $fish_user_paths)
	end

	# Alias
	if type -q bat
		alias bap='bat --paging auto'
		alias baf='bat --style full'
	end

	if type -q lsd
		alias l='lsd -F'
		alias ll='lsd -lF'
		alias la='lsd -AlF'
		alias lsa='lsd -alF'
	end

	# Launch GnuPG agent
	if type -q gpgconf
		gpgconf --launch gpg-agent
	end

	# Auto completion for kubectl
	if type -q kubectl
		kubectl completion fish | source
	end

	# Starship prompt initialization
	if type -q starship
		starship init fish | source
	end
end
