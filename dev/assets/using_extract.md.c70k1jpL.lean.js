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
<span class="line"><span>  1.2658      0.231476   -1.64306   …  -0.194278   1.42488   -0.116673</span></span>
<span class="line"><span> -0.669241    1.11764    -1.1804        1.04288   -0.462979   0.564235</span></span>
<span class="line"><span> -0.901272   -1.1856     -2.27926      -0.735486  -2.4909    -0.192412</span></span>
<span class="line"><span>  0.769897    1.31283     0.569357     -0.861801  -0.722302   0.289925</span></span>
<span class="line"><span> -0.0328818   0.464914   -1.74111       0.302422  -0.623004  -1.09357</span></span>
<span class="line"><span>  0.75116    -0.194777   -0.349296  …   0.874366   0.414747  -0.971976</span></span>
<span class="line"><span> -0.951508    0.537904    1.06764       0.111428   1.57109   -0.659149</span></span>
<span class="line"><span>  0.54455    -0.450066   -0.519331      0.473518  -0.120626  -1.9672</span></span>
<span class="line"><span>  0.1203     -0.202207    0.449612     -0.397204   0.244392   0.576288</span></span>
<span class="line"><span> -0.0595458   0.227029   -1.36029       0.864078  -1.10272    0.933947</span></span>
<span class="line"><span>  ⋮                                 ⋱                         ⋮</span></span>
<span class="line"><span> -0.108564    0.462614   -0.714897      0.199018  -1.23947    1.64152</span></span>
<span class="line"><span> -0.727915   -0.724721   -0.607802     -2.35056   -0.779431   0.637576</span></span>
<span class="line"><span>  1.32541    -1.72245    -0.960488      1.88193    0.657671  -0.576751</span></span>
<span class="line"><span>  0.104789   -0.34962     0.834318      0.308623  -0.976526   1.02536</span></span>
<span class="line"><span> -2.04011     0.698992    0.922787  …  -0.940281  -0.673871  -0.960113</span></span>
<span class="line"><span> -0.766098   -0.230305   -0.290441      0.567783   1.53722    0.13386</span></span>
<span class="line"><span> -0.458234    0.0104519  -0.969987     -0.998231   0.525389  -0.616406</span></span>
<span class="line"><span>  0.0599338   0.329797   -0.515611      0.556652   0.684181   0.166921</span></span>
<span class="line"><span>  1.95249     0.11691    -0.703758     -0.976944   0.835379  -0.169381</span></span></code></pre></div><p>Our next step is to define the RegionGrid based on the longitude and latitude vectors and their intersection with the GeoRegion</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>ggrd = RegionGrid(geo,lon,lat)</span></span></code></pre></div><p>Then we extract the data</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>ndata = extractGrid(odata,ggrd)</span></span></code></pre></div><p>Let us plot the old and new data</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>fig = Figure()</span></span>
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
