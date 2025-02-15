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

Abstract supertype for geographical region gridded information. All `RegionGrids` will contain the following fields:
* `lon` - A Vector or Matrix of `Float`s, defining the longitude grids describing the region.
* `lat` - A Vector or Matrix of `Float`s, defining the latitude grids describing the region.
* `weights` - An Vector or Matrix of `Float`s, defining the latitude-weights of each valid point in the grid. Will be NaN if outside the bounds of the GeoRegion used to define this RectilinearGrid.
* `X` - A Vector or Matrix of `Float`s, defining the X-coordinates (in meters) of each point in the "derotated" RegionGrid about the centroid for the shape of the GeoRegion.
* `Y` - A Vector or Matrix of `Float`s, defining the Y-coordinates (in meters) of each point in the "derotated" RegionGrid about the centroid for the shape of the GeoRegion.
* `θ` - A `Float` storing the information on the angle (in degrees) about which the data was rotated in the anti-clockwise direction. Mathematically, it is `rotation - geo.θ`.
"""
abstract type RegionGrid end

"""
    RectilinearGrid <: RegionGrid

A `RectilinearGrid` is a `RegionGrid` that is created based on rectilinear longitude/latitude grids. It has its own subtypes: `RectGrid`, `TiltGrid` and `PolyGrid`.

All `RectilinearGrid` types contain the following fields:
* `lon` - A Vector of `Float`s, defining the longitude vector describing the region.
* `lat` - A Vector of `Float`s, defining the latitude vector describing the region.
* `ilon` - A Vector of `Int`s, defining the indices used to extract the longitude vector from the input longitude vector.
* `ilat` - A Vector of `Int`s, defining the indices used to extract the latitude vector from the input latitude vector.
* `mask` - An Array of NaNs and 1s, defining the gridpoints in the RegionGrid where the data is valid.
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
* `lon` - A Matrix of `Float`s, defining the longitudes for each point in the RegionGrid that describe the region.
* `lat` - A Matrix of `Float`s, defining the latitude for each point in the RegionGrid that describe the region.
* `ilon` - A Vector of `Int`s, defining the indices used to extract the longitude vector from the input longitude vector.
* `ilat` - A Vector of `Int`s, defining the indices used to extract the latitude vector from the input latitude vector.
* `mask` - An Array of NaNs and 1s, defining the gridpoints in the RegionGrid where the data is valid.
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
* `lon` - A vector of `Float`s, defining the longitudes for each point in the RegionGrid that describe the region.
* `lat` - A vector of `Float`s, defining the latitude for each point in the RegionGrid that describe the region.
* `ipoint` - A Vector of `Int`s, defining the indices of the valid points from the original unstructured grid that were extracted into the RegionGrid.
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
