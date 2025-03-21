"""
    RegionGrid(
        geo  :: GeoRegion,
        pnts :: Vector{Point2{FT}};
        rotation  :: Real = 0,
        sigdigits :: Int = 10
    ) where FT <: Real -> ggrd :: UnstructuredGrid

Creates a `UnstructuredGrid` type. This method is more suitable for unstructured grids and mesh grid of longitude and latitude points, such as in the output of CESM2 when it is run in the cubed-sphere configuration.

Arguments
=========
- `geo` : A GeoRegion of interest.
- `pnts` : A `Vector` of `Point2(lon,lat)` types.

Keyword Arguments
=================
- `rotation` : Angle (in degrees) of rotation for the final "derotated" data about the GeoRegion centroid and projected into the X-Y cartesian coordinate system (in meters). A positive value relative to `geo.θ` will turn the final values about the centroid in the anti-clockwise direction. Default is 0.

Returns
=======
- `ggrd` : A `UnstructuredGrid`.
"""
function RegionGrid(
    geo  :: GeoRegion,
    pnts :: Vector{Point2{FT1}};
    rotation :: Real = 0,
    sigdigits :: Int = 10,
    FT2 = Float64
) where FT1 <: Real

    @info "$(modulelog()) - Creating an UnstructuredGrid for the $(geo.name) GeoRegion based on an array of longitude and latitude points"

    flush(stderr)

    npnt = length(pnts)
    lon  = zeros(FT1,npnt)
    lat  = zeros(FT1,npnt)
    ipnt = zeros(Int,npnt)

    for ii in 1 : npnt
        ipnt[ii] = in(pnts[ii],geo,sigdigits=sigdigits) ? ii : 0
    end

    ipnt = ipnt[.!iszero.(ipnt)]; ipnt = Int.(ipnt)
    npnt = length(ipnt)

    lon  = zeros(FT1,npnt)
    lat  = zeros(FT1,npnt)
    wgts = zeros(FT2,npnt)
    X    = zeros(FT2,npnt)
    Y    = zeros(FT2,npnt)

    for ii = 1 : npnt
        iipnt = pnts[ipnt[ii]]
        lon[ii] = iipnt[1]
        lon[ii] > geo.E ? lon[ii] -= 360 : nothing
        lon[ii] < geo.W ? lon[ii] += 360 : nothing
        lat[ii] = iipnt[2]
        wgts[ii] = cosd(iipnt[2])
        X[ii],Y[ii] = derotatepoint(iipnt,geo,rotation=rotation)
    end

    return UnstructuredGrid{FT1,FT2}(lon,lat,ipnt,wgts,X,Y,rotation-geo.θ)

end