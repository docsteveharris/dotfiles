# jumplist.yazi

A [Yazi](https://yazi-rs.github.io/) plugin to navigate your cwd jumplist.

## Installation

Use the [yazi package manager](https://yazi-rs.github.io/docs/cli#package-manager) to install this plugin:

```bash
ya pkg add 0xHouss/jumplist
```


## Usage

1. Key bindings:

    Add this to your [`~/.config/yazi/keymap.toml`](https://yazi-rs.github.io/docs/configuration/keymap):

    ```toml
    # A TOML linter such as https://taplo.tamasfe.dev/ can use this schema to validate your config.
    # If you encounter any issues, please make an issue at https://github.com/yazi-rs/schemas.
    "$schema" = "https://yazi-rs.github.io/schemas/keymap.json"

    [mgr]
    prepend_keymap = [
      ...

      # Jumplist

      # Inspired from vim's jumplist bindings
      { on = [
        "<C-o>",
      ], run = "plugin jumplist -- --direction=back", desc = "Go back in jumplist" },
      { on = [
        "<C-i>",
      ], run = "plugin jumplist -- --direction=forward", desc = "Go forward in jumplist" },

      # Or
      # Inspired from browsers' history navigation
      { on = [
        "<A-left>",
      ], run = "plugin jumplist -- --direction=back", desc = "Go back in jumplist" },
      { on = [
        "<A-right>",
     ], run = "plugin jumplist -- --direction=forward", desc = "Go forward in jumplist" },

      ...
    ]

    ...
    ```

2. Setup

    Add this to your [`~/.config/yazi/init.lua`](https://yazi-rs.github.io/docs/configuration/overview#init.lua):

    ```lua
    require("jumplist"):setup()
    ```

    This is required — the plugin tracks directory changes from the `cd` event it
    subscribes to here.

    Options:

    ```lua
    require("jumplist"):setup({
      -- Maximum entries kept per direction, per tab. Default: 100
      limit = 100,
    })
    ```

3. Enjoy:

    When you navigate inside yazi, your jumplist will store the last visited paths, and then you can use your back and forward key bindings to navigate them.

    Each tab keeps its own jumplist, and directories that no longer exist are
    skipped over when jumping.

## Todo

- Record moves and renames, so jumps survive a directory being relocated
