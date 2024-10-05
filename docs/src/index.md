```@raw html
---
layout: home

hero:
  name: "RegionGrids.jl"
  text: "Extraction of Gridded Data for Geospatial Data"
  tagline: Extracting Gridded Geospatial Data for Geographic Regions of Interest.
  image:
    src: /logo.png
    alt: RegionGrids
  actions:
    - theme: brand
      text: Getting Started
      link: /regiongrids
    - theme: alt
      text: Tutorials
      link: /tutorials
    - theme: alt
      text: View on Github
      link: https://github.com/GeoRegionsEcosystem/RegionGrids.jl
      

features:
  - icon: <img width="64" height="64" src="https://img.icons8.com/arcade/64/markdown.png" alt="markdown"/>
    title: Grids
    details: Geographic Regions are defined using Longitude/Latitude coordinates
    link: /basics/shape
  - icon: <img width="64" height="64" src="https://img.icons8.com/arcade/64/markdown.png" alt="markdown"/>
    title: Extraction
    details: Many predefined Geographic Regions bundled from different datasets
    link: /basics/predefined/datasets
---
```

## Installation Instructions

The latest version of RegionGrids can be installed using the Julia package manager (accessed by pressing `]` in the Julia command prompt)
```julia-repl
julia> ]
(@v1.10) pkg> add RegionGrids
```

You can update `RegionGrids.jl` to the latest version using
```julia-repl
(@v1.10) pkg> update RegionGrids
```

And if you want to get the latest release without waiting for me to update the Julia Registry (although this generally isn't necessary since I make a point to release patch versions as soon as I find bugs or add new working features), you may fix the version to the `main` branch of the GitHub repository:
```julia-repl
(@v1.10) pkg> add RegionGrids#main
```

## Getting help
If you are interested in using `RegionGrids.jl` or are trying to figure out how to use it, please feel free to ask me questions and get in touch!  Please feel free to [open an issue](https://github.com/GeoRegionsEcosystem/RegionGrids.jl/issues/new) if you have any questions, comments, suggestions, etc!
