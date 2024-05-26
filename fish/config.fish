if status is-interactive
    # Commands to run in interactive sessions can go here
end
# Alias
if type -q bat
    alias bap='bat --paging auto'
    alias baf='bat --style full'
end

if type -q lsd
    alias ls='lsd -lF'
    alias la='lsd -AlF'
    alias lsa='lsd -alF'
end

# Environment variable
set -x LANG ko_KR.UTF-8
set -x EDITOR (which vim)
set -x GPG_TTY (tty)
set -x DOTNET_CLI_TELEMETRY_OPTOUT true
set -x DOTNET_INTERACTIVE_CLI_TELEMETRY_OPTOUT true

# XDG_CONFIG_HOME
set -x ASDF_CONFIG_FILE $HOME/.config/asdf/asdfrc
set -x ASDF_NPM_DEFAULT_PACKAGES_FILE $HOME/.config/asdf/npm-default-packages
set -x ASDF_PYTHON_DEFAULT_PACKAGES_FILE $HOME/.config/asdf/pip-default-packages
set -x ASDF_GEM_DEFAULT_PACKAGES_FILE $HOME/.config/asdf/gem-default-packages
set -x NPM_CONFIG_USERCONFIG $HOME/.config/npm/npmrc

# XDG_CACHE_HOME
set -x NUGET_PACKAGES $HOME/.cache/NuGetPackage

# XDG_DATA_HOME
set -x DOTFILES $HOME/.local/share/dotfiles
set -x PASSWORD_STORE_DIR $HOME/.local/share/pass
set -x VAGRANT_HOME $HOME/.local/share/vagrant
set -x RUSTUP_HOME $HOME/.local/share/rustup
set -x CARGO_HOME $HOME/.local/share/cargo
set -x DENO_INSTALL $HOME/.local/share/deno
set -x BUN_INSTALL $HOME/.local/share/bun
set -x ASDF_DATA_DIR $HOME/.local/share/asdf
set -x COREPACK_HOME $HOME/.local/share/corepack

# Path
fish_add_path -g $HOME/.local/bin
fish_add_path -g $HOME/.dotnet/tools
fish_add_path -g $CARGO_HOME/bin
fish_add_path -g $DENO_INSTALL/bin
fish_add_path -g $BUN_INSTALL/bin

# Android SDK path
if test -d $HOME/Library/Android/sdk
    set -x ANDROID_HOME $HOME/Library/Android/sdk
    fish_add_path -g $ANDROID_HOME/emulator
    fish_add_path -g $ANDROID_HOME/platform-tools
end

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

function tcp-ports
    # Show TCP listening ports
    if type -q ss
        ss -naltp
    else
        netstat -nap tcp | rg --color never -e "Active" -e "Address" -e "LISTEN"
    end
end

# Launch GnuPG agent
if type -q gpgconf
    gpgconf --launch gpg-agent
end

# Set up asdf
if test -e $ASDF_DATA_DIR/asdf.fish
    source $ASDF_DATA_DIR/asdf.fish
else if test -e /opt/asdf-vm/asdf.fish
    source /opt/asdf-vm/asdf.fish
else if type -q brew && test -e (brew --prefix asdf)/libexec/asdf.fish
    source (brew --prefix asdf)/libexec/asdf.fish
end

# Auto completion for kubectl
if type -q kubectl
    kubectl completion fish | source
end

# Starship prompt initialization
if type -q starship
    starship init fish | source
end
