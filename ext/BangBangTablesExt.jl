module BangBangTablesExt

# Uncomment the following code when we move Tables to an extension
#---------------------------
@static if isdefined(Base, :get_extension)
    using BangBang: BangBang
    using BangBang.NoBang: SingletonVector
    using Tables: Tables
else
    using ..BangBang: BangBang
    using ..BangBang.NoBang: SingletonVector
    using ..Tables: Tables
end

# Define table interface as a `SingletonVector{<:NamedTuple}`:
Tables.istable(::Type{<:SingletonVector{<:NamedTuple{names}}}) where {names} =
    @isdefined(names)
Tables.rowaccess(::Type{<:SingletonVector{<:NamedTuple{names}}}) where {names} =
    @isdefined(names)
Tables.columnaccess(::Type{<:SingletonVector{<:NamedTuple{names}}}) where {names} =
    @isdefined(names)

# For backward compatibility (these were automatically `false` in Tables 0.2):
Tables.istable(::Type{SingletonVector{NamedTuple}}) = false
Tables.istable(::Type{SingletonVector{<:NamedTuple}}) = false

Tables.rows(x::SingletonVector{<:NamedTuple}) = [x.value]
Tables.columns(x::SingletonVector{<:NamedTuple{names}}) where {names} =
    NamedTuple{names}(map(x -> [x], Tuple(x.value)))

end
