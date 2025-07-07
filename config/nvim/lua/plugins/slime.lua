-- In ~/.config/nvim/lua/plugins/slime.lua
-- return {
--   "jpalardy/vim-slime",
--   config = function()
--     vim.g.slime_target = "tmux" -- or "terminal", "screen", etc.
--     vim.g.slime_default_config = {
--       socket_name = "default",
--       target_pane = "{last}",
--     }
--   end,
-- }
return {
  -- vim-slime for REPL integration
  {
    "jpalardy/vim-slime",
    lazy = false,

    config = function()
      vim.g.slime_target = "zellij"
      vim.g.slime_default_config = {
        session_id = "current",
        relative_pane = "right",
        relative_move_back = true,
      }

      vim.g.slime_dont_ask_default = 1

      -- Key mappings
      vim.keymap.set("n", "<leader>r", "<Plug>SlimeLineSend", { desc = "Send line to REPL" })
      vim.keymap.set("v", "<leader>r", "<Plug>SlimeRegionSend", { desc = "Send selection to REPL" })
      vim.keymap.set("n", "<leader>R", "<Plug>SlimeParagraphSend", { desc = "Send paragraph to REPL" })
    end,
  },
}
