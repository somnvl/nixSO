{ pkgs, ... }:
{
  users.users.so = {
    isNormalUser = true;
    description = "so";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;
}