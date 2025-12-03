-- Problems with Mason so need to independently manage LSP for julia
-- https://discourse.julialang.org/t/neovim-languageserver-jl-crashing-again/130273/3
-- and here https://github.com/neovim/nvim-lspconfig/blob/master/lsp/julials.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      vim.lsp.config("julials", {}),
      vim.lsp.enable("julials"),
    },
  },
}
