-- 2026-02-24 created when I was having trouble getting text onto the system clipboard
return {
  {
    -- Use OSC 52 for clipboard (works over SSH, in containers, through Zellij)
    "LazyVim/LazyVim",
    opts = function(_, opts)
      -- Neovim 0.10+ has built-in OSC 52 support
      vim.g.clipboard = {
        name = "OSC 52",
        copy = {
          ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
          ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
        },
        paste = {
          ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
          ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
        },
      }
      return opts
    end,
  },
}
