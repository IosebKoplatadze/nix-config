# nix-config — reproducible Mac (Apple Silicon)

This flake installs **nix-darwin**, **Home Manager**, and **Homebrew** packages/casks to match your previous machine. Configuration name: **`ioseb-mac`**.

## Before you start

1. **Install Xcode Command Line Tools:** `xcode-select --install`
2. **Install Nix** (flakes enabled), for example Determinate:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```
   Open a **new** terminal afterward.

3. **Oh My Zsh** (not installed by this flake): one-time on each Mac:
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
   ```
   If the installer warns that `~/.zshrc` exists, back it up, then re-run `darwin-rebuild` / Home Manager so the managed `.zshrc` from this repo is restored.

4. **Work credentials:** Put `JFROG_USER`, `JFROG_PASSWORD`, and anything else sensitive in `~/.zshrc.local` (ignored by git). See `dotfiles/zshrc.local.example`. That file is sourced at the end of `dotfiles/zshrc` (your previous `~/.zshrc` had those exports; they were **not** copied into git for safety).

5. **Private repo:** Push this directory to a **private** Git host so signing keys and layout are not public.

## Dotfiles managed here

Home Manager installs these from `dotfiles/`:

| Tool | Paths |
|------|--------|
| **p10k** | `~/.p10k.zsh` |
| **Alacritty** | `~/.config/alacritty/` |
| **Ghostty** | `~/.config/ghostty/` |
| **Helix** | `~/.config/helix/` |
| **Neovim** | `~/.config/nvim/` (LazyVim-style `init.lua` + `lua/`; plugins download on first run) |
| **tmux** | `~/.tmux.conf` + `~/.config/tmux/tmux.reset.conf` |

**Neovim:** After first launch, run `:Lazy sync` so Lazy.nvim installs plugins from `lazy-lock.json`.

**tmux:** [TPM](https://github.com/tmux-plugins/tpm) is not bundled. Install once per machine, then open tmux and press `prefix` + `I` to fetch plugins:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## First-time apply (this Mac or the new Mac)

```bash
cd ~/nix-config
nix flake lock
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/nix-config#ioseb-mac
```

After nix-darwin is installed once:

```bash
darwin-rebuild switch --flake ~/nix-config#ioseb-mac
```

Use `sudo` if your setup requires it for system activation.

## New Mac checklist

- Same macOS username `ioseb.koplatadze` (or edit `flake.nix`, `darwin-configuration.nix`, and `home.nix`).
- Clone this repo to `~/nix-config`, then run the commands above.
- Sign in to App Store / OrbStack / Teleport (`tsh`) / other licensed apps as needed.
- Copy SSH **private** keys securely (not via git); keep `~/.ssh/coralogix-github` out of the repo.
- Optional: use **Migration Assistant** for `~/Library` app data (browsers, Slack, etc.) in addition to this flake.

## Changing the flake name / hostname

The attribute is `darwinConfigurations."ioseb-mac"`. The new Mac does not need to match `scutil` hostname; always pass `#ioseb-mac` to `--flake`.

## Updating dependencies

```bash
cd ~/nix-config
nix flake update
darwin-rebuild switch --flake .#ioseb-mac
```

## Adding packages

- **Homebrew:** edit `brews` / `casks` / `taps` in `darwin-configuration.nix`.
- **Nix-only user tools:** add `home.packages = with pkgs; [ ... ];` in `home.nix`.

## Note on cleanup

`homebrew.onActivation.cleanup` is set to `"none"` so a first run does not remove formulas you have not listed yet. After you trust the list, you can set it to `"uninstall"` in `darwin-configuration.nix` to enforce the declarative set.
