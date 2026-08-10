{ pkgs, ... }:
{
  home.packages = [ pkgs.quickshell ];

  home.sessionVariables = {
    QS_NO_RELOAD_POPUP = "1";
  };

  xdg.configFile."quickshell" = {
    source = ../../dotfiles/config/quickshell;
    recursive = true;
  };
}