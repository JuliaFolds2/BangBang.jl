"""
    @! expr

Convert all supported mutating calls to double bang equivalent.

# Examples
```jldoctest
julia> using BangBang

julia> @! push!(empty!((0, 1)), 2, 3)
(2, 3)

julia> y = [1, 2];

julia> @! y .= 2 .* y
       y
2-element Vector{Int64}:
 2
 4

julia> y = (1, 2);

julia> @! y .= 2 .* y
       y
(2, 4)
```
"""
macro !(expr)
    foldexpr(macroexpand(__module__, expr)) do x
        if Meta.isexpr(x, :call)
            isdotoperator(x.args[1]) && return x
            return Expr(:call, Expr(:call, _maybb, x.args[1]), x.args[2:end]...)
        elseif isdotoperator(x.head) && isequalsoperator(x.head) && x.args[1] isa Symbol
            @assert length(x.args) == 2
            lhs, rhs = x.args
            op = unequalsoperator(undotoperator(x.head))
            if isnothing(op)
                return :($lhs = $materialize!!(
                    $Base.@isdefined($lhs) ? $lhs : $(Undefined()),
                    $rhs,
                ))
            end
            return :($lhs = $(Extras.broadcast_inplace!!)($op, $lhs, $rhs))
        end
        return x
    end |> esc
end

foldexpr(f, x) = x
foldexpr(f, ex::Expr) = f(Expr(ex.head, foldexpr.(f, ex.args)...))

isdotoperator(x::Symbol) = undotoperator(x) !== nothing

isequalsoperator(x::Symbol) = unequalsoperator(x) !== nothing

function undotoperator(x::Symbol)
    startswith(string(x), ".") || return nothing
    op = Symbol(string(x)[2:end])
    Base.isoperator(op) || return nothing
    return op
end

function unequalsoperator(x::Symbol)
    endswith(string(x), "=") || return nothing
    op = Symbol(string(x)[1:end-1])
    Base.isoperator(op) || return nothing
    return op
end

# Should not be required anymore. Keep for backwards compatibility?
function air end
struct Aired{T}
    value::T
end
@inline Broadcast.broadcasted(::typeof(air), x) = Aired(x)
@inline Broadcast.materialize(x::Aired) = x.value
