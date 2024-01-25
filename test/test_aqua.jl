module TestAqua

using Aqua
using BangBang
using Accessors
using Test

stale_deps = Base.VERSION >= v"1.9"
project_toml_formatting = stale_deps
Aqua.test_all(
    BangBang;
    ambiguities=(;exclude=[Base.get, Base.show],),
    stale_deps = false, #remove when Aqua.jl fixes https://github.com/JuliaTesting/Aqua.jl/issues/107
    project_toml_formatting = false  #remove when Aqua.jl fixes https://github.com/JuliaTesting/Aqua.jl/issues/105
)

# @testset "Compare test/Project.toml and test/environments/main/Project.toml" begin
#     @test Text(read(joinpath(@__DIR__, "Project.toml"), String)) ==
#           Text(read(joinpath(@__DIR__, "environments", "main", "Project.toml"), String))
# end

end  # module
