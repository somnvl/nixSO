# system/aliases.nix
#
# System-wide shell aliases for managing this flake (build/test/switch/
# update). Declared host-wide via environment.shellAliases rather than
# home-manager — these operate on the system itself, not a personal
# preference, so they should be available to any user/shell on this
# machine, not just one home-manager profile.
{ profile, ... }:
let
  repo = profile.user.repoPath;
in
{
  environment.shellAliases = {
    # Little confirmation cat, chained after every command below so you get
    # a clear "it's done" signal instead of just silence after a long build.
    meow = ''
      echo "
        ／l、 
      （ﾟ､ ｡ ７
      ⠀ l,‏‏‎ ‎‏‏‎ ‎‏‏‎ ‎‎~ヽ
        じしf_, )ノ
      "
    '';

    # Build only, no activation — the fast check for "does it evaluate and
    # compile" before trying test/switch.
    buildmyos  = "nixos-rebuild build --flake ${repo} && meow";

    # Build + activate immediately.
    switchmyos = "sudo nixos-rebuild switch --flake ${repo} && meow";

    # Build + activate for this boot only, reverts on reboot — useful for
    # trying risky changes without committing to them.
    testmyos   = "sudo nixos-rebuild test --flake ${repo} && meow";

    # Garbage collect + prune old generations, rebuild for next boot only
    # (not switch — avoids rebuilding while GC just ran).
    cleanmyos  = "sudo nix-collect-garbage -d && sudo nixos-rebuild boot --flake ${repo} && sudo nix store optimise && meow";

    # Update flake inputs (nixpkgs, home-manager, etc.) then switch.
    flakemyos  = "(cd ${repo} && nix flake update) && sudo nixos-rebuild switch --flake ${repo} && meow";

    # Pull your own commits only — no input updates, no rebuild.
    pullmyos   = "git -C ${repo} pull && meow";

    # Full refresh: your commits + input updates + switch, in one go.
    # Kept as one self-contained command rather than composed from
    # pullmyos/flakemyos above, for reliability.
    upmyos     = "git -C ${repo} pull && (cd ${repo} && nix flake update) && sudo nixos-rebuild switch --flake ${repo} && meow";
  };
}