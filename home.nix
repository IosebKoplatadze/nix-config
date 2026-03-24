{ pkgs, ... }:
let
  username = "ioseb.koplatadze";
in
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Ioseb Koplatadze";
    userEmail = "ioseb.koplatadze@coralogix.com";
    signing = {
      signByDefault = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGgw5pqYP4PQzuszT+3UGCZsPq/koHG4ceJXGTfGvo49 ioseb.koplatadze@coralogix.com";
      format = "ssh";
    };
    extraConfig = {
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      url."git@github.com:".insteadOf = "https://github.com/";
    };
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "Catppuccin-mocha";
      };
    };
  };

  home.file.".zshrc".source = ./dotfiles/zshrc;
  home.file.".p10k.zsh".source = ./dotfiles/p10k.zsh;
}
