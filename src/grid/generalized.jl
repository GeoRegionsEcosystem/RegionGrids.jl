"""
    RegionGrid(
        geo  :: GeoRegion,
        pnts :: Array{Point2{FT}};
        rotation :: Real = geo.θ
    ) where FT <: Real -> ggrd :: GeneralizedGrid

Creates a `GeneralTilt` type based on the following arguments. This method is more suitable for structured non-rectilinear (e.g., curvilinear) grids of longitude and latitude points, such as in the output of WRF.

Arguments
=========
- `geo` : A GeoRegion of interest.
- `pnts` : An array of `Point2` types containing the longitude/latitude points.

Keyword Arguments
=================
- `rotation` : Angle (in degrees) at which to "unrotate" the gridded data about the GeoRegion centroid and project into the X-Y cartesian coordinate system (in meters).

Returns
=======
- `ggrd` : A `GeneralTilt`.
"""
function RegionGrid(
    geo  :: GeoRegion,
    pnts :: Array{Point2{FT}};
    rotation :: Real = 0
) where FT <: Real

    @info "$(modulelog()) - Creating a GeneralizedGrid for the $(geo.name) GeoRegion"

    @debug "$(modulelog()) - Determining indices of longitude and latitude boundaries in the given dataset ..."

    nlon,nlat = size(pnts)
    iW = nlon; iE = 1
    iS = nlat; iN = 1

    for iilat = 1 : nlat, iilon = 1 : nlon
        if in(pnts[iilon,iilat],geo)
            iS = min(iS,iilat); iN = max(iN,iilat)
            iW = min(iW,iilon); iE = max(iE,iilon)
        end
    end

    Xc,Yc = geo.geometry.centroid

    iWE = iW:iE; nlon = length(iWE)
    iSN = iS:iN; nlat = length(iSN)

    lon  = zeros(nlon,nlat)
    lat  = zeros(nlon,nlat)
    ilon = zeros(nlon,nlat)
    ilat = zeros(nlon,nlat)
    mask = zeros(nlon,nlat)
    wgts = zeros(nlon,nlat)
    X = zeros(nlon,nlat)
    Y = zeros(nlon,nlat)

    for iilat = 1 : nlat, iilon = 1 : nlon
        iiWE = iWE[iilon]; ilon[iilon,iilat] = iiWE
        iiSN = iSN[iilat]; ilat[iilon,iilat] = iiSN
        lon[iilon,iilat] = pnts[iiWE,iiSN][1]
        if lon[iilon,iilat] > geo.E; lon[iilon,iilat] -= 360 end
        if lon[iilon,iilat] < geo.W; lon[iilon,iilat] += 360 end
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
            ir = haversine((lon[iilon,iilat],lat[iilon,iilat]),(Xc,Yc))
            iθ = atand(lat[iilon,iilat]-Yc,lon[iilon,iilat]-Xc) - (geo.θ - rotation)
            X[iilon,iilat] = ir * cosd(iθ)
            Y[iilon,iilat] = ir * sind(iθ)
        else
            X[iilon,iilat] = NaN
            Y[iilon,iilat] = NaN
        end
    end

    return GeneralizedGrid{FT}(lon,lat,ilon,ilat,mask,wgts,X,Y,rotation)

end