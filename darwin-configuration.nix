{
  self,
  inputs,
  username,
  pkgs,
  ...
}:
{
  # Apple Silicon
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = username;

  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  system.stateVersion = 6;
  system.configurationRevision = self.rev or self.dirtyRev or null;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Homebrew: mirrors `brew leaves` + casks from your current Mac (see README to extend).
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };

    taps = [
      "bufbuild/buf"
      "anomalyco/tap"
      "homebrew/cask-fonts"
    ];

    brews = [
      "node@22"
      "awscli"
      "bat"
      "btop"
      "buf"
      "cmake"
      "colima"
      "coreutils"
      "direnv"
      "docker"
      "docker-compose"
      "eza"
      "fd"
      "fzf"
      "gh"
      "git-delta"
      "go"
      "helix"
      "helm"
      "kube-ps1"
      "kubectx"
      "lazygit"
      "libiconv"
      "libxmlsec1"
      "mysql-client"
      "neovim"
      "nushell"
      "opencode"
      "pkgconf"
      "powerlevel10k"
      "procs"
      "protobuf"
      "python-yq"
      "redis"
      "rtk"
      "starship"
      "thefuck"
      "tmux"
      "trunk"
      "zoxide"
      "zsh-autosuggestions"
      "zsh-completions"
      "zsh-syntax-highlighting"
    ];

    casks = [
      "font-jetbrains-mono"
      "font-jetbrains-mono-nerd-font"
      "ghostty"
      "orbstack"
      "tsh"
      "warp"
    ];
  };
}
