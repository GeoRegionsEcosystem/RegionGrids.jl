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
    pnts :: Array{Point2{FT1}};
    rotation  :: Real = 0,
    sigdigits :: Int = 10,
    FT2 = Float64
) where FT1 <: Real

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

    lon  = zeros(FT1,nlon,nlat)
    lat  = zeros(FT1,nlon,nlat)
    ilon = zeros(Int,nlon,nlat)
    ilat = zeros(Int,nlon,nlat)
    mask = zeros(FT2,nlon,nlat) * NaN
    wgts = zeros(FT2,nlon,nlat) * NaN
    X    = zeros(FT2,nlon,nlat)
    Y    = zeros(FT2,nlon,nlat)

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
        end
    end

    return GeneralizedGrid{FT1,FT2}(lon,lat,ilon,ilat,mask,wgts,X,Y,rotation-geo.θ)

end