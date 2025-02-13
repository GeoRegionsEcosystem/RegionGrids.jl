"""
    RegionGrid(
        geo  :: GeoRegion,
        pnts :: Vector{Point2{FT}}
    ) where FT <: Real -> ggrd :: VectorMask

Creates a `VectorMask` type based on a vector of 

Arguments
=========
- `geo` : A GeoRegion of interest
- `pnts` : A `Vector` of `Float` Types, containing the longitude points

Returns
=======
- `ggrd` : A `VectorMask`
"""
function RegionGrid(
    geo  :: GeoRegion,
    pnts :: Vector{Point2{FT}}
) where FT <: Real

    @info "$(modulelog()) - Creating a RegionMask for the $(geo.name) GeoRegion based on an array of longitude and latitude points"

    Xc,Yc = centroid(geo.geometry.polygon)

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
        lon[ii] = pnts[ipnt[ii]][1]
        if lon[ii] > geo.E; lon[ii] -= 360 end
        if lon[ii] < geo.W; lon[ii] += 360 end
        lat[ii] = pnts[ipnt[ii]][2]
        wgts[ii] = cosd(pnts[ipnt[ii]][2])
        ir = haversine((lon[ii],lat[ii]),(Xc,Yc))
        iθ = atand(lat[ii]-Yc,lon[ii]-Xc) - geo.θ
        X[ii] = ir * cosd(iθ)
        Y[ii] = ir * sind(iθ)
    end

    return VectorTilt{FT}(lon,lat,ipnt,wgts,X,Y,geo.θ)

end