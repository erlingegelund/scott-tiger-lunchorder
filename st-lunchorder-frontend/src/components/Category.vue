'<template>
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
            <div class="row row-item align-items-center" v-for="cat in categories" :key="cat.category_id">
              <div class="col col-md-10">
                <b-form-input
                  type="text"
                  size="sm"
                  v-model="cat.category_name"
                  v-if="cat.edit == true"
                  required
                  :class="{ 'is-invalid': cat.submitted && !cat.category_name }"
                ></b-form-input>
                <span v-else>{{cat.category_name}}</span>
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
import { STLunchHelper } from "../_helpers/stlunch";
import "vue-octicon/icons";

export default {
  components: { Navigation, Octicon },
  data() {
    return {
      categories: []
    };
  },
  methods: {
    add() {
      var category = {
        category_id: -this.categories.length * 10,
        category_name: "",
        edit: true
      };
      this.categories.push(category);
    },
    edit(cat) {
      cat.edit = true;
    },
    submit(cat) {
      STLunchHelper.submitCategory(cat);
    },
    del(cat) {
      STLunchHelper.deleteCategory(cat, this);
    }
  },
  created: function() {
    STLunchHelper.fetchCategories(this);
  }
};
</script>