# Helper types for implementing `push`


struct SingletonVector{T} <: AbstractVector{T}
    value::T
end

Base.size(::SingletonVector) = (1,)
Base.first(v::SingletonVector) = v.value
Base.last(v::SingletonVector) = v.value

function Base.getindex(v::SingletonVector, i::Integer)
    @boundscheck i == 1 || throw(BoundsError(v, i))
    return v.value
end

struct _NoValue end

@inline Base.foldl(op, v::SingletonVector; init = _NoValue()) =
    init isa _NoValue ? v.value : op(init, v.value)


struct SingletonDict{K,V} <: AbstractDict{K,V}
    key::K
    value::V
end

SingletonDict((key, value)::Pair) = SingletonDict(key, value)

Base.iterate(d::SingletonDict) = (d.key => d.value, nothing)
Base.iterate(d::SingletonDict, ::Nothing) = nothing

Base.first(d::SingletonDict) = d.key => d.value
Base.last(d::SingletonDict) = d.key => d.value

function Base.getindex(d::SingletonDict{K}, key::K) where {K}
    @boundscheck isequal(d.key, key) || throw(BoundsError(d, key))
    return d.value
end

Base.get(d::SingletonDict, k, v) = isequal(d.key, k) ? d.value : v

Base.length(::SingletonDict) = 1
