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

    glon = ggrd.lon[:]
    glat = ggrd.lat[:]

    gx = cosd.(glon) .* cosd.(glat)
    gy = sind.(glon) .* cosd.(glat)
    gz = sind.(glat)

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