#!/bin/sh
# Switch to homebrew bash for better integration with ghostty
# https://ghostty.org/docs/features/shell-integration
# https://apple.stackexchange.com/a/479215
chsh -s /opt/homebrew/bin/bash

# Install Julia
# https://docs.julialang.org/en/v1/manual/installation/
curl -fsSL https://install.julialang.org | sh

# Conda/Mamba
# https://www.anaconda.com/docs/getting-started/miniconda/install#macos-terminal-installer
# curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh
# bash ~/Miniconda3-latest-MacOSX-arm64.sh
# accept all the defaults
# conda install -n base -c conda-forge mamba
# 2026-02-23 dropped as a system install; prefer uv and local envs

# https://www.visidata.org/install/
# https://github.com/saulpw/visidata/issues/2259#issuecomment-2648974959
# 29/11/2025 abandoned local install and revereted to brew even though vdsql does not work
