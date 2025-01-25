{ 
    pkgs, 
    lib, 
    namespace,
    ... 
}:
let
  inherit (lib.${namespace}) enabled;
in
{
  shiro = {
    nix = enabled;

    apps = {
      bitwarden = enabled;
      firefox = enabled;
      vlc = enabled;
    };

    cli = {
      flake = enabled;
      btop = enabled;
      curl = enabled;
      neofetch = enabled;
      neovim = enabled;
      zoxide = enabled;
      zsh = enabled;
    };

    tools = {
      git = enabled;
      ghostty = enabled;
    };
  };
}
