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
       intersect!!,
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
       symdiff!!,
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
using ConstructionBase: constructorof
using InitialValues
using LinearAlgebra

include("utils.jl")

# Used in NoBang:
function implements end
function push!! end
function unique!! end
function union!! end
function symdiff!! end

include("NoBang/NoBang.jl")
using .NoBang: Empty, SingletonVector, singletonof

include("core.jl")
include("base.jl")
include("linearalgebra.jl")
include("extras.jl")
include("broadcast.jl")
include("collectors.jl")
include("initials.jl")
include("macro.jl")
include("accessors.jl")

using .AccessorsImpl: @set!!, prefermutation

end # module
