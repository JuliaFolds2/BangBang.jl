module TestIntersect

include("preamble.jl")
# using MicroCollections: SingletonSet

@testset begin
    @test_returns_first intersect!!([0]) == [0]
    @test_returns_first intersect!!(Set([0])) == Set([0])
    @test_returns_first intersect!!([0], [1]) == []
    @test_returns_first intersect!!([0], (1,)) == []
    @test_returns_first intersect!!([0, 1, 2], (0, 1), [1, 2]) == [1]
    @test_returns_first intersect!!(Set([0]), [0]) == Set([0])
    @test_returns_first intersect!!(Set([0]), (0,)) == Set([0])
    @test_returns_first intersect!!(Set([0, 1, 2]), Set([0,1]), [1, 2]) == Set([1])
    @test intersect!!(Empty(Set)) === Empty(Set)
    @test intersect!!(Empty(Vector), Empty(Set)) === Empty(Vector)
    @test intersect!!(Empty(Vector), [0]) === Empty(Vector)
    @test intersect!!(Empty(Set{Int}), [0]) === Empty(Set{Int})
    #=
    @test intersect!!(SingletonSet((0,)), [0]) ==ₜ Set([0])
    @test intersect!!(SingletonSet((0,)), [1]) ==ₜ Set{Int}()
    =#
end

end  # module
