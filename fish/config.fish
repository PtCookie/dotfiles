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

# Functions
function proj
    if set -q WORKDIR
        cd $WORKDIR
    else if test -d $HOME/Projects
        cd $HOME/Projects
    else
        echo "No Projects found"
    end
end

function gpg-change-key
    gpg-connect-agent "scd serialno" "learn --force" /bye
end

# Launch GnuPG agent
gpgconf --launch gpg-agent

# Starship prompt initialization
starship init fish | source

# Set up asdf
source /opt/asdf-vm/asdf.fish
