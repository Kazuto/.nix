{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.cli.lazygit;
in
{
  options.shiro.cli.lazygit = with types; {
    enable = mkBoolOpt false "Whether or not to install lazygit.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ lazygit ];

    xdg.configFile."lazygit/config.yml".text = ''
      os:
        editCommand: "nvim"
        editCommandTemplate: '{{editor}} --server /tmp/nvim-server.pipe --remote-tab "$(pwd)/{{filename}}"'
      keybinding:
        universal:
          togglePanel: '}'
          nextBlock-alt2: ""
          prevBlock-alt2: ""
          nextTab: '<tab>'
          prevTab: '<backtab>'
    '';
  };
}
