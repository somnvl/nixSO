{ pkgs, ... }:
{
  home.packages = [ pkgs.quickshell ];

  xdg.configFile."quickshell" = {
    source = ../../dotfiles/config/quickshell;
    recursive = true;
  };
}