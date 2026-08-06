{ config, ... }:
{
  imports = [
    ./aliases.nix
    ./apps/kitty.nix
    ./apps/nautilus.nix
    ./apps/vscode.nix
    ./apps/zsh.nix
    ./pkgs.nix
  ];

  home.username = "so";
  home.homeDirectory = "/home/so";
  home.stateVersion = "26.05";

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    pictures = "${config.home.homeDirectory}/Pictures";
    videos = "${config.home.homeDirectory}/Videos";
  };

  programs.home-manager.enable = true;
}
