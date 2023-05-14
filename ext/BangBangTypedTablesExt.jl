module BangBangTypedTablesExt
@static if isdefined(Base, :get_extension)
    using BangBang
    using BangBang.NoBang 
    using TypedTables
else
    using ..BangBang
    using ..BangBang.NoBang 
    using ..TypedTables
end
    Base.append!(dest::TypedTables.Table, src::NoBang.SingletonVector{<:NamedTuple}) =
    push!(dest, first(src))
end
