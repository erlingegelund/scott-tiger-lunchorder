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
            <div class="row row-item align-items-center" v-for="cat in categories" :key="cat.vkey">
              <div class="col col-md-10">
                <b-form-input
                  type="text"
                  size="sm"
                  v-model="cat.category_name"
                  v-if="cat.edit == true"
                  required
                  :class="{ 'is-invalid': cat.submitted && !cat.password }"
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
import Axios from "axios";
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
      this.setVKey(category);
      this.categories.push(category);
    },
    edit(cat) {
      cat.edit = true;
      this.setVKey(cat);
    },
    submit(cat) {
      if (cat.category_name) {
        if (cat.category_id < 0) {
          Axios.post(STLunchHelper.categoryURL, cat).then(response => {
            cat.category_id = response.data.category_id;
          });
        } else {
          Axios.put(STLunchHelper.categoryURL + cat.category_id, cat);
        }
        cat.edit = false;
        cat.submitted = false;
      } else {
        cat.submitted = true;
      }
      this.setVKey(cat);
    },
    del(cat) {
      Axios.delete(STLunchHelper.categoryURL + cat.category_id).then(
        response => {
          var filtered = this.categories.filter(
            c => c.category_id != cat.category_id
          );
          this.categories = filtered;
        }
      );
    },
    setVKey(cat) {
      var vkey = cat.category_id.toString() + ":";
      if (cat.edit === true || cat.edit === false) {
        vkey += cat.edit.toString();
      }
      vkey += ":";
      if (cat.submitted) {
        vkey += cat.submitted.toString();
      }
      cat.vkey = vkey;
    }
  },
  created: function() {
    Axios.get(STLunchHelper.categoryURL).then(response => {
      var categories = response.data.items;
      for (var i in categories) {
        this.setVKey(categories[i]);
      }
      categories.sort((c1, c2) =>
        c1.category_name > c2.category_name ? 1 : -1
      );
      this.categories = categories;
    });
  }
};
</script>