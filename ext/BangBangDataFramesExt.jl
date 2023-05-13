module BangBangDataFramesExt
@static if isdefined(Base, :get_extension)
    using BangBang
    using Base: setindex!
    using DataFrames
    using DataFrames.Tables: Tables
else
    using ..BangBang
    using ..Base: setindex!
    using ..DataFrames
    using ..DataFrames.Tables: Tables
end
    include("dataframes_impl.jl")
    BangBang.push!!(df::DataFrames.DataFrame, row) = df_append_rows!!(df, (row,))
    BangBang.append!!(df::DataFrames.DataFrame, source) = df_append!!(df, source)
    BangBang.copyappendable(df::DataFrames.AbstractDataFrame) = copy(df)
end
