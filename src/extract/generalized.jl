"""
    extract(
        odata :: AbstractArray{<:Real},
        ggrd  :: GeneralizedGrid
    ) -> Array{<:Real}

Extracts data from odata, an Array that contains data of a Parent `GeoRegion`, into another Array of dimension N, containing _**only**_ within a sub `GeoRegion` we are interested in.

!!! warning
    Please ensure that the 1st dimension is longitude and 2nd dimension is latitude before proceeding. The order of the 3rd and 4th dimensions (when used), however, is not significant.

Arguments
=========
- `odata` : An array of dimension N containing gridded data in the region we are interesting in extracting from.
- `ggrd` : A `RegionGrid` containing detailed information on what to extract.
"""
function extract(
    odata :: AbstractArray{<:Real},
    ggrd  :: GeneralizedGrid
)

    ilon = ggrd.ilon; ilat = ggrd.ilat
    nlon,nlat = size(ggrd.ilon)
    dims = size(odata); not2D = length(dims) > 2

    if not2D
        ndata = zeros(nlon,nlat,dims[3:end]...)
        edims = map(x -> 1 : x, dims[3:end])
        for glat in 1 : nlat, glon in 1 : nlon
            ndata[glon,glat,edims...] = 
            odata[ilon[glon,glat],ilat[glon,glat],edims...] * ggrd.mask[glon,glat]
        end
    else
        ndata = zeros(nlon,nlat)
        for glat in 1 : nlat, glon in 1 : nlon
            ndata[glon,glat] = 
            odata[ilon[glon,glat],ilat[glon,glat]] * ggrd.mask[glon,glat]
        end
    end

    return ndata

end

"""
    extract!(
        ndata :: AbstractArray{<:Real},
        odata :: AbstractArray{<:Real},
        ggrd  :: GeneralizedGrid
    ) -> nothing

Extracts data from odata, an Array of dimension N (where N ∈ 2,3,4) that contains data of a Parent `GeoRegion`, into ndata, another Array of dimension N, containing _**only**_ within a sub `GeoRegion` we are interested in.

This allows for iterable in-place modification to save memory space and reduce allocations if the dimensions are fixed.

!!! warning
    Please ensure that the 1st dimension is longitude and 2nd dimension is latitude before proceeding. The order of the 3rd and 4th dimensions (when used), however, is not significant.

Arguments
=========
- `ndata` : An array of dimension N meant as a placeholder for the extracted data to minimize allocations.
- `odata` : An array of dimension N containing gridded data in the region we are interesting in extracting from.
- `ggrd` : A `RegionGrid` containing detailed information on what to extract.
"""
function extract!(
    ndata :: AbstractArray{<:Real},
    odata :: AbstractArray{<:Real},
    ggrd  :: GeneralizedGrid
)

    ilon = ggrd.ilon; nlon = length(ggrd.ilon)
    ilat = ggrd.ilat; nlat = length(ggrd.ilat)
    dims = size(odata); not2D = length(dims) > 2

    if not2D
        edims = map(x -> 1 : x, dims[3:end])
        for glat in 1 : nlat, glon in 1 : nlon
            ndata[glon,glat,edims...] = 
            odata[ilon[glon,glat],ilat[glon,glat],edims...] * ggrd.mask[glon,glat]
        end
    else
        for glat in 1 : nlat, glon in 1 : nlon
            ndata[glon,glat] = 
            odata[ilon[glon,glat],ilat[glon,glat]] * ggrd.mask[glon,glat]
        end
    end

    return

end