{ config, pkgs, profile, ... }:
{
  home.packages = [ pkgs.quickshell ];

  home.sessionVariables = {
    QS_NO_RELOAD_POPUP = "1";
  };

  xdg.configFile."quickshell".source =
    config.lib.file.mkOutOfStoreSymlink "${profile.user.repoPath}/dotfiles/config/quickshell";
}