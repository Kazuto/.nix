{ 
  config, 
  lib, 
  pkgs, 
  namespace, 
  ... 
}:
lib.${namespace}.mkModule {
  inherit config;

  path = [
    "desktop"
    "addons"
    "gtk"
  ];

  output = {
    shiro.home.extraOptions = {
      gtk = {
        enable = true;

        theme = {
          name = "Catppuccin-Mocha-Standard-Blue-Dark";
          package = pkgs.catppuccin-gtk.override {
            variant = "mocha";
          };
        };

        cursorTheme = {
          name = "Catppuccin-Mocha-Dark-Cursors";
          package = pkgs.catppuccin-cursors.mochaDark;
        };

        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };

        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };

        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };
    };

    programs.dconf = enabled;

    environment.systemPackages = with pkgs; [
      gtk_engines
      gtk-engine-murrine
      glib
      gsettings-desktop-schemas
      gnome.gnome-themes-extra
      sassc
      themechanger
      catppuccin-gtk
      gnome.dconf-editor
    ];

    environment.sessionVariables = {
      GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
      GTK_USE_PORTAL = "1";
    };
  };
}



