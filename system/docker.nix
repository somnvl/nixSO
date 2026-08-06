{ profile, ... }:
{
  virtualisation.docker.enable = profile.features.docker;
}