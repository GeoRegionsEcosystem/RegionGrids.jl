"""
    RegionGrid(
        geo  :: GeoRegion,
        pnts :: Array{Point2{FT}};
        rotation  :: Real = 0,
        sigdigits :: Int = 10
    ) where FT <: Real -> ggrd :: GeneralizedGrid

Creates a `GeneralizedGrid` type based on the following arguments. This method is more suitable for structured non-rectilinear (e.g., curvilinear) grids of longitude and latitude points, such as in the output of WRF.

Arguments
=========
- `geo` : A GeoRegion of interest.
- `pnts` : An array of `Point2(lon,lat)` types.

Keyword Arguments
=================
- `rotation` : Angle (in degrees) of rotation for the final "derotated" data about the GeoRegion centroid and projected into the X-Y cartesian coordinate system (in meters). A positive value relative to `geo.θ` will turn the final values about the centroid in the anti-clockwise direction. Default is 0.

Returns
=======
- `ggrd` : A `GeneralizedGrid`.
"""
function RegionGrid(
    geo  :: GeoRegion,
    pnts :: Array{Point2{FT}};
    rotation  :: Real = 0,
    sigdigits :: Int = 10
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
        lon[iilon,iilat] > geo.E ? lon[iilon,iilat] -= 360 : nothing
        lon[iilon,iilat] < geo.W ? lon[iilon,iilat] += 360 : nothing
        lat[iilon,iilat] = pnts[iiWE,iiSN][2]
        iipnt = pnts[iiWE,iiSN]
        X[iilon,iilat], Y[iilon,iilat] = derotatepoint(iipnt,geo,rotation=rotation)
        if in(iipnt,geo,sigdigits=sigdigits)
            mask[iilon,iilat] = 1
            wgts[iilon,iilat] = cosd.(lat[iilon,iilat])
        else
            mask[iilon,iilat] = NaN
            wgts[iilon,iilat] = NaN
        end
    end

    return GeneralizedGrid{FT}(lon,lat,ilon,ilat,mask,wgts,X,Y,rotation-geo.θ)

end