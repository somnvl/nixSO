{ pkgs, lib, profile, ... }:
let
  mactahoe-icon-theme = pkgs.callPackage ./packages/mactahoe-icon-theme.nix {
    themeVariants = [ "grey" ];
  };
in
{
  home.packages = [ mactahoe-icon-theme ];

  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "MacTahoe-grey-dark";
      package = mactahoe-icon-theme;
    };
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "adw-gtk3-dark";
    icon-theme = "MacTahoe-grey-dark";
  };
}