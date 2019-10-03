<template>
  <div>
    <Navigation :showNavIcon="true"></Navigation>
    <div class="container-fluid">
      <div class="row component-header">
        <div class="col">
          <h2>Kategoriadministration</h2>
        </div>
      </div>
      <div class="row" style="margin-top: 20px;">
        <div class="col col-md-6">
          <div class="container-fluid">
            <div class="row row-supplier align-items-center">
              <div class="col col-md-10">Kategori</div>
              <div class="col" style="text-align: right;">
                <span @click="add()">
                  <octicon name="plus"></octicon>
                </span>
              </div>
            </div>
            <div class="row row-item align-items-center" v-for="cat in categories" :key="cat.id">
              <div class="col col-md-10">
                <b-form-input
                  type="text"
                  size="sm"
                  v-model="cat.name"
                  v-if="cat.edit == true"
                  required
                  :class="{ 'is-invalid': cat.submitted && !cat.password }"
                ></b-form-input>
                <span v-else>{{cat.name}}</span>
              </div>
              <div class="col" style="text-align: right;">
                <span class="btn-check" v-if="cat.edit" @click="submit(cat)">
                  <octicon name="check"></octicon>
                </span>
                <span class="btn-edit" v-else @click="edit(cat)">
                  <octicon name="pencil"></octicon>
                </span>
                <span class="btn-delete" @click="del(cat)">
                  <octicon name="x"></octicon>
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import Navigation from "./Navigation";
import Octicon from "vue-octicon/components/Octicon.vue";
import "vue-octicon/icons";

export default {
  components: { Navigation, Octicon },
  data() {
    return {
      categories: [
        { id: 1, name: "Salater" },
        { id: 2, name: "Smørrebrød" },
        { id: 3, name: "Bagels" },
        { id: 4, name: "Sandwich" },
        { id: 5, name: "Boller" }
      ]
    };
  },
  methods: {
    add() {
      var category = { id: -this.categories.length * 10, name: "", edit: true };
      this.categories.push(category);
    },
    edit(cat) {
      cat.edit = true;
      cat.id += 0.0001;
      cat.submitted = false;
    },
    submit(cat) {
      cat.id -= 0.0001
      if (cat.name) {
        cat.id = parseInt(cat.id.toFixed(0))
        cat.edit = false;
      } else {
        cat.submitted = true;
      }
    },
    del(cat) {
      var filtered = this.categories.filter(c => c.id != cat.id);
      this.categories = filtered;
    }
  }
};
</script>