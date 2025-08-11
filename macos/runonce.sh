#!/bin/sh
# Switch to homebrew bash for better integration with ghostty
# https://ghostty.org/docs/features/shell-integration
# https://apple.stackexchange.com/a/479215
chsh -s /opt/homebrew/bin/bash

# Install Julia
# https://docs.julialang.org/en/v1/manual/installation/
curl -fsSL https://install.julialang.org | sh
