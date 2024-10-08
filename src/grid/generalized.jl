"""
    RegionGrid(
        geo  :: Union{RectRegion,PolyRegion},
        pnts :: Array{Point2{FT}}
    ) where FT <: Real -> ggrd :: GeneralMask

Creates a `GeneralMask` type based on the following arguments. This method is more suitable for structured non-rectilinear (e.g., curvilinear) grids of longitude and latitude points, such as in the output of WRF.

Arguments
=========
- `geo` : A GeoRegion of interest
- `pnts` : An array of `Point2` types containing the longitude/latitude points

Returns
=======
- `ggrd` : A `GeneralMask`
"""
function RegionGrid(
    geo  :: Union{RectRegion,PolyRegion},
    pnts :: Array{Point2{FT}}
) where FT <: Real

    @info "$(modulelog()) - Creating a GeneralizedGrid for the $(geo.name) GeoRegion"

    _,_,E,W = geo.bound

    @debug "$(modulelog()) - Determining indices of longitude and latitude boundaries in the given dataset ..."

    nlon,nlat = size(pnts)
    iW = nlon; iE = 1
    iS = nlat; iN = 1

    for iilat = 1 : nlat, iilon = 1 : nlon
        if in(pnts[iilon,iilat],geo)
            iS = min(iS,iilon); iN = max(iN,iilon)
            iW = min(iW,iilat); iE = max(iE,iilat)
        end
    end

    iWE = iW:iE; nlon = length(iWE)
    iSN = iS:iN; nlat = length(iSN)

    lon  = zeros(nlon,nlat)
    lat  = zeros(nlon,nlat)
    ilon = zeros(nlon,nlat)
    ilat = zeros(nlon,nlat)
    mask = zeros(nlon,nlat)
    wgts = zeros(nlon,nlat)

    for iilat = 1 : nlat, iilon = 1 : nlon
        iiWE = iWE[iilon]; ilon[iilon,iilat] = iiWE
        iiSN = iSN[iilat]; ilat[iilon,iilat] = iiSN
        lon[iilon,iilat] = pnts[iiWE,iiSN][1]
        if lon[iilon,iilat] > E; lon[iilon,iilat] -= 360 end
        if lon[iilon,iilat] < W; lon[iilon,iilat] += 360 end
        lat[iilon,iilat] = pnts[iiWE,iiSN][2]
        if in(pnts[iiWE,iiSN],geo)
            mask[iilon,iilat] = 1
            wgts[iilon,iilat] = cosd.(lat[iilon,iilat])
        else
            mask[ii] = NaN
            wgts[ii] = 0
        end
    end

    return GeneralMask{FT}(lon,lat,ilon,ilat,mask,wgts)

end

"""
    RegionGrid(
        geo  :: TiltRegion,
        pnts :: Array{Point2{FT}}
    ) where FT <: Real -> ggrd :: GeneralTilt

Creates a `GeneralTilt` type based on the following arguments. This method is more suitable for structured non-rectilinear (e.g., curvilinear) grids of longitude and latitude points, such as in the output of WRF.

Arguments
=========
- `geo` : A GeoRegion of interest
- `pnts` : An array of `Point2` types containing the longitude/latitude points

Returns
=======
- `ggrd` : A `GeneralTilt`
"""
function RegionGrid(
    geo  :: TiltRegion,
    pnts :: Array{Point2{FT}}
) where FT <: Real

    @info "$(modulelog()) - Creating a GeneralizedGrid for the $(geo.name) GeoRegion"

    _,_,E,W = geo.bound
    X,Y,_,_,θ = geo.tilt

    @debug "$(modulelog()) - Determining indices of longitude and latitude boundaries in the given dataset ..."

    nlon,nlat = size(pnts)
    iW = nlon; iE = 1
    iS = nlat; iN = 1

    for iilat = 1 : nlat, iilon = 1 : nlon
        if in(pnts[iilon,iilat],geo)
            iS = min(iS,iilon); iN = max(iN,iilon)
            iW = min(iW,iilat); iE = max(iE,iilat)
        end
    end

    iWE = iW:iE; nlon = length(iWE)
    iSN = iS:iN; nlat = length(iSN)

    lon  = zeros(nlon,nlat)
    lat  = zeros(nlon,nlat)
    ilon = zeros(nlon,nlat)
    ilat = zeros(nlon,nlat)
    mask = zeros(nlon,nlat)
    wgts = zeros(nlon,nlat)
    rotX = zeros(nlon,nlat)
    rotY = zeros(nlon,nlat)

    for iilat = 1 : nlat, iilon = 1 : nlon
        iiWE = iWE[iilon]; ilon[iilon,iilat] = iiWE
        iiSN = iSN[iilat]; ilat[iilon,iilat] = iiSN
        lon[iilon,iilat] = pnts[iiWE,iiSN][1]
        if lon[iilon,iilat] > E; lon[iilon,iilat] -= 360 end
        if lon[iilon,iilat] < W; lon[iilon,iilat] += 360 end
        lat[iilon,iilat] = pnts[iiWE,iiSN][2]
        if in(pnts[iiWE,iiSN],geo)
            mask[iilon,iilat] = 1
            wgts[iilon,iilat] = cosd.(lat[iilon,iilat])
        else
            mask[iilon,iilat] = NaN
            wgts[iilon,iilat] = 0
        end
    end

    for iilat = 1 : nlat, iilon = 1 : nlon
        iiWE = iWE[iilon]
        iiSN = iSN[iilat]
        if in(pnts[iiWE,iiSN],geo)
            ir = sqrt((lon[iilon,iilat]-X)^2 + (lat[iilon,iilat]-Y)^2)
            iθ = atand(lat[iilon,iilat]-Y, lon[iilon,iilat]-X) - θ
            rotX[iilon,iilat] = ir * cosd(iθ)
            rotY[iilon,iilat] = ir * sind(iθ)
        else
            rotX[iilon,iilat] = NaN
            rotY[iilon,iilat] = NaN
        end
    end

    return GeneralTilt{FT}(lon,lat,ilon,ilat,mask,wgts,rotX,rotY)

end