module BangBangDataFramesExt
    using BangBang
    using Base: setindex!
    using DataFrames
    using DataFrames.Tables: Tables
    include("dataframes_impl.jl")
    BangBang.push!!(df::DataFrames.DataFrame, row) = df_append_rows!!(df, (row,))
    BangBang.append!!(df::DataFrames.DataFrame, source) = df_append!!(df, source)
    BangBang.copyappendable(df::DataFrames.AbstractDataFrame) = copy(df)
end