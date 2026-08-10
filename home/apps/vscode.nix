{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      mkhl.direnv
    ] ++ [
      pkgs.vscode-marketplace.saatvik333.wallust-theme
    ];
  };
}