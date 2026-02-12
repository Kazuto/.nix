{ options, config, lib, pkgs, ... }:

with lib;
with lib.shiro;
let
  cfg = config.shiro.development.languages.rust;
in
{
  options.shiro.development.languages.rust = with types; {
    enable = mkBoolOpt false "Whether or not to use Rust";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;  [
      rustc
      cargo
      rustfmt
      clippy
      rust-analyzer
    ];
  };
}
