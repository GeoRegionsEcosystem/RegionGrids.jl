import{R as p}from"./chunks/theme.D7XRTHBs.js";import{R as s,a4 as i,a5 as u,a6 as c,a7 as l,a8 as f,a9 as d,aa as m,ab as h,ac as g,ad as A,d as v,u as R,v as w,s as y,ae as C,af as P,ag as b,ah as E}from"./chunks/framework.Dqe5nu7N.js";function r(e){if(e.extends){const a=r(e.extends);return{...a,...e,async enhanceApp(t){a.enhanceApp&&await a.enhanceApp(t),e.enhanceApp&&await e.enhanceApp(t)}}}return e}const n=r(p),S=v({name:"VitePressApp",setup(){const{site:e,lang:a,dir:t}=R();return w(()=>{y(()=>{document.documentElement.lang=a.value,document.documentElement.dir=t.value})}),e.value.router.prefetchLinks&&C(),P(),b(),n.setup&&n.setup(),()=>E(n.Layout)}});async function T(){globalThis.__VITEPRESS__=!0;const e=_(),a=D();a.provide(u,e);const t=c(e.route);return a.provide(l,t),a.component("Content",f),a.component("ClientOnly",d),Object.defineProperties(a.config.globalProperties,{$frontmatter:{get(){return t.frontmatter.value}},$params:{get(){return t.page.value.params}}}),n.enhanceApp&&await n.enhanceApp({app:a,router:e,siteData:m}),{app:a,router:e,data:t}}function D(){return A(S)}function _(){let e=s;return h(a=>{let t=g(a),o=null;return t&&(e&&(t=t.replace(/\.js$/,".lean.js")),o=import(t)),s&&(e=!1),o},n.NotFound)}s&&T().then(({app:e,router:a,data:t})=>{a.go().then(()=>{i(a.route,t.site),e.mount("#app")})});export{T as createApp};
