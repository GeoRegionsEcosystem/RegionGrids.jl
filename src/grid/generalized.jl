"""
    RegionGrid(
        geo :: GeoRegion,
        lon :: Array{<:Real,2},
        lat :: Array{<:Real,2}
    ) -> RegionGrid

Creates a `RegionMask` type based on the following arguments. This method is more suitable for non-rectilinear grids of longitude and latitude points, such as in the output of WRF or CESM.

Arguments
=========

- `geo` : A GeoRegion of interest
- `lon` : An array containing the longitude points
- `lat` : An array containing the latitude points
"""
function RegionGrid(
    geo :: GeoRegion,
    lon :: Array{<:Real,2},
    lat :: Array{<:Real,2}
)

    @info "$(modulelog()) - Creating a RegionMask for the $(geo.name) GeoRegion based on an array of longitude and latitude points"

    if eltype(lon) <: AbstractFloat
        FT = eltype(lon)
    end

    if size(lon) != size(lat)
        error("$(modulelog()) - The size of the longitude and latitude arrays are not the same.")
    end

    mask = zeros(size(lon))
    wgts = zeros(size(lon))

    for ii in eachindex(lon)
        ipnt = Point2(lon[ii],lat[ii])
        if in(ipnt,geo)
              mask[ii] = 1
              wgts[ii] = cosd.(lat[ii])
        else; mask[ii] = NaN
              wgts[ii] = 0
        end
    end

    return RegionMask{FT}(lon,lat,mask,wgts)

end

function VectorGrid(
    geo :: GeoRegion,
    lon :: Vector{<:Real},
    lat :: Vector{<:Real}
)

    @info "$(modulelog()) - Creating a RegionMask for the $(geo.name) GeoRegion based on an array of longitude and latitude points"

    if eltype(lon) <: AbstractFloat
        FT = eltype(lon)
    end

    if length(lon) != length(lat)
        error("$(modulelog()) - The size of the longitude and latitude arrays are not the same.")
    end

    mask = zeros(length(lon))

    for ii in eachindex(lon)
        ipnt = Point2(lon[ii],lat[ii])
        if in(ipnt,geo)
              mask[ii] = 1
        else; mask[ii] = NaN
        end
    end
    jj = .!isnan.(mask)

    return VectorMask{FT}(lon,lat,mask,lon[jj],lat[jj])

end