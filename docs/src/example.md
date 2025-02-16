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
lon = collect(0:0.5:360);  nlon = length(lon)
lat = collect(-90:0.5:90); nlat = length(lat)
data = rand(nlon,nlat)
```

Next, we proceed to define a GeoRegion and extract its coordinates:

```@example example
geo = GeoRegion([10,100,-50,10],[20,10,0,20])
slon,slat = coordinates(geo) # extract the coordinates
```

Following which, we can extract the data within this GeoRegion as follows:

```@example example
ggrd = RegionGrid(geo,lon,lat)
ndata = extract(data,ggrd)
```

And we can visualize this by plotting the data

```@example example
fig = Figure()

ax1 = Axis(
    fig[1,1],width=750,height=375,
    limits=(0,360,-90,90)
)
contourf!(ax1,lon,lat,data,levels=range(-1,1,length=11))
lines!(ax1,slon,slat,color=:black,linewidth=5)

ax2 = Axis(
    fig[2,1],width=750,height=375,
    limits=(0,360,-90,90)
)
contourf!(ax2,ggrd.lon,ggrd.lat,ndata,levels=range(-1,1,length=11))
lines!(ax1,slon,slat,color=:black,linewidth=5)

resize_to_layout!(fig)
fig
```