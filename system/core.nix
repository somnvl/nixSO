{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    wget
    pciutils
    unzip
    tree
    btop
  ];

  programs.zsh.enable = true;
  programs.git.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.fstrim.enable = true;
  services.fstrim.interval = "weekly";

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
  ];
}