{ pkgs, lib, profile, ... }:
{
  users.users.${profile.user.username} = {
    isNormalUser = true;
    description = profile.user.username;
    extraGroups = [ "networkmanager" "wheel" "dialout" ]
      ++ lib.optional profile.dev.docker "docker";
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;
}