# Log

## 2025-12-01 22:30:51

Probably easier to get on and install kitty
https://sw.kovidgoyal.net/kitty/overview/#other-keyboard-shortcuts

Now trying to set-up on UCLH but there are too many differences

```bash
sudo apt update
sudo apt install tldr bat fzf lsd fd-find ffmpeg poppler-utils
sudo apt install imagemagick zoxide
sudo apt install tree
```

then switch to doing a yazi install as per https://yazi-rs.github.io/docs/installation/#binaries

```bash
# ⚠️this doesn't work
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
# then
source .bashrc
. .cargo/env

# 👉 this does work
# build from source
git clone https://github.com/sxyazi/yazi.git
cd yazi
cargo build --release --locked
# then symlink into path
mv target/release/yazi target/release/ya /usr/local/bin/
```

and note that `brew install yazi` also doesn't work so you do need to compile locally

then neovim and dependencies
but be warned the apt install version is _very_ old, you need to use brew (see below)

```bash
# neovim
sudo apt install neovim
# nerdfont
mkdir -p ~/.local/share/fonts/NerdFonts
wget -O ~/Downloads/VictorMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/VictorMono.zip
unzip ~/Downloads/VictorMono.zip -d ~/.local/share/fonts/NerdFonts
fc-cache -fvf
# treesitter
cargo install --locked tree-sitter-cli
```

OMG🙀
Homebrew on Debian
... which presumably means I can switch all my installs above to work with the existing brew files

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

==> Next steps:
- Run these commands in your terminal to add Homebrew to your PATH:
    echo >> /config/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /config/.bashrc
    - Install Homebrew's dependencies if you have sudo access:
    sudo apt-get install build-essential
  For more information, see:
    https://docs.brew.sh/Homebrew-on-Linux
- We recommend that you install GCC:
    brew install gcc
- Run brew help to get started
- Further documentation:
    https://docs.brew.sh
```

Next Zellij
https://zellij.dev/documentation/installation.html

```bash
cargo install --locked zellij
```

Next duckdb
https://duckdb.org/install/?platform=linux&environment=cli

```bash
curl https://install.duckdb.org | sh
```

Next Julia

## 2025-12-01

committing this all to github
staying on branch airm4
at some point need to also update from original

## 2025-11-29

Installing Java

<https://stackoverflow.com/a/65601197/992999>

```sh
ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk \
     /Library/Java/JavaVirtualMachines/openjdk.jdk
```

but in the end seemed to install okay from homebrew
