
module BangBangStaticArraysExt
@static if isdefined(Base, :get_extension)
    using BangBang: BangBang
    using BangBang.NoBang: NoBang
    using BangBang: setindex!
    using StaticArrays: StaticArrays
else
    using ..BangBang: BangBang
    using ..BangBang.NoBang: NoBang
    using ..BangBang: setindex!
    using ..StaticArrays: StaticArrays
end


    NoBang.push(xs::StaticArrays.StaticVector, x) = vcat(xs, StaticArrays.SVector(x))
    NoBang.pushfirst(xs::StaticArrays.StaticVector, x) = StaticArrays.pushfirst(xs, x)
    NoBang.pushfirst(xs::StaticArrays.StaticVector, y, ys...) =
    foldl(NoBang.pushfirst, (reverse(ys)..., y), init=xs)
    NoBang.pop(xs::StaticArrays.StaticVector) = (StaticArrays.pop(xs), xs[end])
    NoBang.popfirst(xs::StaticArrays.StaticVector) = (StaticArrays.popfirst(xs), xs[1])
    NoBang.deleteat(xs::StaticArrays.StaticVector, i) = StaticArrays.deleteat(xs, i)
    NoBang._empty(xs::StaticArrays.StaticVector) =
    foldl(ntuple(identity, length(xs)); init=xs) do xs, _
        StaticArrays.pop(xs)
    end
    NoBang._setindex(xs::StaticArrays.StaticArray, v, I...) = Base.setindex(xs, v, I...)

    StaticArrays.SArray(x::NoBang.SingletonVector) = StaticArrays.SVector{1}(x)
    StaticArrays.SVector(x::NoBang.SingletonVector) = StaticArrays.SVector{1}(x)
    StaticArrays.MArray(x::NoBang.SingletonVector) = StaticArrays.MVector{1}(x)
    StaticArrays.MVector(x::NoBang.SingletonVector) = StaticArrays.MVector{1}(x)


    BangBang.implements(::BangBang.Mutator, ::Type{<:StaticArrays.StaticArray}) = false
    BangBang.implements(::typeof(setindex!), ::Type{<:StaticArrays.MArray}) = true
    BangBang.copyappendable(src::StaticArrays.StaticVector) = src
end
