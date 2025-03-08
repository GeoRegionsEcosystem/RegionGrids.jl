import{_ as i,c as a,o as t,aA as o}from"./chunks/framework.DpoPorFA.js";const r="/RegionGrids.jl/dev/assets/typesofgrids.pXI8p_IV.png",u=JSON.parse('{"title":"What is a RegionGrid?","description":"","frontmatter":{},"headers":[],"relativePath":"basics/regiongrids.md","filePath":"basics/regiongrids.md","lastUpdated":null}'),s={name:"basics/regiongrids.md"};function n(d,e,l,c,p,g){return t(),a("div",null,e[0]||(e[0]=[o('<h1 id="What-is-a-RegionGrid?" tabindex="-1">What is a RegionGrid? <a class="header-anchor" href="#What-is-a-RegionGrid?" aria-label="Permalink to &quot;What is a RegionGrid? {#What-is-a-RegionGrid?}&quot;">​</a></h1><p>A <code>RegionGrid</code> contains information that:</p><ul><li><p>Allows us to extract gridded lon-lat data for a given <code>GeoRegion</code> (see <a href="https://github.com/GeoRegionsEcosystem/GeoRegions.jl" target="_blank" rel="noreferrer">GeoRegions.jl</a>) of interest.</p></li><li><p>Subset the relevant longitude/latitude vectors from the initial grid.</p></li><li><p>Allows for easy spatial-averaging of extracted gridded lon-lat data, weighted by latitude.</p></li></ul><h2 id="The-Types-of-RegionGrids" tabindex="-1">The Types of <code>RegionGrid</code>s <a class="header-anchor" href="#The-Types-of-RegionGrids" aria-label="Permalink to &quot;The Types of `RegionGrid`s {#The-Types-of-RegionGrids}&quot;">​</a></h2><p>The <code>RegionGrid</code> abstract type has three subtypes:</p><ol><li><p><code>RectilinearGrid</code> type, which is for the extraction of data on rectilinear lon-lat grids</p></li><li><p><code>GeneralizedGrid</code> type, which is for the extraction of data on non-rectilinear lon-lat grids, such as a curvilinear grid.</p></li><li><p><code>UnstructuredGrid</code> type, which is for the extraction of data on unstructured lon-lat grids such as a cubed-spherical grid, or an unstructured mesh.</p></li></ol><p><img src="'+r+'" alt=""></p><p>Confusing? Fret not, it&#39;s always easier to understand by doing, so let&#39;s go through an example <a href="/RegionGrids.jl/dev/basics/example">here</a>.</p>',8)]))}const f=i(s,[["render",n]]);export{u as __pageData,f as default};
