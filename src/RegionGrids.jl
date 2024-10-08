module RegionGrids

## Modules Used
using Dates
using GeoRegions
using Logging

import Base: show

using Reexport
@reexport using GeoRegions

## Exporting the following functions:
export
        RegionGrid,
        RectilinearGrid,  RLinearMask, RLinearTilt,
        GeneralizedGrid,  GeneralMask, GeneralTilt, 
        UnstructuredGrid, VectorMask,  VectorTilt,

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
abstract type RectilinearGrid <: RegionGrid end

"""
    RLinearMask <: RectilinearGrid

Information on a `RLinearMask` type that is extracted based on a `RectRegion` or `PolyRegion` GeoRegion type.
"""
struct RLinearMask{FT<:Real} <: RectilinearGrid
     lon :: Vector{FT}
     lat :: Vector{FT}
    ilon :: Vector{Int}
    ilat :: Vector{Int}
    mask :: Array{FT,2}
    weights :: Array{FT,2}
end

"""
    RLinearTilt <: RectilinearGrid

Information on a `RectilinearGrid` type that is extracted based on a `TiltRegion` type.

In addition to all the fields common to the `RectilinearGrid` abstract type, `TiltGrid`s type will also contain the following fields:
* `rotX` - An array of `Float`s, defining indices of the parent longitude vector describing the region
* `rotY` - An array of `Float`s, defining indices of the parent latitude vector describing the region
"""
struct RLinearTilt{FT<:Real} <: RectilinearGrid
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
    GeneralMask <: GeneralizedGrid

Information on a `GeneralizedGrid` type that is extracted based on arrays of longitude/latitude points.
"""
struct GeneralMask{FT<:Real} <: GeneralizedGrid
     lon :: Array{FT,2}
     lat :: Array{FT,2}
    ilon :: Array{Int}
    ilat :: Array{Int}
    mask :: Array{FT,2}
    weights :: Array{FT,2}
end

"""
    GeneralTilt <: GeneralizedGrid

Information on a `GeneralizedGrid` type that is extracted based on arrays of longitude/latitude points.

In addition to all the fields common to the `GeneralizedGrid` abstract type, `RegionTilt`s type will also contain the following fields:
* `rotX` - An array of `Float`s, defining indices of the parent longitude vector describing the region
* `rotY` - An array of `Float`s, defining indices of the parent latitude vector describing the region
"""
struct GeneralTilt{FT<:Real} <: GeneralizedGrid
     lon :: Array{FT,2}
     lat :: Array{FT,2}
    ilon :: Array{Int}
    ilat :: Array{Int}
    mask :: Array{FT,2}
    weights :: Array{FT,2}
    rotX :: Array{FT,2}
    rotY :: Array{FT,2}
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
abstract type UnstructuredGrid <: RegionGrid end

"""
    VectorMask <: UnstructuredGrid

Information on a `GeneralizedGrid` type that is extracted based on vectors of longitude and latitude points.
"""
struct VectorMask{FT<:Real} <: UnstructuredGrid
        lon :: Vector{FT}
        lat :: Vector{FT}
     ipoint :: Array{Int}
    weights :: Vector{FT}
end

"""
    VectorTilt <: UnstructuredGrid

Information on a `GeneralizedGrid` type that is extracted based on vectors of longitude and latitude points.

A `VectorTilt` type will also contain the following fields:
* `rotX` - A vector of `Float`s, defining indices of the parent longitude vector describing the region
* `rotY` - A vector of `Float`s, defining indices of the parent latitude vector describing the region
"""
struct VectorTilt{FT<:Real} <: UnstructuredGrid
        lon :: Vector{FT}
        lat :: Vector{FT}
     ipoint :: Array{Int}
    weights :: Vector{FT}
       rotX :: Vector{FT}
       rotY :: Vector{FT}
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
