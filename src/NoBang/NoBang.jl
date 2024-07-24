module NoBang

export Empty, singletonof

using Base.Iterators: Pairs
using Base: ImmutableDict
using ConstructionBase: constructorof, setproperties

using ..BangBang: push!!, unique!!, union!!, symdiff!!, implements

include("singletoncontainers.jl")
include("base.jl")
include("linearalgebra.jl")
include("singletonof.jl")
include("emptycontainers.jl")

end  # module
