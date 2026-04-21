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

  # Determinate Nix manages the daemon and /etc/nix; nix-darwin must not manage Nix too.
  nix.enable = false;
  # Flakes / nix-command: configure via Determinate or ~/.config/nix/nix.conf (not nix.settings here).

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
    ];

    brews = [
      "nvm"
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

    # GUI apps (Homebrew casks). Docker Desktop and OrbStack both provide Docker;
    # pick one for daily use to avoid fighting over the same daemon/socket.
    casks = [
      "alacritty"
      "arc"
      "cursor"
      "docker-desktop"
      "font-jetbrains-mono"
      "font-jetbrains-mono-nerd-font"
      "ghostty"
      "google-chrome"
      "notion"
      "obsidian"
      "orbstack"
      "raycast"
      "slack"
      "tsh"
      "visual-studio-code"
      "warp"
      "zed"
    ];
  };
}
