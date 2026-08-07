{ ... }:
{
  programs.vesktop.enable = true;

  xdg.configFile."vesktop/themes" = {
    source = ../../dotfiles/theming/vesktop;
    recursive = true;
  };
}