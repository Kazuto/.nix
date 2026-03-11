{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.system.homebrew;
  brewPrefix = "/home/linuxbrew/.linuxbrew";
in
{
  options.shiro.system.homebrew = with types; {
    enable = mkBoolOpt false "Whether or not to manage Homebrew packages (PHP 8.3 and Composer).";
  };

  config = mkIf cfg.enable {
    # System activation script to install packages via Homebrew
    system.activationScripts.homebrewPackages = {
      text = ''
        # Install PHP 8.3 and Composer if Homebrew is installed
        if [ -f "${brewPrefix}/bin/brew" ]; then
          export PATH="${brewPrefix}/bin:$PATH"

          # Install PHP 8.3 if not present
          if ! ${brewPrefix}/bin/brew list php@8.3 &>/dev/null; then
            echo "Installing PHP 8.3 via Homebrew..."
            ${brewPrefix}/bin/brew install php@8.3 || true
          fi

          # Install Composer if not present
          if ! ${brewPrefix}/bin/brew list composer &>/dev/null; then
            echo "Installing Composer via Homebrew..."
            ${brewPrefix}/bin/brew install composer || true
          fi
        else
          echo "Warning: Homebrew not found at ${brewPrefix}/bin/brew"
          echo "Please enable shiro.development.tools.brew to install Homebrew first"
        fi
      '';
    };
  };
}
