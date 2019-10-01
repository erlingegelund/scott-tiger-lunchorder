<template>
  <div class="row align-items-center" style="background-color: #444444">
    <div class="col col-1">
      <!-- basic -->
      <span class="nav-button" v-show="showNavIcon">
        <octicon name="grabber" scale="3"></octicon>
      </span>
    </div>
    <div class="col col-10">
      <h1 class="st-head">scott/tiger frokostbestilling</h1>
    </div>
    <div class="col col-1" />
  </div>
</template>
<script>
import Octicon from "vue-octicon/components/Octicon.vue";
import "vue-octicon/icons";

export default {
  name: "Navigation",
  components: {
    Octicon
  },
  props: ["showNavIcon"]
};
</script>
<style scoped>
.nav-button {
  background-color: #aaaaaa;
  padding-left: 5px;
  padding-right: 5px;
  padding-top: 8px;
  padding-bottom: 8px;
  border-style: solid;
  border-color: #000000;
  border-width: 1px;
  margin-left: 20px;
}
</style>
