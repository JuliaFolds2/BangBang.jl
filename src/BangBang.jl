module BangBang

# Use README as the docstring of the module:
@doc read(joinpath(dirname(@__DIR__), "README.md"), String) BangBang

export @!,
       @set!!,
       Empty,
       add!!,
       append!!,
       broadcast!!,
       collector,
       delete!!,
       deleteat!!,
       empty!!,
       finish!,
       lmul!!,
       materialize!!,
       merge!!,
       mergewith!!,
       mul!!,
       pop!!,
       popfirst!!,
       prefermutation,
       push!!,
       pushfirst!!,
       rmul!!,
       setdiff!!,
       setindex!!,
       setproperties!!,
       setproperty!!,
       singletonof,
       splice!!,
       union!!,
       unique!!

using Base.Broadcast:
    Broadcasted,
    broadcasted,
    combine_eltypes,
    copyto_nonleaf!,
    instantiate,
    materialize!,
    preprocess
using Base: HasEltype, IteratorEltype, promote_typejoin
using Compat: hasproperty
using ConstructionBase: constructorof
using InitialValues
using LinearAlgebra

@static if !isdefined(Base, :get_extension)
    using Requires
end

include("utils.jl")

# Used in NoBang:
function implements end
function push!! end
function unique!! end

include("NoBang/NoBang.jl")
using .NoBang: Empty, SingletonVector, singletonof

# Next breaking version we should make this a proper extension
# ----------------------
# @static if !isdefined(Base, :get_extension)
# using Tables
# include("../ext/BangBangTablesExt.jl")
# end
# using Tables
# include("BangBangTablesExt.jl")


include("core.jl")
include("base.jl")
include("linearalgebra.jl")
include("extras.jl")
include("broadcast.jl")
include("collectors.jl")
include("initials.jl")
include("macro.jl")
include("setfield.jl")

using .SetfieldImpl: @set!!, prefermutation

function __init__()
    @static if !isdefined(Base, :get_extension)
        @require StaticArrays = "90137ffa-7385-5640-81b9-e52037218182" begin
            include("../ext/BangBangStaticArraysExt.jl")
        end
        @require StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a" begin
            include("../ext/BangBangStructArraysExt.jl")
        end
        @require Tables = "bd369af6-aec1-5ad0-b16a-f7cc5008161c" begin
            include("../ext/BangBangTablesExt.jl")
        end
        @require TypedTables = "9d95f2ec-7b3d-5a63-8d20-e2491e220bb9" begin
            include("../ext/BangBangTypedTablesExt.jl")
        end
        @require DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0" begin
            include("../ext/BangBangDataFramesExt.jl")
        end
        @require ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4" begin
            include("../ext/BangBangChainRulesCoreExt.jl")
        end
    end
end

end # module
