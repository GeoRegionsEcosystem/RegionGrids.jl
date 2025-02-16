# An Example of how to use RegionGrids

```@example example
using GeoRegions
using RegionGrids
using DelimitedFiles
using CairoMakie

download("https://raw.githubusercontent.com/natgeo-wong/GeoPlottingData/main/coastline_resl.txt","coast.cst")
coast = readdlm("coast.cst",comments=true)
clon  = coast[:,1]
clat  = coast[:,2]
nothing
```

Let us define some random data:

```@example example
lon = collect(0:5:360);  nlon = length(lon)
lat = collect(-90:5:90); nlat = length(lat)
data = rand(nlon,nlat)
```

Next, we proceed to define a GeoRegion and extract its coordinates:

```@example example
geo = GeoRegion([10,230,-50,10],[50,10,-40,50])
slon,slat = coordinates(geo) # extract the coordinates
```

Following which, we can define a RegionGrid:

```@example example
ggrd = RegionGrid(geo,lon,lat)
```

And then use this RegionGrid to extract data for the GeoRegion of interest:

```@example example
ndata = extract(data,ggrd)
```

And we can visualize this by plotting the data

```@example example
fig = Figure()

ax1 = Axis(
    fig[1,1],width=400,height=200,
    limits=(0,360,-90,90)
)
heatmap!(ax1,lon,lat,data,colorrange=(-1,1))
lines!(ax1,slon,slat,color=:black,linewidth=5)
lines!(ax1,slon.+360,slat,color=:black,linewidth=5)

ax2 = Axis(
    fig[2,1],width=400,height=200,
    limits=(0,360,-90,90)
)
heatmap!(ax2,ggrd.lon,ggrd.lat,ndata,colorrange=(-1,1))
heatmap!(ax2,ggrd.lon.+360,ggrd.lat,ndata,colorrange=(-1,1))
lines!(ax2,slon,slat,color=:black,linewidth=5)
lines!(ax2,slon.+360,slat,color=:black,linewidth=5)

resize_to_layout!(fig)
fig
```