using Documenter
using DocumenterVitepress
using RegionGrids
import CairoMakie

CairoMakie.activate!(type = "svg")

DocMeta.setdocmeta!(RegionGrids, :DocTestSetup, :(using RegionGrids); recursive=true)

makedocs(;
    modules  = [RegionGrids],
    authors  = "Nathanael Wong <natgeo.wong@outlook.com>",
    sitename = "RegionGrids.jl",
    doctest  = false,
    warnonly = true,
    format   = DocumenterVitepress.MarkdownVitepress(
        repo = "https://github.com/GeoRegionsEcosystem/RegionGrids.jl",
    ),
    pages=[
        "Home"            => "index.md",
        "Getting Started" => [
            "What is a RegionGrid?" => "basics/regiongrids.md",
            "Basic Example"         => "basics/example.md",
        ],
        "API List"        => "api.md",
    ],
)

recursive_find(directory, pattern) =
    mapreduce(vcat, walkdir(directory)) do (root, dirs, files)
        joinpath.(root, filter(contains(pattern), files))
    end

files = []
for pattern in [r"\.cst", r"\.nc"]
    global files = vcat(files, recursive_find(@__DIR__, pattern))
end

for file in files
    rm(file)
end

deploydocs(;
    repo      = "github.com/GeoRegionsEcosystem/RegionGrids.jl.git",
    target    = "build", # this is where Vitepress stores its output
    devbranch = "main",
    branch    = "gh-pages",
)
