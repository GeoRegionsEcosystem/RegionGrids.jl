```@raw html
<script setup lang="ts">
import Gallery from "../components/Gallery.vue";

const types = [
  {
    href: "types/rectilinear",
    src: "images/isin.png",
    caption: "Rectilinear",
    desc: "Rectilinear Lon/Lat Grids"
  },
  {
    href: "types/generalized",
    src: "images/ison.png",
    caption: "Generalized",
    desc: "Curvilinear or Nonlinear Lon/Lat Grids"
  },
  {
    href: "types/unstructured",
    src: "images/isequal.png",
    caption: "Unstructured",
    desc: "Unstructured Lon/Lat Grids and Meshes"
  }
];
</script>

# Types of GeoRegions

<Gallery :images="types" />
```