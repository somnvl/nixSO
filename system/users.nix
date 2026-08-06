{ pkgs, profile, ... }:
{
  users.users.${profile.user.username} = {
    isNormalUser = true;
    description = profile.user.username;
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;
}