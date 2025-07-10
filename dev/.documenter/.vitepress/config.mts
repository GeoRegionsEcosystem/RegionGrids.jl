import { defineConfig } from 'vitepress'
import { tabsMarkdownPlugin } from 'vitepress-plugin-tabs'
import mathjax3 from "markdown-it-mathjax3";
import footnote from "markdown-it-footnote";
import path from 'path'

function getBaseRepository(base: string): string {
  if (!base || base === '/') return '/';
  const parts = base.split('/').filter(Boolean);
  return parts.length > 0 ? `/${parts[0]}/` : '/';
}

const baseTemp = {
  base: '/RegionGrids.jl/dev/',// TODO: replace this in makedocs!
}

const navTemp = {
  nav: [
{ text: 'Home', link: '/index' },
{ text: 'Getting Started', collapsed: false, items: [
{ text: 'What is a RegionGrid?', link: '/basics/regiongrids' },
{ text: 'Basic Example', link: '/basics/example' }]
 },
{ text: 'Types of RegionGrids', collapsed: false, items: [
{ text: 'Rectilinear Grids', link: '/types/rectilinear' },
{ text: 'Generalized Grids', link: '/types/generalized' },
{ text: 'Unstructured Grids', link: '/types/unstructured' }]
 },
{ text: 'API List', link: '/api' }
]
,
}

const nav = [
  ...navTemp.nav,
  {
    component: 'VersionPicker'
  }
]

// https://vitepress.dev/reference/site-config
export default defineConfig({
  base: '/RegionGrids.jl/dev/',// TODO: replace this in makedocs!
  title: 'RegionGrids.jl',
  description: 'Documentation for RegionGrids.jl',
  lastUpdated: true,
  cleanUrls: true,
  outDir: '../1', // This is required for MarkdownVitepress to work correctly...
  head: [
    ['link', { rel: 'icon', href: `${baseTemp.base}favicon.ico` }],
    ['script', {src: `${getBaseRepository(baseTemp.base)}versions.js`}],
    // ['script', {src: '/versions.js'], for custom domains, I guess if deploy_url is available.
    ['script', {src: `${baseTemp.base}siteinfo.js`}]
  ],
  
  vite: {
    define: {
      __DEPLOY_ABSPATH__: JSON.stringify('/RegionGrids.jl'),
    },
    resolve: {
      alias: {
        '@': path.resolve(__dirname, '../components')
      }
    },
    optimizeDeps: {
      exclude: [ 
        '@nolebase/vitepress-plugin-enhanced-readabilities/client',
        'vitepress',
        '@nolebase/ui',
      ], 
    }, 
    ssr: { 
      noExternal: [ 
        // If there are other packages that need to be processed by Vite, you can add them here.
        '@nolebase/vitepress-plugin-enhanced-readabilities',
        '@nolebase/ui',
      ], 
    },
  },
  markdown: {
    math: true,
    config(md) {
      md.use(tabsMarkdownPlugin),
      md.use(mathjax3),
      md.use(footnote)
    },
    theme: {
      light: "github-light",
      dark: "github-dark"}
  },
  themeConfig: {
    outline: 'deep',
    logo: { src: '/logo.png', width: 24, height: 24},
    search: {
      provider: 'local',
      options: {
        detailedView: true
      }
    },
    nav,
    sidebar: [
{ text: 'Home', link: '/index' },
{ text: 'Getting Started', collapsed: false, items: [
{ text: 'What is a RegionGrid?', link: '/basics/regiongrids' },
{ text: 'Basic Example', link: '/basics/example' }]
 },
{ text: 'Types of RegionGrids', collapsed: false, items: [
{ text: 'Rectilinear Grids', link: '/types/rectilinear' },
{ text: 'Generalized Grids', link: '/types/generalized' },
{ text: 'Unstructured Grids', link: '/types/unstructured' }]
 },
{ text: 'API List', link: '/api' }
]
,
    editLink: { pattern: "https://https://github.com/GeoRegionsEcosystem/RegionGrids.jl/edit/main/docs/src/:path" },
    socialLinks: [
      { icon: 'github', link: 'https://github.com/GeoRegionsEcosystem/RegionGrids.jl' }
    ],
    footer: {
      message: 'Made with <a href="https://luxdl.github.io/DocumenterVitepress.jl/dev/" target="_blank"><strong>DocumenterVitepress.jl</strong></a><br>',
      copyright: `© Copyright ${new Date().getUTCFullYear()}.`
    }
  }
})
