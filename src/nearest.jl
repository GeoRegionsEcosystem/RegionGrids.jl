"""
    nearest(
        pnt  :: Point2,
        ggrd :: RegionGrid;
        n    :: Int = 1
    ) -> Union{Int, Array{Int}}

Finds the nearest `n` grid points to the given point `pnt` in a given RegionGrid `ggrd`. If `n` is 1, it returns the index of the nearest grid point. Otherwise, it returns an array of indices for the `n` nearest grid points.

Arguments
=========
- `pnt` : A `Point2` representing the location for which to find nearest grid points.
- `ggrd` : A `RegionGrid` containing detailed information on the grid.
- `n` : An integer specifying the number of nearest grid points to find.
"""
function nearest(
    pnt  :: Point2,
    ggrd :: RegionGrid;
    n    :: Int = 1
)

    gx,gy,gz = coarsegrid(ggrd)

    plon,plat = pnt[1],pnt[2]
    px = cosd.(plon) * cosd.(plat)
    py = sind.(plon) * cosd.(plat)
    pz = sind.(plat)

    if isone(n)
        return argmin(abs.((gx.-px).^2 .+ (gy.-py).^2 .+ (gz.-pz).^2))
    else
        return findall(≤(n),sortperm(abs.((gx.-px).^2 .+ (gy.-py).^2 .+ (gz.-pz).^2)))
    end

end

"""
    nearest(
        fgrd :: RegionGrid,
        cgrd :: RegionGrid
    ) -> Array{Int}

For each point on a high-resolution RegionGrid `fgrd`, find the index of the closest grid-point on a lower-resolution RegionGrid `cgrd`.

Arguments
=========
- `fgrd` : A `RegionGrid` containing the high-resolution grid points.
- `cgrd` : A `RegionGrid` containing the lower-resolution grid points.
"""
function nearest(
    ggrdf :: RectilinearGrid,
    ggrdc :: RegionGrid
)

    xc,yc,zc = coarsegrid(ggrdc)

    lonf = ggrdf.lon; nlon = length(lonf)
    latf = ggrdf.lat; nlat = length(latf)

    imat = zeros(Int,nlon,nlat)
    for ilat = 1 : nlat, ilon = 1 : nlon
        ix = cosd.(lonf[ilon]) .* cosd.(latf[ilat])
        iy = sind.(lonf[ilon]) .* cosd.(latf[ilat])
        iz = sind.(latf[ilat])
        imat[ilon,ilat] = argmin(abs.((xc.-ix).^2 .+ (yc.-iy).^2 .+ (zc.-iz).^2))
    end

    return imat

end

function nearest(
    ggrdf :: GeneralizedGrid,
    ggrdc :: RegionGrid
)

    xc,yc,zc = coarsegrid(ggrdc)

    lonf = ggrdf.lon
    latf = ggrdf.lat
    nlon,nlat = size(lonf)

    imat = zeros(Int,nlon,nlat)
    for ilat = 1 : nlat, ilon = 1 : nlon
        ix = cosd.(lonf[ilon,ilat]) .* cosd.(latf[ilon,ilat])
        iy = sind.(lonf[ilon,ilat]) .* cosd.(latf[ilon,ilat])
        iz = sind.(latf[ilon,ilat])
        imat[ilon,ilat] = argmin(abs.((xc.-ix).^2 .+ (yc.-iy).^2 .+ (zc.-iz).^2))
    end

    return imat

end

function nearest(
    ggrdf :: UnstructuredGrid,
    ggrdc :: RegionGrid
)

    xc,yc,zc = coarsegrid(ggrdc)

    lonf = ggrdf.lon
    latf = ggrdf.lat
    npnt = length(lonf)

    imat = zeros(Int,npnt)
    for ipnt = 1 : npnt
        ix = cosd.(lonf[ipnt]) .* cosd.(latf[ipnt])
        iy = sind.(lonf[ipnt]) .* cosd.(latf[ipnt])
        iz = sind.(latf[ipnt])
        imat[ipnt] = argmin(abs.((xc.-ix).^2 .+ (yc.-iy).^2 .+ (zc.-iz).^2))
    end

    return imat

end

function coarsegrid(
    ggrd :: RectilinearGrid
)

    lon = ggrd.lon; nlon = length(lon)
    lat = ggrd.lat; nlat = length(lat)

    xc = zeros(nlon,nlat)
    yc = zeros(nlon,nlat)
    zc = zeros(nlon,nlat)

    for ilat = 1 : nlat, ilon = 1 : nlon
        xc[ilon,ilat] = cosd.(lon[ilon]) * cosd.(lat[ilat])
        yc[ilon,ilat] = sind.(lon[ilon]) * cosd.(lat[ilat])
        zc[ilon,ilat] = sind.(lat[ilat])
    end

    return xc[:], yc[:], zc[:]

end 

function coarsegrid(
    ggrd :: Union{GeneralizedGrid,UnstructuredGrid}
)
    lon = ggrd.lon[:]
    lat = ggrd.lat[:]

    xc = cosd.(lon) .* cosd.(lat)
    yc = sind.(lon) .* cosd.(lat)
    zc = sind.(lat)

    return xc, yc, zc

end 