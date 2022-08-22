if status is-interactive
    # Commands to run in interactive sessions can go here
end
# Alias
alias baf='bat --style full'
alias l='lsd -F'
alias ll='lsd -lF'
alias la='lsd -AlF'
alias lsa='lsd -alF'

# Environment variable
set -x EDITOR (which vim)
set -x GPG_TTY (tty)
set -x PASSWORD_STORE_DIR $HOME/.local/share/pass
set -x SPACEVIMDIR $HOME/.config/SpaceVim
set -x RUSTUP_HOME $HOME/.local/share/rustup
set -x CARGO_HOME $HOME/.local/share/cargo
set -x DENO_INSTALL_ROOT $HOME/.local/share/deno
set -x COREPACK_HOME $HOME/.local/share/corepack
set -x DOTNET_CLI_TELEMETRY_OPTOUT true
set -x DOTNET_INTERACTIVE_CLI_TELEMETRY_OPTOUT true

# Path
fish_add_path -g $HOME/.local/bin
fish_add_path -g $DENO_INSTALL_ROOT/bin
fish_add_path -g $HOME/.dotnet/tools
fish_add_path -g $CARGO_HOME/bin

# Functions
function workdir
    # Move to workdir
    if set -q WORKDIR
        cd $WORKDIR
    else if test -d $HOME/Projects
        cd $HOME/Projects
    else
        echo "Error: WORKDIR or Projects not found."
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
if test -e /opt/asdf-vm/asdf.fish
    source /opt/asdf-vm/asdf.fish
else if test -e /opt/asdf/libexec/asdf.fish
    source /opt/asdf/libexec/asdf.fish
else if test -e /usr/local/opt/asdf/libexec/asdf.fish
    source /usr/local/opt/asdf/libexec/asdf.fish
end

# Starship prompt initialization
starship init fish | source
