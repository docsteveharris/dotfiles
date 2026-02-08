return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- Use compiler toolchain (we install build-essential) and avoid tree-sitter CLI.
      -- This keeps parsers installable without requiring the external CLI.
      -- (If you later want zero compilation, we can pin parsers another way.)
      auto_install = false,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      -- LazyVim sometimes checks for the `tree-sitter` CLI and warns.
      -- We don't want/need it in this container, so disable that specific requirement check if present.
      local ok, health = pcall(require, "lazyvim.util.health")
      if ok and type(health) == "table" then
        -- Newer LazyVim versions expose helper(s); if not present, this is a no-op.
        health.check = health.check or function() end
      end
      return opts
    end,
  },
}
