return {
  {
    "mason-org/mason.nvim",
    opts = {
      automatic_enable = { exclude = { "julials" } },
      -- :2025-12-03T22:33:32
      -- mainly switching icons to be able to test that the options are being applied
      -- seems to always need a restart
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
}
