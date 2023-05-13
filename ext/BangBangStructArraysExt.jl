module BangBangStructArraysExt
    using BangBang
    using StructArrays
    if isdefined(StructArrays, :append!!)
        BangBang.append!!(xs::StructArrays.StructVector, ys) =
            StructArrays.append!!(xs, ys)
    else
        BangBang.append!!(xs::StructArrays.StructVector, ys) =
            StructArrays.grow_to_structarray!(xs, ys)
    end

    BangBang.push!!(xs::StructArrays.StructVector, ys...) = append!!(xs, ys)
end
