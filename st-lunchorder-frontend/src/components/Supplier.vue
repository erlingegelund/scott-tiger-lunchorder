<template>
  <div>
    <Navigation :showNavIcon="true"></Navigation>
    <div class="container-fluid">
      <div class="row component-header">
        <div class="col">
          <h2>Leverandøradministration</h2>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import Navigation from "./Navigation";
export default {
  components: { Navigation }
};
</script>
