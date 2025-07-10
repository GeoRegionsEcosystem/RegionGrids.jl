
# Rectilinear Grids for Data Extraction {#Rectilinear-Grids-for-Data-Extraction}

The most straightforward of the `RegionGrid` types is the `RectilinearGrid`. This is the type that is used for most datasets on a rectilinear longitude/latitude grid. Examples of such datasets include:
- [Level 3 products from the Global Precipitation Measurement Mission](https://gpm.nasa.gov/data/directory)
  
- Final regridded products from reanalysis such as [ERA5](https://www.ecmwf.int/en/forecasts/dataset/ecmwf-reanalysis-v5) and [MERRA2](https://gmao.gsfc.nasa.gov/reanalysis/merra-2/)
  
- Model output from simple climate models such as [Isca](https://github.com/ExeClim/Isca) and [SpeedyWeather.jl](https://github.com/SpeedyWeather/SpeedyWeather.jl)
  

Basically, for each of these datasets, the data is given in such a way that the coordinates of the grid can be expressed via two vectors/ranges:
- A vector/range of longitudes
  
- A vector/range of latitudes
  

```julia
using GeoRegions
using RegionGrids
using CairoMakie
```


## Creating Rectilinear Grids {#Creating-Rectilinear-Grids}

A Rectilinear Grid can be created as follows:

```
ggrd = RegionGrid(geo,lon,lat)
```


where `geo` is a `GeoRegion` of interest that is found within the domain defined by the longitude and latitude grid vectors.

```julia
lon = collect(0:5:359);  nlon = length(lon)
lat = collect(-90:5:90); nlat = length(lat)
geo = GeoRegion([10,230,-50,10],[50,10,-40,50])

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
    RegionGrid Size              : 57 lon points x 19 lat points
    RegionGrid Validity		  : 451 / 1083

```


The API for creating a Rectilinear Grid can be found [here](rectilinear.md)

## What is in a Rectilinear Grid? {#What-is-in-a-Rectilinear-Grid?}
<details class='jldocstring custom-block' open>
<summary><a id='RegionGrids.RectilinearGrid' href='#RegionGrids.RectilinearGrid'><span class="jlbinding">RegionGrids.RectilinearGrid</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
RectilinearGrid <: RegionGrid
```


A `RectilinearGrid` is a `RegionGrid` that is created based on rectilinear longitude/latitude grids. It has its own subtypes: `RectGrid`, `TiltGrid` and `PolyGrid`.

All `RectilinearGrid` types contain the following fields:
- `lon` - A Vector of `Float`s, defining the longitude vector describing the region.
  
- `lat` - A Vector of `Float`s, defining the latitude vector describing the region.
  
- `ilon` - A Vector of `Int`s, defining the indices used to extract the longitude vector from the input longitude vector.
  
- `ilat` - A Vector of `Int`s, defining the indices used to extract the latitude vector from the input latitude vector.
  
- `mask` - An Array of NaNs and 1s, defining the gridpoints in the RegionGrid where the data is valid.
  
- `weights` - A Vector of `Float`s, defining the latitude-weights of each valid point in the grid. Will be NaN if outside the bounds of the GeoRegion used to define this RectilinearGrid.
  
- `X` - A Vector of `Float`s, defining the X-coordinates (in meters) of each point in the &quot;derotated&quot; RegionGrid about the centroid for the shape of the GeoRegion.
  
- `Y` - A Vector of `Float`s, defining the Y-coordinates (in meters) of each point in the &quot;derotated&quot; RegionGrid about the centroid for the shape of the GeoRegion.
  
- `θ` - A `Float` storing the information on the angle (in degrees) about which the data was rotated in the anti-clockwise direction. Mathematically, it is `rotation - geo.θ`.
  


<Badge type="info" class="source-link" text="source"><a href="https://github.com/GeoRegionsEcosystem/RegionGrids.jl/blob/76b08e60c5e247b3d19d7bc8a2ac1e2ad086691a/src/RegionGrids.jl#L24-L39" target="_blank" rel="noreferrer">source</a></Badge>

</details>


We see that in a `RectilinearGrid` type, we have the `lon` and `lat` fields that defined the longitude and latitude vectors that have been cropped to fit the GeoRegion bounds.

```julia
ggrd.lon, ggrd.lat
```


```ansi
([-50, -45, -40, -35, -30, -25, -20, -15, -10, -5  …  185, 190, 195, 200, 205, 210, 215, 220, 225, 230], [-40, -35, -30, -25, -20, -15, -10, -5, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50])
```


## An example of using Rectilinear Grids {#An-example-of-using-Rectilinear-Grids}

Say we have some sample data, here randomly generated.

```julia
data = rand(nlon,nlat)
```


```ansi
72×37 Matrix{Float64}:
 0.610483  0.79305     0.970413    …  0.227744   0.0861513  0.996303
 0.377661  0.00519934  0.540122       0.344381   0.616766   0.0173821
 0.213247  0.882032    0.0517122      0.737324   0.836024   0.0302693
 0.15549   0.36748     0.00732303     0.643061   0.594527   0.431779
 0.387732  0.78134     0.30662        0.0983056  0.925523   0.965788
 0.719904  0.715997    0.599862    …  0.216043   0.16695    0.558634
 0.300463  0.499434    0.28089        0.246352   0.653932   0.0972692
 0.272727  0.224173    0.755745       0.54808    0.369384   0.96839
 0.549787  0.151425    0.9668         0.901333   0.0424154  0.156821
 0.689764  0.151993    0.627738       0.714336   0.418388   0.542479
 ⋮                                 ⋱             ⋮          
 0.270069  0.632321    0.781531       0.696049   0.182177   0.469291
 0.343834  0.257892    0.957212       0.965721   0.787505   0.163905
 0.84698   0.771175    0.00885894  …  0.912738   0.510961   0.194947
 0.963329  0.955971    0.893806       0.394887   0.571449   0.713812
 0.716963  0.435733    0.475332       0.0290542  0.931762   0.509537
 0.860872  0.914713    0.0660254      0.603796   0.810555   0.0790337
 0.640495  0.016456    0.450796       0.316902   0.0227889  0.658355
 0.377059  0.114072    0.924789    …  0.74118    0.979982   0.219868
 0.909403  0.434105    0.1905         0.223033   0.837307   0.66835
```


We extract the valid data within the GeoRegion of interest that we defined above:

```julia
ndata = extract(data,ggrd)
```


```ansi
57×19 Matrix{Float64}:
   0.934785  NaN         NaN          …  NaN         NaN  NaN  NaN  NaN  NaN
 NaN           0.136858  NaN             NaN         NaN  NaN  NaN  NaN  NaN
 NaN           0.612878    0.908024      NaN         NaN  NaN  NaN  NaN  NaN
 NaN           0.7289      0.748831      NaN         NaN  NaN  NaN  NaN  NaN
 NaN           0.326844    0.718574      NaN         NaN  NaN  NaN  NaN  NaN
 NaN           0.487342    0.0849669  …  NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN           0.817485      NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN           0.824902      NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN           0.491666      NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN           0.805993        0.683283  NaN  NaN  NaN  NaN  NaN
   ⋮                                  ⋱                     ⋮            
 NaN         NaN         NaN             NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN         NaN             NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN         NaN          …  NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN         NaN             NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN         NaN             NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN         NaN             NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN         NaN             NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN         NaN          …  NaN         NaN  NaN  NaN  NaN  NaN
 NaN         NaN         NaN             NaN         NaN  NaN  NaN  NaN  NaN
```


And now let us visualize the results.

```julia
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

![](aiymidi.png){width=549px height=413px}
