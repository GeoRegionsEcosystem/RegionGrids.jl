# Rectilinear Grids for Data Extraction

The most straightforward of the `RegionGrid` types is the `RectilinearGrid`. This is the type that is used for most datasets on a rectilinear longitude/latitude grid. Examples of such datasets include:
* [Level 3 products from the Global Precipitation Measurement Mission](https://gpm.nasa.gov/data/directory)
* Final regridded products from reanalysis such as [ERA5](https://www.ecmwf.int/en/forecasts/dataset/ecmwf-reanalysis-v5) and [MERRA2](https://gmao.gsfc.nasa.gov/reanalysis/merra-2/)
* Model output from simple climate models such as [Isca](https://github.com/ExeClim/Isca) and [SpeedyWeather.jl](https://github.com/SpeedyWeather/SpeedyWeather.jl)

Basically, for each of these datasets, the data is given in such a way that the coordinates of the grid can be expressed via two vectors/ranges:
* A vector/range of longitudes
* A vector/range of latitudes

```@example rectilinear
using GeoRegions
using RegionGrids
using CairoMakie
```

## Creating Rectilinear Grids

A Rectilinear Grid can be created as follows:

```
ggrd = RegionGrid(geo,lon,lat)
```

where `geo` is a `GeoRegion` of interest that is found within the domain defined by the longitude and latitude grid vectors.

```@example rectilinear
lon = collect(0:5:359);  nlon = length(lon)
lat = collect(-90:5:90); nlat = length(lat)
geo = GeoRegion([10,230,-50,10],[50,10,-40,50])

ggrd = RegionGrid(geo,lon,lat)
```

The API for creating a Rectilinear Grid can be found [here]()

## What is in a Rectilinear Grid?

```@docs
RectilinearGrid
```

We see that in a `RectilinearGrid` type, we have the `lon` and `lat` fields that defined the longitude and latitude vectors that have been cropped to fit the GeoRegion bounds.

```@example
ggrd.lon, ggrd.lat
```

## An example of using Rectilinear Grids

Say we have some sample data, here randomly generated.

```@example rectilinear
data = rand(nlon,nlat)
```

We extract the valid data within the GeoRegion of interest that we defined above:

```@example rectilinear
ndata = extract(data,ggrd)
```

And now let us visualize the results.

```@example rectilinear
slon,slat = coordinates(geo) # extract the coordinates
fig = Figure()

ax1 = Axis(
    fig[1,1],width=450,height=150,
    limits=(-180,360,-90,90)
)
heatmap!(ax1,lon,lat,data,colorrange=(-1,1))
lines!(ax1,slon,slat,color=:black,linewidth=2)
lines!(ax1,slon.+360,slat,color=:black,linewidth=2,linestyle=:dash)

hidexdecorations!(ax1,ticks=false,grid=false)

ax2 = Axis(
    fig[2,1],width=450,height=150,
    limits=(-180,360,-90,90)
)
heatmap!(ax2,ggrd.lon,ggrd.lat,ndata,colorrange=(-1,1))
lines!(ax2,slon,slat,color=:black,linewidth=2)

Label(fig[3,:],"Longitude / º")
Label(fig[:,0],"Latitude / º",rotation=pi/2)

resize_to_layout!(fig)
fig
```