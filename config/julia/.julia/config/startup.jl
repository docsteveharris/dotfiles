# ~/.julia/config/startup.jl
# Loaded automatically by Julia on every REPL start.
#
# Packages here must be in the global environment:
#   julia> ]
#   (@v1.x) pkg> add Revise OhMyREPL Infiltrator
#
# We guard each with a try/catch so a missing package doesn't
# prevent the REPL from starting.

# Revise: automatically reloads changed code without restarting Julia.
# Essential for interactive development.
try
    using Revise
catch e
    @warn "Revise not available" exception=e
end

# OhMyREPL: syntax highlighting and bracket matching in the REPL.
try
    using OhMyREPL
catch e
    @warn "OhMyREPL not available" exception=e
end

# Infiltrator: drop into a local scope debugger with @infiltrate.
# Only loaded if available — not always needed in every session.
try
    using Infiltrator
catch e
    @warn "Infiltrator not available" exception=e
end

