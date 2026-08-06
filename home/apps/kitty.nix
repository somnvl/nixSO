{ ... }:
{
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ../../dotfiles/config/kitty/kitty.conf;
  };
}