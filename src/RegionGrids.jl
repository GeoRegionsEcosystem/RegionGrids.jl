module RegionGrids

## Modules Used
using Dates
using GeoRegions
using Logging

import Base: show
import GeoRegions: isgridinregion

using Reexport
@reexport using GeoRegions

## Exporting the following functions:
export
        RegionGrid,
        RectilinearGrid, RectGrid, PolyGrid, TiltGrid,
        GeneralizedGrid, RegionMask, VectorMask, VectorGrid,

        extract, extract!

## Abstract types
"""
    RegionGrid

Abstract supertype for geographical region gridded information.
"""
abstract type RegionGrid end

"""
    RectilinearGrid <: RegionGrid

A `RectilinearGrid` is a `RegionGrid` that is created based on rectilinear longitude/latitude grids. It has its own subtypes: `RectGrid`, `TiltGrid` and `PolyGrid`.

All `RectilinearGrid` types contain the following fields:
* `grid` - A vector of `Int`s, defining the gridpoint indices of the [N,S,E,W] points respectively
* `lon` - A vector of `Float`s, defining the latitude vector describing the region
* `lat` - A vector of `Float`s, defining the latitude vector describing the region
* `ilon` - A vector of `Int`s, defining indices of the parent longitude vector describing the region
* `ilat` - A vector of `Int`s, defining indices of the parent latitude vector describing the region
* `mask` - An array of NaNs and 1s, defining a non-rectilinear shape within a rectilinear grid where data is valid (only available in PolyGrid types)
* `weights` - An array of `Float`s, defining the latitude-weights of each valid point in the grid.
"""
abstract type RectilinearGrid <: RegionGrid end

"""
    RectGrid <: RegionGrid

Information on a `RectilinearGrid` type that is extracted based on a `RectRegion` type.
"""
struct RectGrid{FT<:Real} <: RectilinearGrid
     lon :: Vector{FT}
     lat :: Vector{FT}
    ilon :: Vector{Int}
    ilat :: Vector{Int}
    mask :: Array{FT,2}
    weights :: Array{FT,2}
end

"""
    PolyGrid <: RegionGrid

Information on a `RectilinearGrid` type that is extracted based on a `PolyRegion` type.
"""
struct PolyGrid{FT<:Real} <: RectilinearGrid
     lon :: Vector{FT}
     lat :: Vector{FT}
    ilon :: Vector{Int}
    ilat :: Vector{Int}
    mask :: Array{FT,2}
    weights :: Array{FT,2}
end

"""
    TiltGrid <: RegionGrid

Information on a `RectilinearGrid` type that is extracted based on a `TiltRegion` type.

In addition to all the fields common to the `RegionGrid` abstract type, `TiltGrid`s type will also contain the following fields:
* `rotX` - A vector of `Float`s, defining indices of the parent longitude vector describing the region
* `rotY` - A vector of `Float`s, defining indices of the parent latitude vector describing the region
"""
struct TiltGrid{FT<:Real} <: RectilinearGrid
     lon :: Vector{FT}
     lat :: Vector{FT}
    ilon :: Vector{Int}
    ilat :: Vector{Int}
    mask :: Array{FT,2}
    weights :: Array{FT,2}
    rotX :: Array{FT,2}
    rotY :: Array{FT,2}
end

"""
    GeneralizedGrid

A `GeneralizedGrid` is a `RegionGrid` that is created based on longitude/latitude grids that are **not** rectilinear - this can range from curvilinear grids to unstructured grids. It has its own subtypes: `RegionMask` and `VectorMask`.

All `GeneralizedGrid` type will contain the following fields:
* `lon` - An array of `Float`s, defining longitude points
* `lat` - An array of `Float`s, defining latitude points
* `mask` - An array of NaNs and 1s, defining the region within the original field in which data points are valid
* `weights` - An array of `Float`s, defining the latitude-weights of each valid point in the grid.
"""
abstract type GeneralizedGrid <: RegionGrid end

"""
    RegionMask <: GeneralizedGrid

Information on a `GeneralizedGrid` type that is extracted based on arrays of longitude/latitude points.
"""
struct RegionMask{FT<:Real} <: GeneralizedGrid
     lon :: Array{FT,2}
     lat :: Array{FT,2}
    mask :: Array{FT,2}
    weights :: Array{FT,2}
end

"""
    VectorMask <: GeneralizedGrid

Information on a `GeneralizedGrid` type that is extracted based on vectors of longitude and latitude points.

A `VectorMask` type will also contain the following fields:
* `olon` - A vector of `Float`s, defining indices of the original longitude vector describing the region
* `olat` - A vector of `Float`s, defining indices of the original latitude vector describing the region
"""
struct VectorMask{FT<:Real} <: GeneralizedGrid
     lon :: Vector{FT}
     lat :: Vector{FT}
    mask :: Vector{FT}
    weights :: Array{FT,2}
    olon :: Vector{FT}
    olat :: Vector{FT}
end

modulelog() = "$(now()) - RegionGrids.jl"

## Including other files in the module
include("grid/rectilinear.jl")
include("grid/generalized.jl")

include("extract/rectilinear.jl")
include("extract/generalized.jl")

include("show.jl")

end # module
