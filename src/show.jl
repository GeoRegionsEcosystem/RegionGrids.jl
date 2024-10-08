function show(io::IO, ggrd::RLinearMask)
	nlon = length(ggrd.ilon)
	nlat = length(ggrd.ilat)
    print(
		io,
		"The RLinearMask Grid type has the following properties:\n",
		"    Longitude Indices     (ilon) : ", ggrd.ilon, '\n',
		"    Latitude Indices      (ilat) : ", ggrd.ilat, '\n',
		"    Longitude Points       (lon) : ", ggrd.lon,  '\n',
		"    Latitude Points        (lat) : ", ggrd.lat,  '\n',
		"    RegionGrid Mask       (mask)", '\n',
		"    RegionGrid Weights (weights)", '\n',
		"    RegionGrid Size              : $(nlon) lon points x $(nlat) lat points\n",
		"    RegionGrid Validity		  : $(sum(isone.(mask))) / $(nlon*nlat)\n"
	)
end

function show(io::IO, ggrd::RLinearTilt)
	nlon = length(ggrd.ilon)
	nlat = length(ggrd.ilat)
	mask = ggrd.mask
    print(
		io,
		"The RLinearTilt Grid type has the following properties:\n",
		"    Longitude Indices     (ilon) : ", ggrd.ilon, '\n',
		"    Latitude Indices      (ilat) : ", ggrd.ilat, '\n',
		"    Longitude Points       (lon) : ", ggrd.lon,  '\n',
		"    Latitude Points        (lat) : ", ggrd.lat,  '\n',
		"    RegionGrid Mask       (mask)", '\n',
		"    RegionGrid Weights (weights)", '\n',
		"    Rotated X Points      (rotX)", '\n',
		"    Rotated Y Points      (rotY)", '\n',
		"    RegionGrid Size              : $(nlon) lon points x $(nlat) lat points\n",
		"    RegionGrid Validity		  : $(sum(isone.(mask))) / $(nlon*nlat)\n"
	)
end

function show(io::IO, ggrd::GeneralMask)
	nlon = size(ggrd.lon,1)
	nlat = size(ggrd.lon,2)
    print(
		io,
		"The GeneralMask type has the following properties:\n",
		"    Longitude Points   (lon)", '\n',
		"    Latitude Points    (lat)", '\n',
		"    RegionGrid Mask    (mask)", '\n',
		"    RegionGrid Weights (weights)", '\n',
		"    RegionGrid Size 	 : $(nlon) lon points x $(nlat) lat points\n",
		"    RegionGrid Validity : $(sum(isone.(mask))) / $(nlon*nlat)\n"
	)
end

function show(io::IO, ggrd::GeneralTilt)
	nlon = size(ggrd.lon,1)
	nlat = size(ggrd.lon,2)
    print(
		io,
		"The GeneralTilt type has the following properties:\n",
		"    Longitude Points   (lon)", '\n',
		"    Latitude Points    (lat)", '\n',
		"    RegionGrid Mask    (mask)", '\n',
		"    RegionGrid Weights (weights)", '\n',
		"    Rotated X Points   (rotX)", '\n',
		"    Rotated Y Points   (rotY)", '\n',
		"    RegionGrid Size 	 : $(nlon) lon points x $(nlat) lat points\n",
		"    RegionGrid Validity : $(sum(isone.(mask))) / $(nlon*nlat)\n"
	)
end

function show(io::IO, ggrd::VectorMask)
	nlon = size(ggrd.lon)
    print(
		io,
		"The VectorMask Grid type has the following properties:\n",
		"    Longitude Points       (lon) : ", ggrd.lon,  '\n',
		"    Latitude Points        (lat) : ", ggrd.lat,  '\n',
		"    Longitude Indices   (ipoint) : ", ggrd.ipoint, '\n',
		"    RegionGrid Weights (weights)", '\n',
		"    RegionGrid Size 	 : $(nlon) lon points x $(nlat) lat points\n",
		"    RegionGrid Validity : $(sum(isone.(mask))) / $(nlon*nlat)\n"
	)
end

function show(io::IO, ggrd::VectorTilt)
	nlon = size(ggrd.lon)
    print(
		io,
		"The VectorTilt Grid type has the following properties:\n",
		"    Longitude Points       (lon) : ", ggrd.lon,  '\n',
		"    Latitude Points        (lat) : ", ggrd.lat,  '\n',
		"    Longitude Indices   (ipoint) : ", ggrd.ipoint, '\n',
		"    RegionGrid Weights (weights)", '\n',
		"    Rotated X Points      (rotX)", '\n',
		"    Rotated Y Points      (rotY)", '\n',
		"    RegionGrid Size 	 : $(nlon) lon points x $(nlat) lat points\n",
		"    RegionGrid Validity : $(sum(isone.(mask))) / $(nlon*nlat)\n"
	)
end