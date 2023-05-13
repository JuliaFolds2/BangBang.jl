module NoBang

export Empty, singletonof

using Base.Iterators: Pairs
using Base: ImmutableDict
using Requires
using ConstructionBase: constructorof, setproperties
using Tables: Tables

using ..BangBang: push!!, unique!!, implements

include("singletoncontainers.jl")
include("base.jl")
include("linearalgebra.jl")
include("singletonof.jl")
include("emptycontainers.jl")

end  # module
