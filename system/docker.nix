{ profile, ... }:
{
  virtualisation.docker.enable = profile.dev.docker;
}