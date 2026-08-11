{ pkgs, ... }:
{
  programs.vesktop.enable = true;

  home.packages = with pkgs; [
    google-chrome

    hyprshot
    grim
    slurp
    jq
  ];
}