"""
    extract(
        odata :: AbstractArray{<:Real},
        ggrd  :: RegionMask;
        crop  :: Bool = false
    ) -> Array{<:Real}

Extracts data from odata, an Array of dimension N (where N > 2) that contains data of a Parent `GeoRegion`, into another Array of dimension N.

!!! warning "Dimension Order"
    Please ensure that the 1st dimension is longitude and 2nd dimension is latitude.

Arguments
=========
- `odata` : An array of dimension N containing gridded data in the region we are interesting in extracting from
- `ggrd` : A `RegionGrid` containing detailed information on what to extract

Keyword Arguments
=================
- `crop` : If `true`, crop new array to fit extracted data to save size
"""
function extract(
    odata :: AbstractArray{<:Real},
    ggrd  :: RegionMask;
    crop  :: Bool = false
)

    mask = ggrd.mask; nlon,nlat = size(mask)
    dims = size(odata); ndims = length(dims)

    if ndims > 2
        ndata = zeros(nlon,nlat,dims[3:end]...)
        edims = map(x -> 1 : x, dims[3:end])
        for ilon in 1 : nlat, ilat in 1 : nlon
            ndata[ilon,ilat,edims...] = odata[ilon,ilat,edims...] * mask[glon,glat]
        end
    else
        ndata = zeros(nlon,nlat)
        for ilon in 1 : nlat, ilat in 1 : nlon
            ndata[ilon,ilat] = odata[ilon,ilat] * mask[glon,glat]
        end
    end

    if crop
        iNaN = .!isnan.(mask); ilon = sum(iNaN,dims=2); ilat = sum(iNaN,dims=1)
        blon = findfirst(.!iszero(ilon)); elon = findlast(.!iszero(ilon))
        blat = findfirst(.!iszero(ilat)); elat = findlast(.!iszero(ilat))
        if not2D
            ndata = ndata[blon:elon,blat:elat,edims...]
        else
            ndata = ndata[blon:elon,blat:elat]
        end
    end

    return ndata

end

"""
    extract!(
        odata :: AbstractArray{<:Real},
        ndata :: AbstractArray{<:Real},
        ggrd  :: RegionMask
    ) -> nothing

Extracts data from odata, an Array of dimension N (where N > 2) that contains data of a Parent `GeoRegion`, into ndata, another Array of dimension N, containing _**only**_ within a sub `GeoRegion` we are interested in.

This allows for iterable in-place modification to save memory space and reduce allocations if the dimensions are fixed.

!!! warning "Dimension Order"
    Please ensure that the 1st dimension is longitude and 2nd dimension is latitude

Arguments
=========
- `odata` : An array of dimension N containing gridded data in the region we are interesting in extracting from
- `ndata` : An array of dimension N meant as a placeholder for the extracted data to minimize allocations
- `ggrd` : A `RegionGrid` containing detailed information on what to extract
"""
function extract!(
    ndata :: AbstractArray{<:Real},
    odata :: AbstractArray{<:Real},
    ggrd  :: RegionMask
)

    mask = ggrd.mask; nlon,nlat = size(mask)
    dims = size(odata); ndims = length(dims)

    if ndims > 2
        edims = map(x -> 1 : x, dims[3:end])
        for ilon in 1 : nlat, ilat in 1 : nlon
            ndata[ilon,ilat,edims...] = odata[ilon,ilat,edims...] * mask[glon,glat]
        end
    else
        ndata = zeros(nlon,nlat)
        for ilon in 1 : nlat, ilat in 1 : nlon
            ndata[ilon,ilat] = odata[ilon,ilat] * mask[glon,glat]
        end
    end

    return

end