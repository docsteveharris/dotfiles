-- julia-lsp.lua
-- julials (LanguageServer.jl) is not installed in this environment.
-- We use jetls instead (configured in jetls.lua).
-- This file explicitly disables julials to suppress the "client quit" error.

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        julials = { enabled = false },
      },
    },
  },
}
