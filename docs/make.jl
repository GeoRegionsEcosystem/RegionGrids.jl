using RegionGrids
using Documenter

DocMeta.setdocmeta!(RegionGrids, :DocTestSetup, :(using RegionGrids); recursive=true)

makedocs(;
    modules=[RegionGrids],
    authors="Nathanael Wong <natgeo.wong@outlook.com>",
    sitename="RegionGrids.jl",
    format=Documenter.HTML(;
        canonical="https://natgeo-wong.github.io/RegionGrids.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/natgeo-wong/RegionGrids.jl",
    devbranch="main",
)
