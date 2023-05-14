using BenchmarkTools
SUITE = BenchmarkGroup()
bench_re = r"bench_(?<bname>.*)\.jl"
for file in readdir(@__DIR__)
    m = match(bench_re, file) 
    if !isnothing(m)
	SUITE[m[:bname]] = include(file)
    end
end
let suite = SUITE, params_file = "SUITE_tuning.json"
    if isfile(params_file)
        loadparams!(suite, BenchmarkTools.load(params_file)[1], :evals, :samples);    
    else
        tune!(suite)
        BenchmarkTools.save(params_file, params(suite));
    end
end

# results = run(SUITE, verbose = true, seconds = 5)
