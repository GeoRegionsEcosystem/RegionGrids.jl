"""
    RegionGrid(
        geo  :: Union{RectRegion,PolyRegion},
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
    geo  :: Union{RectRegion,PolyRegion},
    pnts :: Vector{Point2{FT}}
) where FT <: Real

    @info "$(modulelog()) - Creating a RegionMask for the $(geo.name) GeoRegion based on an array of longitude and latitude points"

    _,_,E,W = geo.bound

    npnt = length(pnts)
    lon  = zeros(npnt)
    lat  = zeros(npnt)
    ipnt = zeros(npnt)
    wgts = zeros(npnt)

    for ii in 1 : npnt
        if in(pnts[ii],geo); ipnt[ii] = ii; else; ipnt[ii] = NaN end
    end

    ipnt = ipnt[.!isnan.(ipnt)]; ipnt = Int.(ipnt)
    npnt = length(ipnt)

    for ii = 1 : npnt
        lon[ii] = pnts[ipnt[ii]][1]
        if lon[ii] > E; lon[ii] -= 360 end
        if lon[ii] < W; lon[ii] += 360 end
        lat[ii] = pnts[ipnt[ii]][2]
        wgts[ii] = cosd(pnts[ipnt[ii]][2])
    end

    return VectorMask{FT}(lon,lat,ipnt,wgts)

end

"""
    RegionGrid(
        geo  :: TiltRegion,
        pnts :: Vector{Point2{FT}}
    ) where FT <: Real -> ggrd :: VectorTilt

Creates a `VectorTilt` type based on a vector of 

Arguments
=========
- `geo` : A GeoRegion of interest
- `pnts` : A `Vector` of `Float` Types, containing the longitude points

Returns
=======
- `ggrd` : A `VectorTilt`
"""
function RegionGrid(
    geo  :: TiltRegion,
    pnts :: Vector{Point2{FT}}
) where FT <: Real

    @info "$(modulelog()) - Creating a RegionMask for the $(geo.name) GeoRegion based on an array of longitude and latitude points"

    _,_,E,W = geo.bound
    X,Y,_,_,θ = geo.tilt

    npnt = length(pnts)
    lon  = zeros(npnt)
    lat  = zeros(npnt)
    ipnt = zeros(npnt)
    wgts = zeros(npnt)
    rotX = zeros(npnt)
    rotY = zeros(npnt)

    for ii in 1 : npnt
        if in(pnts[ii],geo); ipnt[ii] = ii; else; ipnt[ii] = NaN end
    end

    ipnt = ipnt[.!isnan.(ipnt)]; ipnt = Int.(ipnt)
    npnt = length(ipnt)

    for ii = 1 : npnt
        lon[ii] = pnts[ipnt[ii]][1]
        if lon[ii] > E; lon[ii] -= 360 end
        if lon[ii] < W; lon[ii] += 360 end
        lat[ii] = pnts[ipnt[ii]][2]
        wgts[ii] = cosd(pnts[ipnt[ii]][2])
        ir = sqrt((lon[ii]-X)^2 + (lat[ii]-Y)^2)
        iθ = atand(lat[ii]-Y, lon[ii]-X) - θ
        rotX[ii] = ir * cosd(iθ)
        rotY[ii] = ir * sind(iθ)
    end

    return VectorTilt{FT}(lon,lat,ipnt,wgts,rotX,rotY)

end