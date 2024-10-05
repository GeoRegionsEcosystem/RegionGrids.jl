# What is a RegionGrid?

A `RegionGrid` contains information that:
* Allows us to extract gridded lon-lat data for a given `GeoRegion` (see [GeoRegions.jl](https://github.com/GeoRegionsEcosystem/GeoRegions.jl)) of interest.
* Subset the relevant longitude/latitude vectors from the initial grid.
* Allows for easy spatial-averaging of extracted gridded lon-lat data, weighted by latitude.

```@docs
RegionGrid
```

## Types of RegionGrids

The `RegionGrid` abstract type has two subtypes:
1. `RectilinearGrid` type, which is for the extraction of data on rectilinear lon-lat grids
2. `GeneralizedGrid` type, which is for the extraction of data on non-rectilinear lon-lat grids

```@docs
RectilinearGrid
GeneralizedGrid
```

### The `Rectilinear` Grid

The `RectilinearGrid` type can be further subdivided into three different types based on the `GeoRegion` type:
* Mapping rectilinearly-gridded lon-lat data to a **`RectRegion`** gives a `RectGrid` type
* Mapping rectilinearly-gridded lon-lat data to a **`PolyRegion`** gives a `PolyGrid` type
* Mapping rectilinearly-gridded lon-lat data to a **`TiltRegion`** gives a `TiltGrid` type

```@docs
RectGrid
PolyGrid
TiltGrid
```

### The `GeneralizedGrid` Type

The `GeneralizedGrid` type can be further subdivided into two different types based on the `GeoRegion` type:
* Mapping generalized grid lon-lat data to a `RectRegion` or `PolyRegion` gives a `RegionMask` type
* Mapping rectilinearly-gridded lon-lat data to a **`TiltRegion`** gives a `RegionTilt` type

```@docs
RegionMask
RegionTilt
```