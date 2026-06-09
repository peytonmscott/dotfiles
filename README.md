# dotfiles

My personal macOS dotfiles. Managed as a bare Git repo and symlinked by [macbook-setup](https://github.com/peytonmscott/macbook-setup).

## What's Inside

| Path | Symlinks To | Tool |
|------|------------|------|
| `zsh/zshrc` | `~/.zshrc` | Zsh shell config |
| `git/gitignore_global` | `~/.gitignore_global` | Global Git ignore patterns |
| `ghostty/config` | `~/.config/ghostty` | Ghostty terminal |
| `aerospace/aerospace.toml` | `~/.config/aerospace/aerospace.toml` | AeroSpace tiling WM |
| `nvim/init.lua` | `~/.config/nvim` | Neovim config |
| `starship/starship.toml` | `~/.config/starship.toml` | Starship prompt |
| `yazi/yazi.toml` | `~/.config/yazi` | Yazi file manager |

## Install

### Via macbook-setup (recommended)

```bash
git clone https://github.com/peytonmscott/macbook-setup.git ~/Developer/macbook-setup
cd ~/Developer/macbook-setup
./bootstrap.sh --role personal \
  --git-name "Peyton" \
  --git-email "peyton.scott078@gmail.com" \
  --dotfiles-repo "https://github.com/peytonmscott/dotfiles.git"
```

### Manual

```bash
git clone https://github.com/peytonmscott/dotfiles.git ~/Developer/dotfiles
ln -sf ~/Developer/dotfiles/zsh/zshrc ~/.zshrc
ln -sf ~/Developer/dotfiles/git/gitignore_global ~/.gitignore_global
ln -sf ~/Developer/dotfiles/ghostty ~/.config/ghostty
ln -sf ~/Developer/dotfiles/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml
ln -sf ~/Developer/dotfiles/nvim ~/.config/nvim
ln -sf ~/Developer/dotfiles/starship/starship.toml ~/.config/starship.toml
ln -sf ~/Developer/dotfiles/yazi ~/.config/yazi
```

## Tool Notes

### Neovim

- Uses `vim.pack.add()` (Neovim 0.12+) — no plugin manager needed
- Plugins: Telescope, Treesitter, LSP, Sidekick, Copilot, Which-key, Catppuccin, and more
- Kotlin LSP support via [kotlin.nvim](https://github.com/AlexandrosAlexiou/kotlin.nvim)

### AeroSpace

Tiling window manager config with:
- Alt-based navigation (vim keys)
- 10 workspaces
- Auto-layout rules for apps like Teams, Outlook, Finder
- Service mode for reload/flatten/close-all

### Zsh

- Starship prompt
- Zoxide (`cd` hooked for fuzzy jumping)
- FZF key bindings
- Homebrew shellenv
- Conditional paths for Kotlin and Android SDK

## License

MIT
