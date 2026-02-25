-- JETLS: Julia Language Server (experimental)
-- https://aviatesk.github.io/JETLS.jl/release/
-- Requires: julia --project=~/.julia/environments/jetls -e 'import Pkg; Pkg.add(url="https://github.com/aviatesk/JETLS.jl")'
-- and ~/.julia/bin on PATH

vim.lsp.config("jetls", {
  cmd = { "jetls", "serve" },
  filetypes = { "julia" },
  root_markers = { "Project.toml" },
})
vim.lsp.enable("jetls")

return {}
