"""
    RegionGrid(
        geo :: Union{RectRegion,PolyRegion},
        lon :: Union{Vector{<:Real},AbstractRange{<:Real},
        lat :: Union{Vector{<:Real},AbstractRange{<:Real}
    ) -> ggrd :: RLinearMask

Creates a `RectGrid` or `PolyGrid` type based on the following arguments. This method is suitable for rectilinear grids of longitude/latitude output such as from Isca, or from satellite and reanalysis gridded datasets.

Arguments
=========
- `geo` : A GeoRegion of interest
- `lon` : A vector or `AbstractRange` containing the longitude points
- `lat` : A vector or `AbstractRange` containing the latitude points

Returns
=======
- `ggrd` : A `RectilinearGrid`
"""
RegionGrid(
    geo::GeoRegion, lon::AbstractRange{<:Real}, lat::AbstractRange{<:Real}
) = RegionGrid(geo,collect(lon),collect(lat))

function RegionGrid(
    geo :: Union{RectRegion,PolyRegion},
    lon :: Vector{FT},
    lat :: Vector{FT}
) where FT <: Real

    @info "$(modulelog()) - Creating a RectilinearGrid for the $(geo.name) GeoRegion"

    @debug "$(modulelog()) - Determining indices of longitude and latitude boundaries in the given dataset ..."

    nlon,nlat,iWE,iNS = bound2lonlat(geo.bound,lon,lat)

    mask = Array{FT,2}(undef,length(nlon),length(nlat))
    wgts = Array{FT,2}(undef,length(nlon),length(nlat))
    for ilat in eachindex(nlat), ilon in eachindex(nlon)
        ipnt = Point2(nlon[ilon],nlat[ilat])
        if in(ipnt,geo)
              mask[ilon,ilat] = 1
              wgts[ilon,ilat] = cosd.(nlat[ilat])
        else; mask[ilon,ilat] = NaN
              wgts[ilon,ilat] = 0
        end
    end

    return RLinearMask{FT}(nlon,nlat,iWE,iNS,mask,wgts)

end

"""
    RegionGrid(
        geo :: TiltRegion,
        lon :: Union{Vector{<:Real},AbstractRange{<:Real},
        lat :: Union{Vector{<:Real},AbstractRange{<:Real}
    ) -> ggrd :: RLinearMask

Creates a `RectGrid` or `PolyGrid` type based on the following arguments. This method is suitable for rectilinear grids of longitude/latitude output such as from Isca, or from satellite and reanalysis gridded datasets.

Arguments
=========
- `geo` : A GeoRegion of interest
- `lon` : A vector or `AbstractRange` containing the longitude points
- `lat` : A vector or `AbstractRange` containing the latitude points

Returns
=======
- `ggrd` : A `RectilinearGrid`
"""
function RegionGrid(
    geo :: TiltRegion,
    lon :: Vector{FT},
    lat :: Vector{FT}
) where FT <: Real

    @info "$(modulelog()) - Creating a RectilinearGrid for the $(geo.name) GeoRegion"

    @debug "$(modulelog()) - Determining indices of longitude and latitude boundaries in the given dataset ..."

    nlon,nlat,iWE,iNS = bound2lonlat(geo.bound,lon,lat)
    X,Y,_,_,θ = geo.tilt

    mask = Array{FT,2}(undef,length(nlon),length(nlat))
    wgts = Array{FT,2}(undef,length(nlon),length(nlat))

    @info "$(modulelog()) - Since the $(geo.name) GeoRegion is a TiltRegion, we need to defined a rotation as well ..."
    rotX = Array{FT,2}(undef,length(nlon),length(nlat))
    rotY = Array{FT,2}(undef,length(nlon),length(nlat))

    for ilat in eachindex(nlat), ilon in eachindex(nlon)
        ipnt = Point2(nlon[ilon],nlat[ilat])
        if in(ipnt,geo)
            mask[ilon,ilat] = 1
            ir = sqrt((nlon[ilon]-X)^2 + (nlat[ilat]-Y)^2)
            iθ = atand(nlat[ilat]-Y, nlon[ilon]-X) - θ
            rotX[ilon,ilat] = ir * cosd(iθ)
            rotY[ilon,ilat] = ir * sind(iθ)
            wgts[ilon,ilat] = cosd.(nlat[ilat])
        else
            mask[ilon,ilat] = NaN
            rotX[ilon,ilat] = NaN
            rotY[ilon,ilat] = NaN
            wgts[ilon,ilat] = 0
        end
    end

    return RLinearTilt{FT}(nlon,nlat,iWE,iNS,mask,wgts,rotX,rotY)

end

function bound2lonlat(
    gridbounds :: Vector{<:Real},
    rlon :: Vector{<:Real},
    rlat :: Vector{<:Real}
)

    N,S,E,W = gridbounds

    if rlon[2] > rlon[1]; EgW = true; else; EgW = false end
    if rlat[2] > rlat[1]; NgS = true; else; NgS = false end

    E = mod(E,360); W = mod(W,360); nlon = mod.(rlon,360);
    iN = argmin(abs.(rlat.-N)); iS = argmin(abs.(rlat.-S)); iW = argmin(abs.(nlon.-W));
    if E == W;
        if gridbounds[3] != gridbounds[4]
            if iW != 1; iE = iW - 1; else; iE = length(nlon); end
        else
            if EgW
                if iW > 1; iE = iW - 1; else; iE = length(rlon) end
            else
                if iW < length(rlon); iE = iW + 1; else; iE = 1 end
            end
        end
    else; iE = argmin(abs.(nlon.-E));
    end

    if !(E==W) || (gridbounds[3] == gridbounds[4])
        while mod(rlon[iW],360) < mod(W,360)
            if EgW
                iW += 1; if iW > length(rlon); iW = 1 end
            else
                iW -= 1; if iszero(iW); iW = length(rlon) end
            end
        end

        while mod(rlon[iE],360) > mod(E,360)
            if EgW
                iE -= 1; if iszero(iE); iE = length(rlon) end
            else
                iE += 1; if iE > length(rlon); iE = 1 end
            end
        end
    end

    while rlat[iS] < S
        if NgS; iS += 1; else; iS -= 1 end
    end

    while rlat[iN] > N
        if NgS; iN -= 1; else; iN += 1 end
    end

    if (NgS && (iN < iS)) || (!NgS && (iS < iN))
        error("$(modulelog()) - The bounds of the specified georegion do not contain any latitude points")
    end

    # Figure out how to ensure that bounds are respected
    # if (EgW && (iE < iW)) || (!EgW && (iW < iE))
    #     error("$(modulelog()) - The bounds of the specified georegion do not contain any longitude points")
    # end

    nlon = deepcopy(rlon)

    @info "$(modulelog()) - Creating vector of latitude indices to extract ..."
    if     iN < iS; iNS = vcat(iN:iS)
    elseif iS < iN; iNS = vcat(iS:iN)
    else;           iNS = [iN];
    end

    @info "$(modulelog()) - Creating vector of longitude indices to extract ..."
    if     iW < iE; iWE = vcat(iW:iE)
    elseif iW > iE || (iW == iE && E != W)
          iWE = vcat(iW:length(rlon),1:iE); nlon[1:(iW-1)] .+= 360
    else; iWE = [iW];
    end

    nlon = nlon[iWE]
    nlat = rlat[iNS]

    while maximum(nlon) > E; nlon .-= 360 end
    while minimum(nlon) < W; nlon .+= 360 end

    return nlon,nlat,iWE,iNS

end