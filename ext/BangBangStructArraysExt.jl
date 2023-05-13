module BangBangStructArraysExt
@static if isdefined(Base, :get_extension)
    using BangBang: BangBang
    using StructArrays: StructArrays
else
    using ..BangBang: BangBang
    using ..StructArrays: StructArrays
end
    if isdefined(StructArrays, :append!!)
        BangBang.append!!(xs::StructArrays.StructVector, ys) =
            StructArrays.append!!(xs, ys)
    else
        BangBang.append!!(xs::StructArrays.StructVector, ys) =
            StructArrays.grow_to_structarray!(xs, ys)
    end

    BangBang.push!!(xs::StructArrays.StructVector, ys...) = BangBang.append!!(xs, ys)
end
