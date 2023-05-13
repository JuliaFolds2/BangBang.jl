module BangBangTypedTablesExt
    using BangBang
    using BangBang.NoBang 
    using TypedTables
    Base.append!(dest::TypedTables.Table, src::NoBang.SingletonVector{<:NamedTuple}) =
    push!(dest, first(src))
end