-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- lazyvim space fw saves the file
vim.keymap.set("n", "<leader>fw", "<cmd>update<cr>", {
  desc = "Save file",
})
