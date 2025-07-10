"""
    extract(
        odata :: AbstractVector{<:Real},
        ggrd  :: UnstructuredGrid
    ) -> Array{<:Real}

Extracts data from odata, an Array that contains data of a Parent `GeoRegion`, into another Array of dimension N, containing _**only**_ within a sub `GeoRegion` we are interested in.

!!! warning
    Please ensure that the 1st dimension is longitude and 2nd dimension is latitude before proceeding. The order of the 3rd and 4th dimensions (when used), however, is not significant.

Arguments
=========
- `odata` : An array of dimension N containing gridded data in the region we are interesting in extracting from.
- `ggrd` : A. `UnstructuredGrid` containing detailed information on what to extract.
"""
function extract(
    odata :: AbstractArray{FT},
    ggrd  :: UnstructuredGrid
) where FT <: Real

    ipnts = ggrd.ipoint; npnt = length(ipnts)
    dims = size(odata); not1D = length(dims) > 1

    if not1D
        ndata = zeros(FT,npnt,dims[2:end]...)
        edims = map(x -> 1 : x, dims[2:end])
        for ipnt in 1 : npnt
            ndata[ipnt,edims...] = odata[ipnts[ipnt],edims...]
        end
    else
        ndata = zeros(FT,npnt)
        for ipnt in 1 : npnt
            ndata[ipnt] = odata[ipnts[ipnt]]
        end
    end

    return ndata

end

"""
    extract!(
        ndata :: AbstractVector{<:Real},
        odata :: AbstractVector{<:Real},
        ggrd  :: UnstructuredGrid
    ) -> nothing

Extracts data from odata, an Array of dimension N (where N ∈ 2,3,4) that contains data of a Parent `GeoRegion`, into ndata, another Array of dimension N, containing _**only**_ within a sub `GeoRegion` we are interested in.

This allows for iterable in-place modification to save memory space and reduce allocations if the dimensions are fixed.

!!! warning
    Please ensure that the 1st dimension is longitude and 2nd dimension is latitude before proceeding. The order of the 3rd and 4th dimensions (when used), however, is not significant.

Arguments
=========
- `ndata` : An array of dimension N meant as a placeholder for the extracted data to minimize allocations.
- `odata` : An array of dimension N containing gridded data in the region we are interesting in extracting from.
- `ggrd` : A `UnstructuredGrid` containing detailed information on what to extract.
"""
function extract!(
    ndata :: AbstractArray{<:Real},
    odata :: AbstractArray{<:Real},
    ggrd  :: UnstructuredGrid
)

    ipnts = ggrd.ipoint; npnt = length(ipnts)
    dims = size(odata); not1D = length(dims) > 1

    if not1D
        edims = map(x -> 1 : x, dims[2:end])
        for ipnt in 1 : npnt
            ndata[ipnt,edims...] = odata[ipnts[ipnt],edims...]
        end
    else
        ndata = zeros(npnt)
        for ipnt in 1 : npnt
            ndata[ipnt] = odata[ipnts[ipnt]]
        end
    end

    return

end