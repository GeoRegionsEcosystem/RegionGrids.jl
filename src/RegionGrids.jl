module RegionGrids

## Modules Used
using Dates
using GeometryBasics
using GeoRegions
using Logging
using PolygonOps

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

Abstract supertype for geographical region gridded information, with the following subtypes:
    
    RectGrid{FT<:Real} <: RegionGrid
    TiltGrid{FT<:Real} <: RegionGrid
    PolyGrid{FT<:Real} <: RegionGrid
    RegionMask{FT<:Real} <: RegionGrid
    VectorMask{FT<:Real} <: RegionGrid

Both `RectGrid`, `TiltGrid` and `PolyGrid` types contain the following fields:
* `grid` - A vector of `Int`s defining the gridpoint indices of the [N,S,E,W] points respectively
* `lon` - A vector of `Float`s defining the latitude vector describing the region
* `lat` - A vector of `Float`s defining the latitude vector describing the region
* `ilon` - A vector of `Int`s defining indices of the parent longitude vector describing the region
* `ilat` - A vector of `Int`s defining indices of the parent latitude vector describing the region
* `mask` - An array of 0s and 1s defining a non-rectilinear shape within a rectilinear grid where data is valid (only available in PolyGrid types)

A `TiltGrid` type will also contain the following fields:
* `rotX` - A vector of `Int`s defining indices of the parent longitude vector describing the region
* `rotY` - A vector of `Int`s defining indices of the parent latitude vector describing the region

A `RegionMask` type will contain the following fields:
* `lon` - An array of longitude points
* `lat` - An array of latitude points
* `mask` - An array of NaNs and 1s defining the region within the original field in which data points are valid
"""
abstract type RegionGrid end

abstract type RectilinearGrid <: RegionGrid end
abstract type GeneralizedGrid <: RegionGrid end
struct RectGrid{FT<:Real} <: RectilinearGrid
    grid :: Vector{Int}
     lon :: Vector{FT}
     lat :: Vector{FT}
    ilon :: Vector{Int}
    ilat :: Vector{Int}
    mask :: Array{FT,2}
    weights :: Array{FT,2}
end

struct PolyGrid{FT<:Real} <: RectilinearGrid
    grid :: Vector{Int}
     lon :: Vector{FT}
     lat :: Vector{FT}
    ilon :: Vector{Int}
    ilat :: Vector{Int}
    mask :: Array{FT,2}
    weights :: Array{FT,2}
end

struct TiltGrid{FT<:Real} <: RectilinearGrid
    grid :: Vector{Int}
     lon :: Vector{FT}
     lat :: Vector{FT}
    ilon :: Vector{Int}
    ilat :: Vector{Int}
    mask :: Array{FT,2}
    weights :: Array{FT,2}
    rotX :: Array{FT,2}
    rotY :: Array{FT,2}
end

struct RegionMask{FT<:Real} <: GeneralizedGrid
     lon :: Array{FT,2}
     lat :: Array{FT,2}
    mask :: Array{FT,2}
    weights :: Array{FT,2}
end

struct VectorMask{FT<:Real} <: GeneralizedGrid
     lon :: Vector{FT}
     lat :: Vector{FT}
    mask :: Vector{FT}
    olon :: Vector{FT}
    olat :: Vector{FT}
end

modulelog() = "$(now()) - RegionGrids.jl"

## Including other files in the module
include("grid.jl")
include("extract.jl")
include("show.jl")

end # module
