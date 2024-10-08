# What is a RegionGrid?

A `RegionGrid` contains information that:
* Allows us to extract gridded lon-lat data for a given `GeoRegion` (see [GeoRegions.jl](https://github.com/GeoRegionsEcosystem/GeoRegions.jl)) of interest.
* Subset the relevant longitude/latitude vectors from the initial grid.
* Allows for easy spatial-averaging of extracted gridded lon-lat data, weighted by latitude.

```@docs
RegionGrid
```

## Types of RegionGrids

The `RegionGrid` abstract type has three subtypes:
1. `RectilinearGrid` type, which is for the extraction of data on rectilinear lon-lat grids
2. `GeneralizedGrid` type, which is for the extraction of data on non-rectilinear lon-lat grids, such as a curvilinear grid.
3. `UnstructuredGrid` type, which is for the extraction of data on unstructured lon-lat grids such as a cubed-spherical grid, or an unstructured mesh.

```@docs
RectilinearGrid
GeneralizedGrid
UnstructuredGrid
```

Each of these types is in turn subdivided into **two** subtypes, (1) a `-Mask` type and (2) a `-Tilt` type. The `-Tilt` types are the same as the `-Mask` types, but with additional fields that specify the _rotation_ of fields.

### The `Rectilinear` Grid

The `RectilinearGrid` type can be further subdivided into three different types based on the `GeoRegion` type:
* Mapping rectilinearly-gridded lon-lat data to a `RectRegion` or `PolyRegion` returns a `RLinearMask` type.
* Mapping rectilinearly-gridded lon-lat data to a `TiltRegion` returns a `RLinearTilt` type.

```@docs
RLinearMask
RLinearTilt
```

### The `GeneralizedGrid` Type

The `GeneralizedGrid` type can be further subdivided into two different types based on the `GeoRegion` type:
* Mapping generalized gridded lon-lat data to a `RectRegion` or `PolyRegion` returns a `GeneralMask` type.
* Mapping generalized gridded lon-lat data to a `TiltRegion` returns a `GeneralTilt` type.

```@docs
GeneralMask
GeneralTilt
```

### The `UnstructuredGrid` Type

The `UnstructuredGrid` type can be further subdivided into two different types based on the `GeoRegion` type:
* Mapping unstructured lon-lat data to a `RectRegion` or `PolyRegion` returns a `VectorMask` type.
* Mapping unstructured lon-lat data to a `TiltRegion` returns a `VectorTilt` type.

```@docs
VectorMask
VectorTilt
```