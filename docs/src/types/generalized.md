# Generalized Grids for Data Extraction

Not all longitude-latitude grids are rectilinear in the lon/lat space. `RegionGrid` classifies this type as a `GeneralizedGrid`. Examples of such datasets include:
* [Level 2 products from the Global Precipitation Measurement Mission](https://gpm.nasa.gov/data/directory)
* Model output from climate models such as [Weather Research & Forecasting Model (WRF)](https://www.mmm.ucar.edu/models/wrf)

Basically, for each of these datasets, the data is given in such a way that the coordinates of the grid can be expressed via:
* A 2D array of `Point2` types, with each `Point2` type containing (lon,lat)

```@example generalized
using GeoRegions
using RegionGrids
using CairoMakie
```

## Creating Generalized Grids

A Generalized Grid can be created as follows:

```
ggrd = RegionGrid(geo,Point2.(lon,lat))
```

where `geo` is a `GeoRegion` of interest that is found within the domain defined by the longitude and latitude grid vectors.

```@example generalized
nlon = 51; nlat = 31
lon = zeros(nlon,nlat)
lat = zeros(nlon,nlat)
for ilat = 1 : nlat, ilon = 1 : nlon
    lon[ilon,ilat] = (ilon-26) * (5 + (ilat-16) * 0.1)
    lat[ilon,ilat] = (ilat-16) * 5
end
geo = GeoRegion([10,100,-80,10],[50,10,-40,50])

ggrd = RegionGrid(geo,Point2.(lon,lat))
```

The API for creating a Generalized Grid can be found [here]()

## What is in a Generalized Grid?

```@docs
GeneralizedGrid
```

We see that in a `GeneralizedGrid` type, we have the `lon` and `lat` arrays that defined the longitude and latitude points that have been cropped to fit the GeoRegion bounds.

```@example generalized
ggrd.lon
```
```@example generalized
ggrd.lat
```

## An example of using Generalized Grids

Say we have some sample data, here randomly generated.

```@example generalized
data = rand(nlon,nlat)
```

We extract the valid data within the GeoRegion of interest that we defined above:

```@example generalized
ndata = extract(data,ggrd)
```

And now let us visualize the results.

```@example generalized
slon,slat = coordinates(geo) # extract the coordinates
fig = Figure()

ax1 = Axis(
    fig[1,1],width=300,height=150,
    limits=(-180,180,-90,90)
)
contourf!(ax1,lon,lat,data,levels=-1:0.2:1)
lines!(ax1,slon,slat,color=:black,linewidth=2)
lines!(ax1,slon.+360,slat,color=:black,linewidth=2,linestyle=:dash)

hidexdecorations!(ax1,ticks=false,grid=false)

ax2 = Axis(
    fig[1,2],width=300,height=150,
    limits=(-180,180,-90,90)
)
contourf!(ax2,ggrd.lon,ggrd.lat,ndata,levels=-1:0.2:1)
lines!(ax2,slon,slat,color=:black,linewidth=2)

Label(fig[2,:],"Longitude / º")
Label(fig[:,0],"Latitude / º",rotation=pi/2)

resize_to_layout!(fig)
fig
```