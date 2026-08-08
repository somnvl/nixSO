{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    envExtra = ''
      export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    initContent = ''
      export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/''$UID}"
      export TMPDIR="''${XDG_RUNTIME_DIR}"
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      logout() {
        if [[ -n "$NIRI_SOCKET" ]]; then
          niri msg action quit --skip-confirmation
        else
          uwsm stop
        fi
      }
    '';
  };

  home.file.".p10k.zsh".source = ../../dotfiles/config/p10k/.p10k.zsh;
}