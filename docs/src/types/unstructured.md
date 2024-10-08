# Unstructured

The `UnstructuredGrid` type can be further subdivided into two different types based on the `GeoRegion` type:
* Mapping unstructured lon-lat data to a `RectRegion` or `PolyRegion` returns a `VectorMask` type.
* Mapping unstructured lon-lat data to a `TiltRegion` returns a `VectorTilt` type.

```@docs
VectorMask
VectorTilt
```