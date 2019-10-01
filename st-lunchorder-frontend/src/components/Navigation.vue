<template>
  <div class="row align-items-center" style="background-color: #444444">
    <div class="col col-1">
<div v-show="showNavIcon">
  <b-dropdown size="lg"  variant="link" toggle-class="text-decoration-none" no-caret>
    <template v-slot:button-content>
      <span >
        <octicon name="grabber" scale="3"></octicon>
      </span>
    </template>
    <b-dropdown-item :to="{name: 'Order'}">Bestil frokost</b-dropdown-item>
    <b-dropdown-item :to="{name: 'UserHistory'}">Mine bestillinger</b-dropdown-item>
    <b-dropdown-item :to="{name: 'OrderHistory'}">Alle bestillinger</b-dropdown-item>
    <b-dropdown-item :to="{name: 'MonthlyReport'}">Månedsrapport</b-dropdown-item>
    <b-dropdown-item :to="{name: 'Supplier'}">Leverandøradministration</b-dropdown-item>
    <b-dropdown-item :to="{name: 'Category'}">Kategoriadministration</b-dropdown-item>
    <b-dropdown-item :to="{name: 'UserMgmt'}">Brugeradministration</b-dropdown-item>
  </b-dropdown>
</div>      
    </div>
    <div class="col col-10">
      <h1 class="st-head">scott/tiger frokostbestilling</h1>
    </div>
    <div class="col col-1">
      <b-dropdown size="sm" variant="link" right toggle-class="text-decoration-none">
        <template v-slot:button-content>{{getUser()}}</template>
        <b-dropdown-item>Skift kodeord</b-dropdown-item>
        <b-dropdown-item>Log af</b-dropdown-item>
      </b-dropdown>
    </div>
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
  props: ["showNavIcon"],
  methods: {
    getUser() {
      // TODO: Change to read from localStorage
      return "Herman Bang"
    }
  }
};
</script>
