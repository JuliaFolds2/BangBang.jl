module TestSymdiff

include("preamble.jl")
# using MicroCollections: SingletonSet

@testset begin
    @test_returns_first symdiff!!([0]) == [0]
    @test_returns_first symdiff!!(Set([0])) == Set([0])
    @test_returns_first symdiff!!([0], [0]) == []
    @test_returns_first symdiff!!([0], (0,)) == []
    @test_returns_first symdiff!!([0, 1, 2], (0, 1), [1, 3]) == [1, 2, 3]
    @test_returns_first symdiff!!(Set([0]), [0]) == Set()
    @test_returns_first symdiff!!(Set([0]), (1,)) == Set([0, 1])
    @test_returns_first symdiff!!(Set([0, 1, 2]), Set([0, 1]), [1]) == Set([1, 2])
    @test symdiff!!(Empty(Set)) === Empty(Set)
    @test symdiff!!(Empty(Vector), Empty(Vector)) === Empty(Vector)
    @test symdiff!!(Empty(Set{Int}), Empty(Vector)) === Empty(Set{Int})
    #=
    @test symdiff!!(SingletonSet((0,)), [0]) ==ₜ Set{Int}()
    @test symdiff!!(SingletonSet((0,)), [1]) ==ₜ Set([0, 1])
    =#
end

end  # module
