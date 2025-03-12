# Unstructured Grids for Data Extraction

There are also `RegionGrid` types without an actual grid, maybe there are a set of coordinates and geometries that define the corners or the centres of a mesh, such as:
* Model output from climate models such as cubed-sphere mesh output of the [Community Earth Systems Model 2 (CESM2)](https://www.cesm.ucar.edu/models/cesm2).

Basically, for each of these datasets, the data is given in such a way that the coordinates of the grid can be expressed via:
* A Vector of `Point2` types, with each `Point2` type containing (lon,lat)

```@example unstructured
using GeoRegions
using RegionGrids
using CairoMakie
```

## Creating Unstructured Grids

A Unstructured Grid can be created as follows:

```
ggrd = RegionGrid(geo,Point2.(lon,lat))
```

where `geo` is a `GeoRegion` of interest that is found within the domain defined by the longitude and latitude grid vectors.

```@example unstructured
lon = collect(10:20:360); nlon = length(lon)
lat = collect(-80:20:90); nlat = length(lat)

glon = zeros(nlon,nlat); glon .= lon;  glon = glon[:]
glat = zeros(nlon,nlat); glat .= lat'; glat = glat[:]

plon = glon .+ 14rand(nlon*nlat) .- 7
plat = glat .+ 14rand(nlon*nlat) .- 7

geo = GeoRegion([10,100,-80,10],[50,10,-40,50])

iggrd = RegionGrid(geo,Point2.(glon,glat))
pggrd = RegionGrid(geo,Point2.(plon,plat))
```

The API for creating a Unstructured Grid can be found [here]()

## What is in a Unstructured Grid?

```@docs
UnstructuredGrid
```

We see that in a `UnstructuredGrid` type, we have the `lon` and `lat` vectors that defined the longitude and latitude points that are within the GeoRegion.

```@example unstructured
ggrd.lon
```
```@example unstructured
ggrd.lat
```

## An example of using Unstructured Grids

Say we have some sample data, here randomly generated.

```@example unstructured
data = rand(nlon,nlat)[:]
```

We extract the valid data within the GeoRegion of interest that we defined above:

```@example unstructured
ndata = extract(data,iggrd)
pdata = extract(data,pggrd)
```

And now let us visualize the results.

```@example unstructured
slon,slat = coordinates(geo) # extract the coordinates
fig = Figure()

ax1 = Axis(
    fig[1,1],width=450,height=150,
    limits=(-180,360,-90,90)
)
scatter!(ax1,glon,glat,color=:lightgrey)
scatter!(ax1,plon,plat,color=data)
lines!(ax1,slon,slat,color=:black,linewidth=2)
lines!(ax1,slon.+360,slat,color=:black,linewidth=2,linestyle=:dash)

hidexdecorations!(ax1,ticks=false,grid=false)

ax2 = Axis(
    fig[2,1],width=450,height=150,
    limits=(-180,360,-90,90)
)
scatter!(ax2,iggrd.lon,iggrd.lat,color=:lightgrey)
scatter!(ax2,pggrd.lon,pggrd.lat,color=pdata)
lines!(ax2,slon,slat,color=:black,linewidth=2)

Label(fig[3,:],"Longitude / º")
Label(fig[:,0],"Latitude / º",rotation=pi/2)

resize_to_layout!(fig)
fig
```