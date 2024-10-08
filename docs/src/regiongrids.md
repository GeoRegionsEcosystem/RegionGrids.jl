# What is a RegionGrid?

A `RegionGrid` contains information that:
* Allows us to extract gridded lon-lat data for a given `GeoRegion` (see [GeoRegions.jl](https://github.com/GeoRegionsEcosystem/GeoRegions.jl)) of interest.
* Subset the relevant longitude/latitude vectors from the initial grid.
* Allows for easy spatial-averaging of extracted gridded lon-lat data, weighted by latitude.

```@docs
RegionGrid
```

The `RegionGrid` abstract type has three subtypes:
1. `RectilinearGrid` type, which is for the extraction of data on rectilinear lon-lat grids
2. `GeneralizedGrid` type, which is for the extraction of data on non-rectilinear lon-lat grids, such as a curvilinear grid.
3. `UnstructuredGrid` type, which is for the extraction of data on unstructured lon-lat grids such as a cubed-spherical grid, or an unstructured mesh.

Each of these types is in turn subdivided into **two** subtypes, (1) a `-Mask` type and (2) a `-Tilt` type. The `-Tilt` types are the same as the `-Mask` types, but with additional fields that specify the _rotation_ of fields.

More information can be found [here](/types).

```@docs
RectilinearGrid
GeneralizedGrid
UnstructuredGrid
```