<template>
  <div class="row align-items-center" style="background-color: #444444">
    <div class="col col-md-2">
      <div v-show="showNavIcon">
        <b-dropdown size="lg" variant="link" toggle-class="text-decoration-none" no-caret>
          <template v-slot:button-content>
            <span>
              <octicon name="three-bars" scale="2"></octicon>
            </span>
          </template>
          <b-dropdown-item :to="{name: 'Order'}">Bestil frokost</b-dropdown-item>
          <b-dropdown-item :to="{name: 'UserHistory'}">Mine bestillinger</b-dropdown-item>
          <b-dropdown-item :to="{name: 'OrderHistory'}">Dagens bestillinger</b-dropdown-item>
          <b-dropdown-item :to="{name: 'MonthlyReport'}">Månedsrapport</b-dropdown-item>
          <b-dropdown-item :to="{name: 'Supplier'}" v-show="isAdministrator()">Leverandøradministration</b-dropdown-item>
          <b-dropdown-item :to="{name: 'Category'}" v-show="isAdministrator()">Kategoriadministration</b-dropdown-item>
          <b-dropdown-item :to="{name: 'UserMgmt'}" v-show="isAdministrator()">Brugeradministration</b-dropdown-item>
        </b-dropdown>
      </div>
    </div>
    <div class="col">
      <h1 class="st-head">scott/tiger frokostbestilling</h1>
    </div>
    <div class="col col-md-2" style="text-align: right;">
      <b-dropdown size="sm" variant="link" right toggle-class="text-decoration-none" v-show="showNavIcon">
        <template v-slot:button-content>{{getUser()}}</template>
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
      return "Herman Bang";
    },
    isAdministrator() {
      // TODO: Change to read from localStorage
      return false
    }
  }
};
</script>
