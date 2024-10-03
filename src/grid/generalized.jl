"""
    RegionGrid(
        geo  :: GeoRegion,
        pnts :: Array{Point2{FT}}
    ) where FT <: Real -> gmsk :: RegionMask

Creates a `RegionMask` type based on the following arguments. This method is more suitable for non-rectilinear grids of longitude and latitude points, such as in the output of WRF or CESM.

Arguments
=========
- `geo` : A GeoRegion of interest
- `pnts` : An array containing the longitude points

Returns
=======
- `gmsk` : A `RegionMask`
"""
function RegionGrid(
    geo  :: GeoRegion,
    pnts :: Array{Point2{FT}}
) where FT <: Real

    @info "$(modulelog()) - Creating a RegionMask for the $(geo.name) GeoRegion based on an array of longitude and latitude points"

    npnt = size(pnts)
    mask = zeros(npnt)
    wgts = zeros(npnt)
    lon  = zeros(npnt)
    lat  = zeros(npnt)

    for ii in eachindex(lon)
        lon[ii] = pnts[ii][1]
        lat[ii] = pnts[ii][2]
        if in(pnts[ii],geo)
            mask[ii] = 1
            wgts[ii] = cosd.(pnts[ii][2])
        else
            mask[ii] = NaN
            wgts[ii] = 0
        end
    end

    return RegionMask{FT}(lon,lat,mask,wgts)

end

"""
    VectorGrid(
        geo  :: GeoRegion,
        pnts :: Vector{Point2{FT}}
    ) where FT <: Real -> gmsk :: VectorMask

Creates a `VectorMask` type based on a vector of 

Arguments
=========
- `geo` : A GeoRegion of interest
- `pnts` : A `Vector` of `Float` Types, containing the longitude points

Returns
=======
- `gmsk` : A `VectorMask`
"""
function VectorGrid(
    geo  :: GeoRegion,
    pnts :: Vector{Point2{FT}}
) where FT <: Real

    @info "$(modulelog()) - Creating a RegionMask for the $(geo.name) GeoRegion based on an array of longitude and latitude points"

    npnt = length(pnts)
    mask = zeros(npnt)
    wgts = zeros(npnt)
    lon  = zeros(npnt)
    lat  = zeros(npnt)

    for ii in 1 : length(pnts)
        lon[ii] = pnts[ii][1]
        lat[ii] = pnts[ii][2]
        if in(pnts[ii],geo)
              mask[ii] = 1
              wgts[ii] = cosd.(pnts[ii][2])
        else; mask[ii] = NaN
              wgts[ii] = 0
        end
    end

    return VectorMask{FT}(lon,lat,mask,wgts)

end