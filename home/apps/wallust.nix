{ config, pkgs, profile, ... }:
{
  home.packages = [ pkgs.wallust ];

  xdg.configFile."wallust".source =
    config.lib.file.mkOutOfStoreSymlink "${profile.user.repoPath}/dotfiles/config/wallust";
}