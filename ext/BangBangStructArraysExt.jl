module BangBangStructArraysExt
    using BangBang: BangBang
    using StructArrays: StructArrays
    if isdefined(StructArrays, :append!!)
        BangBang.append!!(xs::StructArrays.StructVector, ys) =
            StructArrays.append!!(xs, ys)
    else
        BangBang.append!!(xs::StructArrays.StructVector, ys) =
            StructArrays.grow_to_structarray!(xs, ys)
    end

    BangBang.push!!(xs::StructArrays.StructVector, ys...) = BangBang.append!!(xs, ys)
end
