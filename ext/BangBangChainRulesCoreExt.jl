module BangBangChainRulesCoreExt
    # https://fluxml.ai/Zygote.jl/dev/adjoints/#Gradient-Reflection-1
@static if isdefined(Base, :get_extension)
    using BangBang: possible
    using ChainRulesCore
else
    using ..BangBang: possible
    using ..ChainRulesCore
end

    # Treat everything immutable during differentiation:
    ChainRulesCore.rrule(::typeof(possible), _...) = false, _ -> ChainRulesCore.NoTangent()
end
