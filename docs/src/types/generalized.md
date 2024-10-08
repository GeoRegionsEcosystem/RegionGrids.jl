# Generalized

The `GeneralizedGrid` type can be further subdivided into two different types based on the `GeoRegion` type:
* Mapping generalized gridded lon-lat data to a `RectRegion` or `PolyRegion` returns a `GeneralMask` type.
* Mapping generalized gridded lon-lat data to a `TiltRegion` returns a `GeneralTilt` type.

```@docs
GeneralMask
GeneralTilt
```