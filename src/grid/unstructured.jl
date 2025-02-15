"""
    RegionGrid(
        geo  :: GeoRegion,
        pnts :: Vector{Point2{FT}};
        rotation :: Real = geo.θ
    ) where FT <: Real -> ggrd :: VectorMask

Creates a `VectorMask` type based on a vector of 

Arguments
=========
- `geo` : A GeoRegion of interest.
- `pnts` : A `Vector` of `Point2` Types, containing the longitude/latitude points.

Keyword Arguments
=================
- `rotation` : Angle (in degrees) of rotation for the final "derotated" data about the GeoRegion centroid and projected into the X-Y cartesian coordinate system (in meters). A positive value relative to `geo.θ` will turn the final values about the centroid in the anti-clockwise direction. Default is 0.

Returns
=======
- `ggrd` : A `VectorMask`.
"""
function RegionGrid(
    geo  :: GeoRegion,
    pnts :: Vector{Point2{FT}};
    rotation :: Real = 0
) where FT <: Real

    @info "$(modulelog()) - Creating a RegionMask for the $(geo.name) GeoRegion based on an array of longitude and latitude points"

    npnt = length(pnts)
    lon  = zeros(npnt)
    lat  = zeros(npnt)
    ipnt = zeros(npnt)
    wgts = zeros(npnt)
    X = zeros(npnt)
    Y = zeros(npnt)

    for ii in 1 : npnt
        if in(pnts[ii],geo); ipnt[ii] = ii; else; ipnt[ii] = NaN end
    end

    ipnt = ipnt[.!isnan.(ipnt)]; ipnt = Int.(ipnt)
    npnt = length(ipnt)

    for ii = 1 : npnt
        iipnt = pnts[ipnt[ii]]
        lon[ii] = iipnt[1]
        lon[ii] > geo.E ? lon[ii] -= 360 : nothing
        lon[ii] < geo.W ? lon[ii] += 360 : nothing
        lat[ii] = iipnt[2]
        wgts[ii] = cosd(iipnt[2])
        X[ii],Y[ii] = derotatepoint(iipnt,geo,rotation=rotation)
    end

    return VectorTilt{FT}(lon,lat,ipnt,wgts,X,Y,rotation-geo.θ)

end