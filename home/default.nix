{ config, profile, ... }:
{
  imports = [
    ./aliases.nix
    ./cursor.nix
    ./gtk.nix
    ./pkgs.nix
    ./apps/fastfetch.nix
    ./apps/git.nix
    ./apps/hyprland.nix
    ./apps/hyprlock.nix
    ./apps/kitty.nix
    ./apps/nautilus.nix
    ./apps/quickshell.nix
    ./apps/spicetify.nix
    ./apps/vesktop.nix    
    ./apps/vscode.nix
    ./apps/zsh.nix
  ];

  home.username = profile.user.username;
  home.homeDirectory = "/home/${profile.user.username}";
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