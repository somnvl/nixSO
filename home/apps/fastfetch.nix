{ ... }:
{
  programs.fastfetch.enable = true;
  xdg.configFile."fastfetch" = {
    force = true;
    source = ../../dotfiles/config/fastfetch;
    recursive = true;
  };
}