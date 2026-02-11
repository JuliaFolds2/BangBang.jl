module TestDataFrames

using BangBang: append!!, push!!, setindex!!
using CategoricalArrays: CategoricalArray
using DataFrames: DataFrame
using InitialValues: InitialValue
using Tables: Tables
using Test

@testset "push!!" begin
    @testset "column: $(typeof(column)); row: $(typeof(row))" for (column, row) in [
        ([0], (a = 1,)),
        ([0], Dict(:a => 1)),
        ([0], [1]),
        ([0], (1,)),
        ([0.5], (a = 1,)),
        ([0.5], Dict(:a => 1)),
        ([0.5], [1]),
        ([0.5], (1,)),
        ([0], (a = 1.5,)),
        (CategoricalArray(["A", "B"]), (a = "A",)),
        (CategoricalArray(["A", "B"]), (a = "C",)),
    ]
        df = DataFrame(a = copy(column))
        # row isa DataFrame
        # row[:, :a] .+= 1
        if row isa Union{Array, Tuple}
            df2 = DataFrame(a=row[1])
        else
            df2 = DataFrame([(; pairs(row)...)])
        end
        @test push!!(copy(df), row) == vcat(df, df2)
        @test push!(push!!(copy(df), row), row) isa DataFrame
    end
end

@testset "push!!(::DataFrame, ::IteratorRow)" begin
    @testset "column: $(typeof(column)); row: $(typeof(row))" for (column, row) in [
        ([0], Tables.IteratorRow((a = 1,))),
        ([0.5], Tables.IteratorRow((a = 1,))),
    ]
        df = DataFrame(a = copy(column))
        df2 = DataFrame([(a = 1,)])
        @test push!!(copy(df), row) == vcat(df, df2)
    end
end

@testset "append!!" begin
    @testset "column: $(typeof(column)); source: $(typeof(source))" for (
        column,
        source,
    ) in [
        ([0], ((a = 1,),)),
        ([0], [(a = 1,)]),
        ([0], (a = [1],)),
        # ([0], Dict(:a => [1])),
        ([0], DataFrame(a = [1])),
        ([0.5], ((a = 1,),)),
        ([0.5], [(a = 1,)]),
        ([0.5], (a = [1],)),
        ([0.5], DataFrame(a = [1])),
        ([0], ((a = 1.5,),)),
        ([0], [(a = 1.5,)]),
        ([0], (a = [1.5],)),
        ([0], DataFrame(a = [1.5])),
        (CategoricalArray(["A", "B"]), ((a = "A",),)),
        (CategoricalArray(["A", "B"]), [(a = "A",)]),
        (CategoricalArray(["A", "B"]), (a = ["A"],)),
        (CategoricalArray(["A", "B"]), ((a = "C",),)),
        (CategoricalArray(["A", "B"]), [(a = "C",)]),
        (CategoricalArray(["A", "B"]), (a = ["C"],)),
    ]
        df = DataFrame(a = copy(column))
        # source isa DataFrame
        # source[:, :a] .+= 1
        @test append!!(copy(df), source) == vcat(df, DataFrame(source))
    end
    @testset "Init" begin
        src = DataFrame(a=[1])
        dest = append!!(InitialValue(append!!), src)
        @test src == dest
        src.a[1] = 123
        @test src != dest
    end
end

@testset "setindex!!" begin
    @testset "basic" begin
        df = DataFrame("a" => [0.0])
        @test setindex!!(df, 1.0, 1, "a") === df
        @test df[1, "a"] === 1.0
    end

    @testset "Symbol column" begin
        df = DataFrame(a = [0.0])
        @test setindex!!(df, 2.0, 1, :a) === df
        @test df[1, :a] === 2.0
    end

    @testset "Integer column" begin
        df = DataFrame(a = [0.0])
        @test setindex!!(df, 3.0, 1, 1) === df
        @test df[1, 1] === 3.0
    end

    @testset "type widening" begin
        df = DataFrame(a = [1, 2, 3])
        result = setindex!!(df, 1.5, 2, :a)
        @test result === df
        @test df[2, :a] === 1.5
        @test eltype(df.a) === Float64
    end
end

end  # module
