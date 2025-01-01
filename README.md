<p align="center">
<img alt="RegionGrids.jl Logo" src=https://raw.githubusercontent.com/GeoRegionsEcosystem/RegionGrids.jl/main/src/logosmall.png />
</p>

# **<div align="center">RegionGrids.jl</div>**

<p align="center">
  <a href="https://www.repostatus.org/#active">
    <img alt="Repo Status" src="https://www.repostatus.org/badges/latest/active.svg?style=flat-square" />
  </a>
  <a href="https://github.com/GeoRegionsEcosystem/RegionGrids.jl/actions/workflows/ci.yml">
    <img alt="GitHub Actions" src="https://github.com/GeoRegionsEcosystem/RegionGrids.jl/actions/workflows/ci.yml/badge.svg?branch=main&style=flat-square">
  </a>
  <br>
  <a href="https://mit-license.org">
    <img alt="MIT License" src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square">
  </a>
	<img alt="MIT License" src="https://img.shields.io/github/v/release/GeoRegionsEcosystem/RegionGrids.jl.svg?style=flat-square">
  <a href="https://GeoRegionsEcosystem.github.io/RegionGrids.jl/stable/">
    <img alt="Latest Documentation" src="https://img.shields.io/badge/docs-stable-blue.svg?style=flat-square">
  </a>
  <a href="https://GeoRegionsEcosystem.github.io/RegionGrids.jl/dev/">
    <img alt="Latest Documentation" src="https://img.shields.io/badge/docs-latest-blue.svg?style=flat-square">
  </a>
</p>

**Created By:** Nathanael Wong (nathanaelwong@fas.harvard.edu)

## **Introduction**

RegionGrids.jl is a Julia package that builds off from the [GeoRegions.jl](https://github.com/GeoRegionsEcosystem/GeoRegions.jl) package. It aims to streamline the following process(es):
* extraction of gridded data (given grid boundaries) from a larger (parent) region (grid must be entirely within this parent region)

RegionGrids.jl is currently able to deal with the following types of grids:
* Rectilinear longitude-latitude grids (e.g., ERA5, IMERG)
* Generalized rectilinear grids (e.g., WRF grids)
* Unstructured grids/meshes (e.g., CESM SE-cubed sphere)

RegionGrids.jl can be installed via
```
] add RegionGrids
```

## **Usage**

Please refer to the [documentation](https://georegionsecosystem.github.io/RegionGrids.jl/dev/) for instructions and examples.