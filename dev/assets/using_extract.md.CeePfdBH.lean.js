import{_ as a,c as n,a4 as i,o as e}from"./chunks/framework.xP4K5mBm.js";const g=JSON.parse('{"title":"Extracting Gridded Data using RegionGrid","description":"","frontmatter":{},"headers":[],"relativePath":"using/extract.md","filePath":"using/extract.md","lastUpdated":null}'),p={name:"using/extract.md"};function t(l,s,o,c,d,h){return e(),n("div",null,s[0]||(s[0]=[i(`<h1 id="Extracting-Gridded-Data-using-RegionGrid" tabindex="-1">Extracting Gridded Data using RegionGrid <a class="header-anchor" href="#Extracting-Gridded-Data-using-RegionGrid" aria-label="Permalink to &quot;Extracting Gridded Data using RegionGrid {#Extracting-Gridded-Data-using-RegionGrid}&quot;">​</a></h1><p>Suppose we have Global Data. However, we are only interested in a specific region (say, the North Central American region as defined in AR6), how do we extract data for this region?</p><p>The simple answer is, we use the <code>extractGrid()</code> function, which takes in a <code>RegionGrid</code> and a data array, and returns a new data array for the GeoRegion.</p><h3 id="setup" tabindex="-1">Setup <a class="header-anchor" href="#setup" aria-label="Permalink to &quot;Setup&quot;">​</a></h3><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>using GeoRegions</span></span>
<span class="line"><span>using DelimitedFiles</span></span>
<span class="line"><span>using CairoMakie</span></span>
<span class="line"><span></span></span>
<span class="line"><span>download(&quot;https://raw.githubusercontent.com/natgeo-wong/GeoPlottingData/main/coastline_resl.txt&quot;,&quot;coast.cst&quot;)</span></span>
<span class="line"><span>coast = readdlm(&quot;coast.cst&quot;,comments=true)</span></span>
<span class="line"><span>clon  = coast[:,1]</span></span>
<span class="line"><span>clat  = coast[:,2]</span></span>
<span class="line"><span>nothing</span></span></code></pre></div><h2 id="Let-us-define-the-GeoRegion-of-interest" tabindex="-1">Let us define the GeoRegion of interest <a class="header-anchor" href="#Let-us-define-the-GeoRegion-of-interest" aria-label="Permalink to &quot;Let us define the GeoRegion of interest {#Let-us-define-the-GeoRegion-of-interest}&quot;">​</a></h2><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">geo  </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> GeoRegion</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;AR6_NCA&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>The Polygonal Region AR6_NCA has the following properties:</span></span>
<span class="line"><span>    Region ID     (ID) : AR6_NCA</span></span>
<span class="line"><span>    Parent ID    (pID) : GLB</span></span>
<span class="line"><span>    Name        (name) : Northern Central America</span></span>
<span class="line"><span>    Bounds   (N,S,E,W) : [33.8, 16.0, -90.0, -122.5]</span></span>
<span class="line"><span>    Shape      (shape) : Point{2, Float64}[[-90.0, 25.0], [-104.5, 16.0], [-122.5, 33.8], [-105.0, 33.8], [-90.0, 25.0]]</span></span></code></pre></div><p>We also define some sample test data in the global domain</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">lon </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> collect</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">0</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">360</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">); </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">pop!</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(lon); nlon </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> length</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(lon)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">lat </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> collect</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">-</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">90</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">90</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);           nlat </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> length</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(lat)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">odata </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> randn</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">((nlon,nlat))</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>360×181 Matrix{Float64}:</span></span>
<span class="line"><span>  0.218039   0.0537557   0.272505  …  -0.311872   1.03929     -0.292802</span></span>
<span class="line"><span> -1.6989     0.211311   -0.385411      1.89468   -0.737401     0.242118</span></span>
<span class="line"><span>  1.02814    0.493913    0.200041      0.358588  -0.00733231   1.50761</span></span>
<span class="line"><span>  1.03747   -0.318729    0.120427     -1.45024   -0.00423609  -1.41786</span></span>
<span class="line"><span> -1.05313    0.163164   -0.739546     -1.39771    0.179486     2.96441</span></span>
<span class="line"><span> -0.835408   0.60707     0.711911  …   1.35266   -1.59058     -0.55668</span></span>
<span class="line"><span>  1.26739   -0.118938   -1.32722       1.64467   -0.757302     0.445215</span></span>
<span class="line"><span> -0.109112  -1.77092     1.7292       -0.544284   0.299906     0.0247444</span></span>
<span class="line"><span> -2.21876   -0.634759   -0.051748      0.490541  -0.0518828    1.66479</span></span>
<span class="line"><span> -0.811888   0.789622   -0.218813      2.06142   -0.407042    -1.01607</span></span>
<span class="line"><span>  ⋮                                ⋱                           ⋮</span></span>
<span class="line"><span>  0.253364  -1.20016     0.808444      0.203011   0.459646     1.44004</span></span>
<span class="line"><span> -0.543404  -0.990442    0.609729      0.331255  -0.138236     0.00980454</span></span>
<span class="line"><span>  1.86072    0.0138025   0.55615      -0.602017  -0.102647    -1.49739</span></span>
<span class="line"><span> -1.38244    0.340409    0.509541     -1.32782   -0.312034    -0.19847</span></span>
<span class="line"><span> -1.34364    0.997312    0.609621  …   1.03156   -1.12476     -2.52613</span></span>
<span class="line"><span> -1.25677   -1.23307     0.740992     -0.716459   0.640731    -0.240429</span></span>
<span class="line"><span>  0.161831   0.0677403  -0.146426      0.423489  -0.543306     0.349095</span></span>
<span class="line"><span> -1.24321    2.61975    -2.02279      -2.02806   -0.175384     1.57595</span></span>
<span class="line"><span>  0.200443   0.229252    0.910459     -0.338049   0.887187     0.741342</span></span></code></pre></div><p>Our next step is to define the RegionGrid based on the longitude and latitude vectors and their intersection with the GeoRegion</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>ggrd = RegionGrid(geo,lon,lat)</span></span></code></pre></div><p>Then we extract the data</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>ndata = extractGrid(odata,ggrd)</span></span></code></pre></div><p>Let us plot the old and new data</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>fig = Figure()</span></span>
<span class="line"><span>_,_,slon,slat = coordGeoRegion(geo); slon = slon .+ 360</span></span>
<span class="line"><span>aspect = (maximum(slon)-minimum(slon))/(maximum(slat)-minimum(slat))</span></span>
<span class="line"><span></span></span>
<span class="line"><span>ax = Axis(</span></span>
<span class="line"><span>    fig[1,1],width=350,height=350/aspect,</span></span>
<span class="line"><span>    limits=(minimum(slon)-2,maximum(slon)+2,minimum(slat)-2,maximum(slat)+2)</span></span>
<span class="line"><span>)</span></span>
<span class="line"><span>contourf!(</span></span>
<span class="line"><span>    ax,lon,lat,odata,</span></span>
<span class="line"><span>    levels=range(-1,1,length=11),extendlow=:auto,extendhigh=:auto</span></span>
<span class="line"><span>)</span></span>
<span class="line"><span>lines!(ax,clon,clat,color=:black)</span></span>
<span class="line"><span>lines!(ax,slon,slat,color=:red,linewidth=5)</span></span>
<span class="line"><span></span></span>
<span class="line"><span>ax = Axis(</span></span>
<span class="line"><span>    fig[1,2],width=350,height=350/aspect,</span></span>
<span class="line"><span>    limits=(minimum(slon)-2,maximum(slon)+2,minimum(slat)-2,maximum(slat)+2)</span></span>
<span class="line"><span>)</span></span>
<span class="line"><span>contourf!(</span></span>
<span class="line"><span>    ax,ggrd.lon,ggrd.lat,ndata,</span></span>
<span class="line"><span>    levels=range(-1,1,length=11),extendlow=:auto,extendhigh=:auto</span></span>
<span class="line"><span>)</span></span>
<span class="line"><span>lines!(ax,clon,clat,color=:black)</span></span>
<span class="line"><span>lines!(ax,slon,slat,color=:red,linewidth=5)</span></span>
<span class="line"><span></span></span>
<span class="line"><span>hideydecorations!(ax, ticks = false,grid=false)</span></span>
<span class="line"><span></span></span>
<span class="line"><span>resize_to_layout!(fig)</span></span>
<span class="line"><span>fig</span></span></code></pre></div><h2 id="api" tabindex="-1">API <a class="header-anchor" href="#api" aria-label="Permalink to &quot;API&quot;">​</a></h2><div class="warning custom-block"><p class="custom-block-title">Missing docstring.</p><p>Missing docstring for <code>extractGrid</code>. Check Documenter&#39;s build log for details.</p></div><div class="warning custom-block"><p class="custom-block-title">Missing docstring.</p><p>Missing docstring for <code>extractGrid!</code>. Check Documenter&#39;s build log for details.</p></div><hr><p><em>This page was generated using <a href="https://github.com/fredrikekre/Literate.jl" target="_blank" rel="noreferrer">Literate.jl</a>.</em></p>`,22)]))}const k=a(p,[["render",t]]);export{g as __pageData,k as default};
