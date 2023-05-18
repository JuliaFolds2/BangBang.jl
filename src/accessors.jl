module AccessorsImpl

export @set!!, prefermutation

using ..BangBang: setproperty!!, setindex!!
#using Setfield: ComposedLens, DynamicIndexLens, IndexLens, Lens, PropertyLens, Setfield, set
using Accessors: Accessors, IndexLens, PropertyLens, set, get, ComposedOptic
struct Lens!!{T}
    lens::T
end
(l::Lens!!)(o) = l.lens(o)

Accessors.get(obj, lens::Lens!!) = get(obj, lens.lens)

# Default to immutable:
Accessors.set(obj, lens::Lens!!, value) = set(obj, lens.lens, value)

Accessors.set(obj, lens::Lens!!{<:ComposedOptic}, value) =
    set(obj, Lens!!(lens.lens.outer) ∘ Lens!!(lens.lens.inner), value)

Accessors.set(obj, ::Lens!!{<:PropertyLens{fieldname}}, value) where {fieldname} =
    setproperty!!(obj, fieldname, value)

indicesfor(lens::IndexLens, _) = lens.indices
# indicesfor(lens::DynamicIndexLens, obj) = lens.f(obj)

# if isdefined(Setfield, :ConstIndexLens)
#     using Setfield: ConstIndexLens
#     const SupportedIndexLens = Union{ConstIndexLens,DynamicIndexLens,IndexLens}
#     indicesfor(::ConstIndexLens{I}, _) where {I} = I
# else
#     const SupportedIndexLens = Union{DynamicIndexLens,IndexLens}
# end

Accessors.set(obj, lens::Lens!!{<:IndexLens}, value) =
    setindex!!(obj, value, indicesfor(lens.lens, obj)...)

"""
    prefermutation(lens::Lens) :: Lens

See also [`@set!!`](@ref).
"""
prefermutation
prefermutation(lens) = Lens!!(lens)

"""
    @set!! assignment

Like `Accessors.@set`, but prefer mutation if possible.

# Examples
```jldoctest
julia> using BangBang

julia> mutable struct Mutable
           a
           b
       end

julia> x = orig = Mutable((x=Mutable(1, 2), y=3), 4);

julia> @set!! x.a.x.a = 10;

julia> @assert x.a.x.a == orig.a.x.a == 10
```
"""
:(@set!!)
macro set!!(ex)
    Accessors.setmacro(prefermutation, ex, overwrite = true)
end

end  # module
