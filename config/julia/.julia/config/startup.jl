# ~/.julia/config/startup.jl
# Loaded automatically by Julia on every REPL start.
#
# Global env prerequisites (install once):
#   julia> ]
#   (@v1.x) pkg> add Revise OhMyREPL Infiltrator BenchmarkTools Term

# ── Visual feedback ───────────────────────────────────────────────────────────
@info "startup.jl loaded" julia=VERSION

# ── Stdlib (always available, no install needed) ──────────────────────────────
using Dates
using Statistics
using InteractiveUtils   # @which, @edit, @less, versioninfo()
using Logging
global_logger(ConsoleLogger(stderr, Logging.Info))

# ── Environment tweaks ────────────────────────────────────────────────────────

# Suppress automatic precompilation noise on package load
ENV["JULIA_PKG_PRECOMPILE_AUTO"] = 0

# Shorter, more readable stacktraces
ENV["JULIA_STACKTRACE_MINIMAL"] = 1

# ── REPL packages ─────────────────────────────────────────────────────────────

# Revise: automatically reloads changed code without restarting Julia.
# Essential for interactive development.
try
    using Revise
    Revise.async_steal_repl_backend()
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
try
    using Infiltrator
catch e
    @warn "Infiltrator not available" exception=e
end

# BenchmarkTools: @btime and @benchmark for performance measurement.
try
    using BenchmarkTools
catch e
    @warn "BenchmarkTools not available" exception=e
end

# Term: prettier terminal output for structs and progress.
try
    using Term
catch e
    @warn "Term not available" exception=e
end

# ── DS convenience ────────────────────────────────────────────────────────────
# Push a shared DS environment onto the load path so DuckDB, DataFrames etc.
# are available in the bare REPL without polluting project environments.
# When inside a project, the project's own versions always take precedence.
#
# To set up the @datasci env (once):
#   julia --project=@datasci -e 'import Pkg; Pkg.add(["DuckDB","DataFrames","CSV"])'
if "@datasci" ∉ LOAD_PATH
    push!(LOAD_PATH, "@datasci")
end

# ── REPL utilities ────────────────────────────────────────────────────────────

# Quick peek at any tabular object (first n rows)
function peek(x, n=5)
    try
        first(x, n)
    catch
        x
    end
end

# Clear the REPL screen
cls() = print("\033[2J\033[1;1H")

# Time an expression, print elapsed ms, return value
macro t(ex)
    :(begin
        local t0 = time_ns()
        local val = $(esc(ex))
        local t1 = time_ns()
        @info "elapsed" ms=round((t1 - t0) / 1e6, digits=2)
        val
    end)
end

# Print type, size, and shape of any variable
function info(x)
    println("type:  ", typeof(x))
    println("size:  ", Base.summarysize(x) |> Base.format_bytes)
    try println("dims:  ", size(x))    catch end
    try println("nrows: ", nrow(x))    catch end
end

