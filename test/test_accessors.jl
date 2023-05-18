module TestAccessors

include("preamble.jl")
using Accessors: @optic, Accessors, set

struct LensWrapper
    lens::Any
end

Accessors.get(obj, lens::LensWrapper) = get(obj, lens.lens)
Accessors.set(obj, lens::LensWrapper, value) = set(obj, lens.lens, value)

mutable struct Mutable
    a
    b
end

@testset "nested mutable" begin
    x = orig = Mutable((x=Mutable(1, 2), y=3), 4);
    @set!! x.a.x.a = 10;
    @test x.a.x.a == orig.a.x.a == 10
end

@testset "arrays" begin
    v = [1, 2, Mutable(1, 2)]
    x = orig = Mutable((x=v, y=3), 4);
    @set!! x.a.x[3].a = 10;
    @test x.a.x[3].a == orig.a.x[3].a == 10
    @test x.a.x === v
end

@testset "index lenses" begin
    @static if isdefined(Accessors, :ConstIndexLens)
        @testset "ConstIndexLens" begin
            v = [1, 2, 3]
            i = j = 1
            @set!! v[$(i + j)] = 20
            @test v[2] == 20
        end
    end
    @testset "DynamicIndexLens" begin
        v = [1, 2, 3]
        @set!! v[end] = 30
        @test v[3] == 30
    end
end

@testset "default to immutable" begin
    x = Mutable((x=Mutable(1, 2), y=3), 4);
    l = prefermutation(LensWrapper(@optic _.a.x.a))
    y = set(x, l, 10)
    @test y !== x
    @test y.a.x.a == 10
end

end  # module
