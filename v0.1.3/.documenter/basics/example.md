
# How do you use RegionGrids.jl? {#How-do-you-use-RegionGrids.jl?}

## The Basic Outline {#The-Basic-Outline}

In practice, we would use GeoRegions and RegionGrids as follows:

```
using GeoRegions
using RegionGrids

# 1. Get gridded data, and longitude/latitude

data = ...
dlon = ... # longitudes for gridded data points
dlat = ... # latitudes for gridded data points

# 2. Define a Geographic Region using a shape defined by vectors for longitude and latitude respectively

geo = GeoRegion(lon,lat)

# 3. Create a RegionGrid for data extraction using the GeoRegion, and longitude and latitude vectors

ggrd = RegionGrid(geo,dlon,dlat)

# 4. Extract the data within the GeoRegion of interest

longitude and latitude vectors respectively
ndata  = extract(data,ggrd)
newlon = ggrd.lon
newlat = ggrd.lat
```


## An Example {#An-Example}

### Setup {#Setup}

```julia
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


### Defining some data {#Defining-some-data}

```julia
lon = collect(0:5:360);  nlon = length(lon)
lat = collect(-90:5:90); nlat = length(lat)
data = rand(nlon,nlat)
```


```ansi
73×37 Matrix{Float64}:
 0.821738    0.550917   0.982154   …  0.925844    0.351734   0.279494
 0.148937    0.973946   0.845378      0.215198    0.335434   0.211086
 0.971341    0.0495319  0.0906585     0.00706426  0.514134   0.768625
 0.846747    0.507537   0.290818      0.63462     0.494248   0.240291
 0.901974    0.230225   0.115509      0.532668    0.0404254  0.392889
 0.861337    0.880615   0.684059   …  0.809159    0.181035   0.0409439
 0.472385    0.0852896  0.2133        0.814443    0.506545   0.661541
 0.945846    0.775287   0.887146      0.693385    0.965626   0.264488
 0.724576    0.251053   0.0872463     0.796989    0.530956   0.564946
 0.868238    0.343166   0.602412      0.491052    0.379059   0.293161
 ⋮                                 ⋱              ⋮          
 0.971593    0.256008   0.435474      0.515664    0.548099   0.927123
 0.803523    0.545622   0.726959   …  0.197953    0.71051    0.776651
 0.550409    0.494453   0.910414      0.685527    0.985584   0.276967
 0.996734    0.29264    0.523023      0.658927    0.177826   0.193097
 0.711365    0.382312   0.663191      0.72021     0.310175   0.440077
 0.00774714  0.510517   0.425296      0.392531    0.91606    0.852033
 0.876392    0.894549   0.494139   …  0.58951     0.295685   0.393584
 0.736358    0.637927   0.810021      0.0955599   0.75174    0.743199
 0.0714714   0.0103991  0.697567      0.217646    0.900724   0.731568
```


### Defining a Region of Interest {#Defining-a-Region-of-Interest}

Next, we proceed to define a GeoRegion and extract its coordinates:

```julia
geo = GeoRegion([10,230,-50,10],[50,10,-40,50])
slon,slat = coordinates(geo) # extract the coordinates
```


```ansi
([10.0, 230.0, -50.0, 10.0], [50.0, 10.0, -40.0, 50.0])
```


### Let us create a RegionGrid for Data Extraction {#Let-us-create-a-RegionGrid-for-Data-Extraction}

Following which, we can define a RegionGrid:

```julia
ggrd = RegionGrid(geo,lon,lat)
```


```ansi
The RLinearMask Grid type has the following properties:
    Longitude Indices     (ilon) : [63, 64, 65, 66, 67, 68, 69, 70, 71, 72  …  38, 39, 40, 41, 42, 43, 44, 45, 46, 47]
    Latitude Indices      (ilat) : [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]
    Longitude Points       (lon) : [-50, -45, -40, -35, -30, -25, -20, -15, -10, -5  …  185, 190, 195, 200, 205, 210, 215, 220, 225, 230]
    Latitude Points        (lat) : [-40, -35, -30, -25, -20, -15, -10, -5, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
    Rotated X Coordinates    (X)
    Rotated Y Coordinates    (Y)
    Rotation (°)             (θ) : 0.0
    RegionGrid Mask       (mask)
    RegionGrid Weights (weights)
    RegionGrid Size              : 58 lon points x 19 lat points
    RegionGrid Validity		  : 465 / 1102

```


And then use this RegionGrid to extract data for the GeoRegion of interest:

```julia
ndata = extract(data,ggrd)
```


```ansi
58×19 Matrix{Float64}:
   0.884622  NaN          NaN          …  NaN         NaN  NaN  NaN  NaN  NaN
 NaN           0.138778   NaN             NaN         NaN  NaN  NaN  NaN  NaN
 NaN           0.241363     0.0699502     NaN         NaN  NaN  NaN  NaN  NaN
 NaN           0.624709     0.015729      NaN         NaN  NaN  NaN  NaN  NaN
 NaN           0.398581     0.755346      NaN         NaN  NaN  NaN  NaN  NaN
 NaN           0.0262826    0.337021   …  NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN            0.994655      NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN            0.935914      NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN            0.978099      NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN            0.401078        0.666348  NaN  NaN  NaN  NaN  NaN
   ⋮                                   ⋱                     ⋮            
 NaN         NaN          NaN             NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN          NaN          …  NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN          NaN             NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN          NaN             NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN          NaN             NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN          NaN             NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN          NaN          …  NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN          NaN             NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN          NaN             NaN         NaN  NaN  NaN  NaN  NaN
```


### Data Visualization {#Data-Visualization}

```julia
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

![](epdupss.png){width=465px height=497px}
