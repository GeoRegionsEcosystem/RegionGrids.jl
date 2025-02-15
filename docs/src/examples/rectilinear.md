# Example: A Rectilinear Grid for Data Extraction

The most straightforward of the `RegionGrid` types is the `RectilinearGrid`. This is the type that is used for most datasets on a rectilinear longitude/latitude grid. Examples of such datasets include:
* [Level 3 products from the Global Precipitation Measurement Mission](https://gpm.nasa.gov/data/directory)
* Final regridded products from reanalysis such as [ERA5](https://www.ecmwf.int/en/forecasts/dataset/ecmwf-reanalysis-v5) and [MERRA2](https://gmao.gsfc.nasa.gov/reanalysis/merra-2/)
* Model output from simple climate models such as [Isca](https://github.com/ExeClim/Isca) and [SpeedyWeather.jl](https://github.com/SpeedyWeather/SpeedyWeather.jl)

Basically, for each of these datasets, the data is given in such a way that the coordinates of the grid can be expressed via two vectors/ranges:
* A vector/range of longitudes
* A vector/range of latitudes