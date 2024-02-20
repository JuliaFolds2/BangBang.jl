# BangBang

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliafolds2.github.io/BangBang.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliafolds2.github.io/BangBang.jl/dev)
[![Codecov](https://codecov.io/gh/JuliaFolds2/BangBang.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaFolds2/BangBang.jl)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
![GitHub commits since latest release (branch)](https://img.shields.io/github/commits-since/JuliaFolds2/BangBang.jl/latest/master?style=social&logo=github)

BangBang.jl implements functions whose name ends with `!!`.  Those
functions provide a uniform interface for mutable and immutable data
structures.  Furthermore, those functions implement the "widening"
fallback for the case when the usual mutating function does not work (e.g.,
`push!!(Int[], 1.5)` creates a new array `Float64[1.5]`).

See the supported functions in the
[documentation](https://juliafolds2.github.io/BangBang.jl/dev)
