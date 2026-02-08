return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader><leader>",
      function()
        local root = require("lazyvim.util").root.get()
        Snacks.picker.files({
          cwd = root,
          cmd = "fd",
          args = { "--hidden", "--follow", "--exclude", ".git" },
        })
      end,
      desc = "Find Files (Root Dir, hidden)",
    },
  },
}
