module TestSetIndex

include("preamble.jl")

# Some utility methods for testing `setindex!`.
replace_colon_with_axis(inds::Tuple, x) = ntuple(length(inds)) do i
    inds[i] isa Colon ? axes(x, i) : inds[i]
end
replace_colon_with_vector(inds::Tuple, x) = ntuple(length(inds)) do i
    inds[i] isa Colon ? collect(axes(x, i)) : inds[i]
end
replace_colon_with_range(inds::Tuple, x) = ntuple(length(inds)) do i
    inds[i] isa Colon ? (1:size(x, i)) : inds[i]
end
replace_colon_with_booleans(inds::Tuple, x) = ntuple(length(inds)) do i
    inds[i] isa Colon ? trues(size(x, i)) : inds[i]
end

replace_colon_with_range_linear(inds::NTuple{1}, x::AbstractArray) = inds[1] isa Colon ? (1:length(x),) : inds

# TODO: Do we handle expansive indexing, e.g. `x[:, :]` for `x isa Vector` correctly?
is_linear_index(inds::Tuple, x::AbstractArray) = length(inds) == 1

@testset begin
    @test setindex!!((1, 2, 3), :two, 2) === (1, :two, 3)
    @test setindex!!((a=1, b=2, c=3), :two, :b) === (a=1, b=:two, c=3)
    @test setindex!!([1, 2, 3], :two, 2) == [1, :two, 3]
    @test setindex!!(Dict{Symbol,Int}(:a=>1, :b=>2), 10, :a) ==
        Dict(:a=>10, :b=>2)
    @test setindex!!(Dict{Symbol,Int}(:a=>1, :b=>2), 3, "c") ==
        Dict(:a=>1, :b=>2, "c"=>3)
end

@testset "mutation" begin
    @testset for args in [
        ([1, 2, 3], 20, 2),
        (Dict(:a=>1, :b=>2), 10, :a),
    ]
        @test setindex!!(args...) === args[1]
    end
end

@testset "slices" begin
    @testset "$(typeof(x)) with $(src_idx)" for (x, src_idx) in [
        # Vector.
        (randn(2), (:,)),
        (randn(2), (1:2,)),
        # Matrix.
        (randn(2, 3), (:,)),
        (randn(2, 3), (:, 1)),
        (randn(2, 3), (:, 1:3)),
        # 3D array.
        (randn(2, 3, 4), (:, 1, :)),
        (randn(2, 3, 4), (:, 1:3, :)),
        (randn(2, 3, 4), (1, 1:3, :)),
    ]
        # Base case.
        @test @inferred(setindex!!(x, x[src_idx...], src_idx...)) === x

        # If we have `Colon` in the index, we replace this with other equivalent indices.
        if any(Base.Fix2(isa, Colon), src_idx)
            if is_linear_index(src_idx, x)
                # With range instead of `Colon`.
                @test @inferred(setindex!!(x, x[src_idx...], replace_colon_with_range_linear(src_idx, x)...)) === x
            else
                # With axis instead of `Colon`.
                @test @inferred(setindex!!(x, x[src_idx...], replace_colon_with_axis(src_idx, x)...)) === x
                # With range instead of `Colon`.
                @test @inferred(setindex!!(x, x[src_idx...], replace_colon_with_range(src_idx, x)...)) === x
                # With vectors instead of `Colon`.
                @test @inferred(setindex!!(x, x[src_idx...], replace_colon_with_vector(src_idx, x)...)) === x
                # With boolean index instead of `Colon`.
                @test @inferred(setindex!!(x, x[src_idx...], replace_colon_with_booleans(src_idx, x)...)) === x
            end
        end
    end
end

end  # module
