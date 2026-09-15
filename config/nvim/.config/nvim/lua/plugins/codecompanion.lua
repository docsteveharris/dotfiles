-- lua/plugins/codecompanion.lua
return {
  "olimorris/codecompanion.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
  opts = {
    strategies = {
      chat = { adapter = "openrouter" },
      inline = { adapter = "openrouter" },
      -- prompt_library = { markdown = { dirs = { vim.fn.expand("~/.config/nvim/prompts") } } },
    },
    adapters = {
      http = {
        openrouter = function()
          return require("codecompanion.adapters").extend("openrouter", {
            env = { api_key = "OPENROUTER_API_KEY" },
            schema = {
              model = {
                default = "openrouter/auto",
              },
            },
          })
        end,
      },
    },
    display = { chat = { show_token_count = true } },
  },
  keys = {
    { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI Chat" },
    { "<leader>ae", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
  },
}
