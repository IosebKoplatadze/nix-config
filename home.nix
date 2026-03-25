{ pkgs, lib, ... }:
let
  username = "ioseb.koplatadze";
  # nixpkgs sets CGO_ENABLED=0 for a static direnv build, but the upstream Makefile uses
  # -linkmode=external on Darwin, which requires CGO (see direnv build failure on macOS).
  direnv =
    pkgs.direnv.overrideAttrs (old: {
      env = old.env // lib.optionalAttrs pkgs.stdenv.isDarwin { CGO_ENABLED = "1"; };
    });
in
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "24.11";

  xdg.enable = true;

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    package = direnv;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      user.name = "Ioseb Koplatadze";
      user.email = "ioseb.koplatadze@coralogix.com";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      url."git@github.com:".insteadOf = "https://github.com/";
    };
    signing = {
      signByDefault = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGgw5pqYP4PQzuszT+3UGCZsPq/koHG4ceJXGTfGvo49 ioseb.koplatadze@coralogix.com";
      format = "ssh";
    };
  };

  # Sets core.pager / interactive.diffFilter; do not duplicate those in programs.git.settings.
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = true;
      line-numbers = true;
      syntax-theme = "Catppuccin-mocha";
    };
  };

  home.file.".zshrc".source = ./dotfiles/zshrc;
  home.file.".p10k.zsh".source = ./dotfiles/p10k.zsh;

  # Terminal / editor configs (~/.config/…)
  xdg.configFile."alacritty".source = ./dotfiles/alacritty;
  xdg.configFile."ghostty".source = ./dotfiles/ghostty;
  xdg.configFile."helix".source = ./dotfiles/helix;
  xdg.configFile."nvim".source = ./dotfiles/nvim;

  # tmux: main file at ~/.tmux.conf; reset keys at ~/.config/tmux/tmux.reset.conf
  home.file.".tmux.conf".source = ./dotfiles/tmux/tmux.conf;
  xdg.configFile."tmux/tmux.reset.conf".source = ./dotfiles/tmux/tmux.reset.conf;
}
