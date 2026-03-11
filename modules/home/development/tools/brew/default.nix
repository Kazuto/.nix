{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.tools.brew;

  # Determine Homebrew prefix based on platform
  brewPrefix = if pkgs.stdenv.isDarwin then
    (if pkgs.stdenv.isAarch64 then "/opt/homebrew" else "/usr/local")
  else
    "/home/linuxbrew/.linuxbrew";

  # Script to install Homebrew if not present
  installBrewScript = ''
    if [ ! -f "${brewPrefix}/bin/brew" ]; then
      echo "Installing Homebrew..."
      NONINTERACTIVE=1 /bin/bash -c "$(${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  '';

in
{
  options.shiro.development.tools.brew = with types; {
    enable = mkBoolOpt false "Whether or not to install Homebrew.";
  };

  config = mkIf cfg.enable {
    # Add Homebrew paths to shell environment
    home.sessionPath = [
      "${brewPrefix}/bin"
      "${brewPrefix}/sbin"
    ];

    # Add Homebrew environment variables
    home.sessionVariables = {
      HOMEBREW_PREFIX = brewPrefix;
      HOMEBREW_CELLAR = "${brewPrefix}/Cellar";
      HOMEBREW_REPOSITORY = brewPrefix;
    };

    # Run installation scripts on activation
    home.activation = {
      installHomebrew = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD ${pkgs.writeShellScript "install-homebrew" installBrewScript}
      '';
    };
  };
}
