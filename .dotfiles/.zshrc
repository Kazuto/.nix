# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

XDG_CONFIG_HOME=$HOME/.config

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

[ -d "/opt/homebrew/bin" ] && export PATH=/opt/homebrew/bin:$PATH
[ -d "/opt/homebrew/sbin" ] && export PATH=/opt/homebrew/sbin:$PATH
[ -d "$HOME/.composer/vendor/bin" ] && export PATH=$HOME/.composer/vendor/bin:$PATH
[ -d "$HOME/.local/bin" ] && export PATH=$HOME/.local/bin:$PATH
[ -d "$HOME/.cargo/bin" ] && export PATH=$HOME/.cargo/bin:$PATH

export PATH="$PATH:/nix/var/nix/profiles/default/bin"
export PATH="/opt/homebrew/opt/php@8.1/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.1/sbin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  composer
  git
  npm
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

[ -f "$HOME/.config/zsh/.aliases" ] && source $HOME/.config/zsh/.aliases
[ -f "$HOME/.config/zsh/.functions" ] && source $HOME/.config/zsh/.functions
[ -f "$HOME/.config/zsh/.after" ] && source $HOME/.config/zsh/.after

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(zoxide init zsh)"

export PATH=$PATH:/Users/kazuto/.spicetify

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/kazuto/Library/Application Support/Herd/config/php/84/"


# Herd injected PHP binary.
export PATH="/Users/kazuto/Library/Application Support/Herd/bin/":$PATH


# Herd injected PHP 8.2 configuration.
export HERD_PHP_82_INI_SCAN_DIR="/Users/kazuto/Library/Application Support/Herd/config/php/82/"
