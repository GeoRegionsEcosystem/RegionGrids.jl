module RegionGrids

## Modules Used
using Dates
using Distances
using GeometryOps
using GeoRegions
using Logging

import Base: show

## Exporting the following functions:
export
        RegionGrid, RectilinearGrid, GeneralizedGrid, UnstructuredGrid,

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
* `lon` - A vector of `Float`s, defining the latitude vector describing the region
* `lat` - A vector of `Float`s, defining the latitude vector describing the region
* `mask` - An array of NaNs and 1s, defining a non-rectilinear shape within a rectilinear grid where data is valid (only available in PolyGrid types)
* `weights` - An array of `Float`s, defining the latitude-weights of each valid point in the grid.
"""
struct RectilinearGrid{FT<:Real} <: RegionGrid
        lon :: Vector{FT}
        lat :: Vector{FT}
       ilon :: Vector{Int}
       ilat :: Vector{Int}
       mask :: Array{FT,2}
    weights :: Array{FT,2}
          X :: Array{FT,2}
          Y :: Array{FT,2}
          θ :: FT
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
struct GeneralizedGrid{FT<:Real} <: RegionGrid
        lon :: Array{FT,2}
        lat :: Array{FT,2}
       ilon :: Array{Int}
       ilat :: Array{Int}
       mask :: Array{FT,2}
    weights :: Array{FT,2}
          X :: Array{FT,2}
          Y :: Array{FT,2}
          θ :: FT
end

"""
    UnstructuredGrid

A `UnstructuredGrid` is a `RegionGrid` that is created based on an unstructured grid often used in cubed-sphere or unstructured-mesh grids.

All `UnstructuredGrid` type will contain the following fields:
* `lon` - A vector of `Float`s, defining longitude points
* `lat` - A vector of `Float`s, defining latitude points
* `mask` - A vector of NaNs and 1s, defining the region within the original field in which data points are valid
* `weights` - A vector of `Float`s, defining the latitude-weights of each valid point in the grid.
"""
struct UnstructuredGrid{FT<:Real} <: RegionGrid
        lon :: Vector{FT}
        lat :: Vector{FT}
     ipoint :: Array{Int}
    weights :: Vector{FT}
          X :: FT
          Y :: FT
          θ :: FT
end

modulelog() = "$(now()) - RegionGrids.jl"

## Including other files in the module
include("grid/rectilinear.jl")
include("grid/generalized.jl")
include("grid/unstructured.jl")

include("extract/rectilinear.jl")
include("extract/generalized.jl")
include("extract/unstructured.jl")

include("show.jl")

end # module
