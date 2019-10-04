<template>
  <div>
    <Navigation :showNavIcon="true"></Navigation>
    <div class="container-fluid">
      <div class="row component-header">
        <div class="col">
          <h2>Leverandøradministration</h2>
        </div>
      </div>
      <div class="row" style="margin-top: 20px;">
        <div class="col">
          <div class="container-fluid">
            <div class="row row-supplier">
              <div class="col col-md-4">Navn</div>
              <div class="col col-md-4">e-mail</div>
              <div class="col col-md-2">Telefonnummer</div>
              <div class="col" style="text-align: right;">
                <span @click="add()">
                  <octicon name="plus"></octicon>
                </span>
              </div>
            </div>
            <div
              class="row row-item align-items-center"
              v-for="sup in suppliers"
              :key="sup.vkey"
              @dblclick="showMenu(sup)"
            >
              <div class="col col-md-4">
                <b-form-input
                  type="text"
                  size="sm"
                  v-model="sup.name"
                  v-if="sup.edit == true"
                  required
                  :class="{ 'is-invalid': sup.submitted && !sup.name }"
                ></b-form-input>
                <span v-else>{{sup.name}}</span>
              </div>
              <div class="col col-md-4">
                <b-form-input
                  type="email"
                  size="sm"
                  v-model="sup.mail"
                  v-if="sup.edit == true"
                  required
                  :class="{ 'is-invalid': sup.submitted && !validateMail(sup) }"
                ></b-form-input>
                <span v-else>{{sup.mail}}</span>
              </div>
              <div class="col col-md-2">
                <b-form-input type="number" size="sm" v-model="sup.phone" v-if="sup.edit == true"></b-form-input>
                <span v-else>{{sup.phone}}</span>
              </div>
              <div class="col" style="text-align: right;">
                <span class="btn-check" v-if="sup.edit == true" @click="submit(sup)">
                  <octicon name="check"></octicon>
                </span>
                <span class="btn-edit" v-else @click="edit(sup)">
                  <octicon name="pencil"></octicon>
                </span>
                <span class="btn-delete" @click="del(sup)">
                  <octicon name="x"></octicon>
                </span>
                <span style="margin-left: 10px;" @click="showMenu(sup)">
                  <octicon name="ellipsis"></octicon>
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
      suppliers: []
    };
  },
  methods: {
    validateMail(supplier) {
      return STLunchHelper.validateMail(supplier.mail);
    },
    add() {
      var supplier = {
        id: -this.suppliers.length * 10,
        name: "",
        mail: "",
        phone: "",
        edit: true
      };
      this.suppliers.push(supplier);
    },
    edit(sup) {
      sup.edit = true;
      this.setVKey(sup);
    },
    submit(sup) {
      if (sup.mail && sup.name && this.validateMail(sup)) {
        sup.edit = false;
      } else {
        sup.submitted = true;
      }
      this.setVKey(sup);
    },
    del(sup) {
      var filtered = this.suppliers.filter(s => s.id != sup.id);
      this.suppliers = filtered;
    },
    showMenu(sup) {
      this.$router.push({ name: "Menu", params: { supplier: sup.id } });
    },
    setVKey(sup) {
      if (sup.edit != true) sup.edit = false;
      sup.vkey = sup.id.toString() + ":" + sup.edit.toString();
      if (sup.submitted === true || sup.submitted === false) {
        sup.vkey += ":" + sup.submitted.toString();
      }
    }
  },
  created: function() {
    Axios.get("/mocked/suppliers-mgmt.json").then(response => {
      var _suppliers = response.data.suppliers;
      // opret vkey i hver supplier element - bruges til at kontrollere visning
      for (var i in _suppliers) {
        this.setVKey(_suppliers[i]);
      }
      this.suppliers = _suppliers;
    });
  }
};
</script>
