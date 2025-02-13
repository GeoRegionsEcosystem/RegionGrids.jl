function show(io::IO, ggrd::RectilinearGrid)
	nlon = length(ggrd.ilon)
	nlat = length(ggrd.ilat)
    print(
		io,
		"The RLinearMask Grid type has the following properties:\n",
		"    Longitude Indices     (ilon) : ", ggrd.ilon, '\n',
		"    Latitude Indices      (ilat) : ", ggrd.ilat, '\n',
		"    Longitude Points       (lon) : ", ggrd.lon,  '\n',
		"    Latitude Points        (lat) : ", ggrd.lat,  '\n',
		"    Rotated X Coordinates    (X)",
		"    Rotated Y Coordinates    (Y)",
		"    Rotation (°)             (θ) : ", ggrd.θ,  '\n',
		"    RegionGrid Mask       (mask)", '\n',
		"    RegionGrid Weights (weights)", '\n',
		"    RegionGrid Size              : $(nlon) lon points x $(nlat) lat points\n",
		"    RegionGrid Validity		  : $(sum(isone.(ggrd.mask))) / $(nlon*nlat)\n"
	)
end

function show(io::IO, ggrd::GeneralizedGrid)
	nlon = size(ggrd.lon,1)
	nlat = size(ggrd.lon,2)
    print(
		io,
		"The GeneralMask type has the following properties:\n",
		"    Longitude Indices     (ilon)", '\n',
		"    Latitude Indices      (ilat)", '\n',
		"    Longitude Points       (lon)", '\n',
		"    Latitude Points        (lat)", '\n',
		"    Rotated X Coordinates    (X)",
		"    Rotated Y Coordinates    (Y)",
		"    Rotation (°)             (θ) : ", ggrd.θ,  '\n',
		"    RegionGrid Mask       (mask)", '\n',
		"    RegionGrid Weights (weights)", '\n',
		"    RegionGrid Size 	          : $(nlon) lon points x $(nlat) lat points\n",
		"    RegionGrid Validity          : $(sum(isone.(ggrd.mask))) / $(nlon*nlat)\n"
	)
end

function show(io::IO, ggrd::UnstructuredGrid)
	nlon = size(ggrd.lon)
    print(
		io,
		"The VectorMask Grid type has the following properties:\n",
		"    Indices             (ipoint) : ", ggrd.ipoint, '\n',
		"    Longitude Points       (lon) : ", ggrd.lon,  '\n',
		"    Latitude Points        (lat) : ", ggrd.lat,  '\n',
		"    Rotated X Coordinates    (X)",
		"    Rotated Y Coordinates    (Y)",
		"    Rotation (°)             (θ) : ", ggrd.θ,  '\n',
		"    RegionGrid Weights (weights)", '\n',
		"    RegionGrid Size 			  : $(nlon) points\n",
	)
end