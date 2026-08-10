{ pkgs, ... }:
{
  home.packages = with pkgs; [
    google-chrome

    hyprshot
    grim
    slurp
  ];
}