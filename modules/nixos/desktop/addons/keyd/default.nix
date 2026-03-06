{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.desktop.addons.keyd;
in
{
  options.shiro.desktop.addons.keyd = with types; {
    enable = mkBoolOpt false "Whether or not to enable keyd for key remapping.";
  };

  config = mkIf cfg.enable {
    # Enable keyd service
    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings = {
          main = {
            # Make CapsLock act as a layer modifier (hyper)
            capslock = "overload(hyper, esc)";
          };

          # Hyper layer - CapsLock + keys
          "hyper:C-S-A" = {
            # Workspace switching with CapsLock + numbers
            "1" = "C-S-A-1";
            "2" = "C-S-A-2";
            "3" = "C-S-A-3";
            "4" = "C-S-A-4";
            "5" = "C-S-A-5";
            "6" = "C-S-A-6";
            "7" = "C-S-A-7";
            "8" = "C-S-A-8";
            "9" = "C-S-A-9";
            "0" = "C-S-A-0";

            # Vim navigation (bonus)
            "h" = "left";
            "j" = "down";
            "k" = "up";
            "l" = "right";
          };
        };
      };
    };
  };
}
