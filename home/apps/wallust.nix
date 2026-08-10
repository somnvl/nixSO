{ pkgs, ... }:
{
  home.packages = [ pkgs.wallust ];

  xdg.configFile."wallust" = {
    source = ../../dotfiles/config/wallust;
    recursive = true;
  };
}