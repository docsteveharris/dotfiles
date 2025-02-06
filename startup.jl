using Pkg: Pkg
using InteractiveUtils
using Revise
# https://github.com/JuliaDebug/Infiltrator.jl?tab=readme-ov-file#auto-loading-infiltratorjl
using Infiltrator

atreplinit() do repl
    # use zed for command line editing
    InteractiveUtils.define_editor("zed") do cmd, path, line, column
        `$cmd $path:$line:$column`
    end

    println("Starting ...")
    println("Loading configuration from ~/.julia/config/startup.jl")
    try
        @eval using OhMyREPL

    catch e
        @warn "error while importing OhMyREPL" e
    end

    # activate appropriate environment
    if isfile("Project.toml")
        Pkg.activate(".")
    end
end
