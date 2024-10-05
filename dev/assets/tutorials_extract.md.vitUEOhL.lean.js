import{_ as a,c as n,a4 as i,o as e}from"./chunks/framework.xP4K5mBm.js";const g=JSON.parse('{"title":"Extracting Gridded Data using RegionGrid","description":"","frontmatter":{},"headers":[],"relativePath":"tutorials/extract.md","filePath":"tutorials/extract.md","lastUpdated":null}'),p={name:"tutorials/extract.md"};function t(l,s,o,c,d,h){return e(),n("div",null,s[0]||(s[0]=[i(`<h1 id="Extracting-Gridded-Data-using-RegionGrid" tabindex="-1">Extracting Gridded Data using RegionGrid <a class="header-anchor" href="#Extracting-Gridded-Data-using-RegionGrid" aria-label="Permalink to &quot;Extracting Gridded Data using RegionGrid {#Extracting-Gridded-Data-using-RegionGrid}&quot;">​</a></h1><p>Suppose we have Global Data. However, we are only interested in a specific region (say, the North Central American region as defined in AR6), how do we extract data for this region?</p><p>The simple answer is, we use the <code>extractGrid()</code> function, which takes in a <code>RegionGrid</code> and a data array, and returns a new data array for the GeoRegion.</p><h3 id="setup" tabindex="-1">Setup <a class="header-anchor" href="#setup" aria-label="Permalink to &quot;Setup&quot;">​</a></h3><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>using GeoRegions</span></span>
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
<span class="line"><span>  0.891788    0.400209    -0.000862064   0.830314  …   0.137661   -0.395988</span></span>
<span class="line"><span> -1.22117     0.00366644   1.20455      -1.13113      -0.828067    0.680093</span></span>
<span class="line"><span> -0.269995    0.315979    -0.406826      0.176751     -0.851431   -0.63866</span></span>
<span class="line"><span> -2.25012     0.468272     0.305302     -0.105262      1.05059     0.421195</span></span>
<span class="line"><span>  0.0522736   0.432563     0.190965     -0.43786       1.77948     0.640634</span></span>
<span class="line"><span> -1.84646     0.794288     0.610254     -0.956781  …   0.38447    -0.140351</span></span>
<span class="line"><span> -1.51577     0.558282     0.385304      0.28672      -0.86064     0.985098</span></span>
<span class="line"><span>  0.521804    0.149034     1.78722       0.338037     -1.10828    -0.164469</span></span>
<span class="line"><span> -0.626894   -0.732305    -0.929439      2.40894      -0.110787   -0.374119</span></span>
<span class="line"><span> -1.20609     0.112733     0.205301      1.14825       0.735906   -1.24863</span></span>
<span class="line"><span>  ⋮                                                ⋱               ⋮</span></span>
<span class="line"><span>  0.925242   -0.783197     0.792969     -0.76455       0.0583121  -0.723845</span></span>
<span class="line"><span>  0.715508   -0.313835    -0.861598     -0.201346      0.0841101   0.37479</span></span>
<span class="line"><span>  1.17336     1.20718      0.620181     -0.838365     -0.663498    0.499643</span></span>
<span class="line"><span> -0.223412   -0.854955    -0.88881       0.430613      0.817414    0.45086</span></span>
<span class="line"><span>  1.37141     0.805146    -2.09654      -0.571663  …   1.02623     0.149679</span></span>
<span class="line"><span>  0.784535    0.392157    -1.41841       0.246802     -0.82298     0.395107</span></span>
<span class="line"><span> -1.05701     0.768132     0.478953      0.434702      0.149639    1.54959</span></span>
<span class="line"><span>  0.0490181   0.406327     0.909151      0.292283     -1.52656     0.00298952</span></span>
<span class="line"><span>  1.14233    -0.718443    -1.51409      -0.486811     -0.570032   -0.239503</span></span></code></pre></div><p>Our next step is to define the RegionGrid based on the longitude and latitude vectors and their intersection with the GeoRegion</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>ggrd = RegionGrid(geo,lon,lat)</span></span></code></pre></div><p>Then we extract the data</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>ndata = extractGrid(odata,ggrd)</span></span></code></pre></div><p>Let us plot the old and new data</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>fig = Figure()</span></span>
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
