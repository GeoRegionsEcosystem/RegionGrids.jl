"""
    extract(
        odata :: AbstractArray{<:Real},
        ggrd  :: RegionGrid
    ) -> Array{<:Real}

Extracts data from odata, an Array of dimension N (where N ∈ 2,3,4) that contains data of a Parent `GeoRegion`, into another Array of dimension N, containing _**only**_ within a sub `GeoRegion` we are interested in.

!!! warning
    Please ensure that the 1st dimension is longitude and 2nd dimension is latitude before proceeding. The order of the 3rd and 4th dimensions (when used), however, is not significant.

Arguments
=========
- `odata` : An array of dimension N containing gridded data in the region we are interesting in extracting from
- `ggrd` : A `RegionGrid` containing detailed information on what to extract
"""
function extract(
    odata :: AbstractArray{<:Real},
    ggrd  :: GeneralizedGrid
)

    mask  = ggrd.mask
	ndata = zeros(size(mask))
	for ii in eachindex(mask)
		ndata[ii] = odata[ii] * mask[ii]
	end

    return ndata

end

"""
    extract!(
        odata :: AbstractArray{<:Real},
        ndata :: AbstractArray{<:Real},
        ggrd  :: RegionGrid
    ) -> nothing

Extracts data from odata, an Array of dimension N (where N ∈ 2,3,4) that contains data of a Parent `GeoRegion`, into ndata, another Array of dimension N, containing _**only**_ within a sub `GeoRegion` we are interested in.

This allows for iterable in-place modification to save memory space and reduce allocations if the dimensions are fixed.

!!! warning
    Please ensure that the 1st dimension is longitude and 2nd dimension is latitude before proceeding. The order of the 3rd and 4th dimensions (when used), however, is not significant.

Arguments
=========
- `odata` : An array of dimension N containing gridded data in the region we are interesting in extracting from
- `ndata` : An array of dimension N meant as a placeholder for the extracted data to minimize allocations
- `ggrd` : A `RegionGrid` containing detailed information on what to extract
"""
function extract!(
    ndata :: AbstractArray{<:Real},
    odata :: AbstractArray{<:Real},
    ggrd  :: GeneralizedGrid
)

    mask  = ggrd.mask
    for ii in eachindex(mask)
        ndata[ii] = odata[ii] * mask[ii]
    end

    return

end