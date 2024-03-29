module TestUnion

include("preamble.jl")
using BangBang: SingletonVector
using InitialValues: InitialValue, asmonoid

@testset begin
    @test_returns_first union!!([0]) == [0]
    @test_returns_first union!!(Set([0])) == Set([0])
    @test union!!([0.0], [1.0]) ==ₜ [0.0, 1.0]
    @test union!!([0], [0.5]) ==ₜ [0.0, 0.5]
    @test union!!(Set([0.0]), [1.0]) ==ₜ Set([0.0, 1.0])
    @test union!!(Set([0]), [0.5]) ==ₜ Set([0.0, 0.5])
    @test union!!(Empty(Set), [0]) ==ₜ Set([0])
    @test union!!(Empty(Set), SingletonVector(0)) ==ₜ Set([0])
end

@testset "Empty" begin
    @testset "union!!(::Empty, ::Empty) :: Empty" begin
        @test union!!(Empty(Set), Empty(Set)) === Empty(Set)
        @test union!!(Empty(Set), Empty(Vector)) === Empty(Set)
    end
    @test union!!(Empty(Set)) === Empty(Set)
end

@testset "mutation" begin
    @testset "Vector" begin
        x = [0.0]
        @test union!!(x, [1]) === x
        @test x ==ₜ [0.0, 1.0]
    end
    @testset "Set" begin
        x = Set([0.0])
        @test union!!(x, [1]) === x
        @test x ==ₜ Set([0.0, 1.0])
    end
end

@testset "InitialValue" begin
    xs = Set([0])
    @test union!!(xs, InitialValue(union!!)) === xs
    @test union!!(InitialValue(union!!), xs) !== xs
    @test union!!(InitialValue(union!!), xs) ==ₜ xs
    @test union!!(InitialValue(union!!), (x for x in xs if true)) ==ₜ xs
    @test union!!(InitialValue(union!!), InitialValue(union!!)) === InitialValue(union!!)
    @test asmonoid(union!!) === union!!
end

end  # module
