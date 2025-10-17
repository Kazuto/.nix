# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

[ -d "/opt/homebrew/bin" ] && export PATH=/opt/homebrew/bin:$PATH
[ -d "/opt/homebrew/sbin" ] && export PATH=/opt/homebrew/sbin:$PATH
[ -d "$HOME/.composer/vendor/bin" ] && export PATH=$HOME/.composer/vendor/bin:$PATH
[ -d "$HOME/.local/bin" ] && export PATH=$HOME/.local/bin:$PATH
[ -d "$HOME/.cargo/bin" ] && export PATH=$HOME/.cargo/bin:$PATH

# Herd injected PHP binary.
export PATH="/Users/kazuto/Library/Application Support/Herd/bin/":$PATH

# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/kazuto/Library/Application Support/Herd/config/php/84/"

# Herd injected PHP 8.2 configuration.
export HERD_PHP_82_INI_SCAN_DIR="/Users/kazuto/Library/Application Support/Herd/config/php/82/"

# Nix
export PATH="$PATH:/nix/var/nix/profiles/default/bin"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro--locate-shell-integration-path zsh)"

if [[ "$TERM_PROGRAM" == "kiro" ]]; then
  # Leave empty or set a light theme
else
  # Your theme
  ZSH_THEME="powerlevel10k/powerlevel10k"
fi

plugins=(
  composer
  git
  npm
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration
[ -f "$ZDOTDIR/.aliases" ] && source "$ZDOTDIR/.aliases"
[ -f "$ZDOTDIR/.functions" ] && source "$ZDOTDIR/.functions"
[ -f "$ZDOTDIR/.after" ] && source "$ZDOTDIR/.after"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Init zoxide
eval "$(zoxide init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# place this after nvm initialization!
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

export PATH=$PATH:/Users/kazuto/.spicetify
