{ profile, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = profile.gitName;
      user.email = profile.gitEmail;
      alias.fast = "!f() { git add . && git commit -m \"$@\" && git push && git push backup; }; f";
      alias.origin = "!f() { git add . && git commit -m \"$@\" && git push; }; f";
      alias.backup = "!f() { git add . && git commit -m \"$@\" && git push backup; }; f";
    };
  };
}