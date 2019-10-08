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
                  v-model="sup.supplier_name"
                  v-if="sup.edit == true"
                  required
                  :class="{ 'is-invalid': sup.submitted && !sup.name }"
                ></b-form-input>
                <span v-else>{{sup.supplier_name}}</span>
              </div>
              <div class="col col-md-4">
                <b-form-input
                  type="email"
                  size="sm"
                  v-model="sup.supplier_email"
                  v-if="sup.edit == true"
                  required
                  :class="{ 'is-invalid': sup.submitted && !validateMail(sup) }"
                ></b-form-input>
                <span v-else>{{sup.supplier_email}}</span>
              </div>
              <div class="col col-md-2">
                <b-form-input
                  type="number"
                  size="sm"
                  v-model="sup.supplier_phone"
                  v-if="sup.edit == true"
                ></b-form-input>
                <span v-else>{{sup.supplier_phone}}</span>
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

const supplierURL = "/ords/st_lunch/stlunch_suppliers/";

export default {
  components: { Navigation, Octicon },
  data() {
    return {
      suppliers: []
    };
  },
  methods: {
    validateMail(supplier) {
      return STLunchHelper.validateMail(supplier.supplier_email);
    },
    add() {
      var supplier = {
        supplier_id: -this.suppliers.length * 10,
        supplier_name: "",
        supplier_email: "",
        supplier_phone: "",
        edit: true
      };
      this.suppliers.push(supplier);
    },
    edit(sup) {
      sup.edit = true;
      this.setVKey(sup);
    },
    submit(sup) {
      if (sup.supplier_email && sup.supplier_name && this.validateMail(sup)) {
        if (sup.supplier_id < 0) {
          Axios.post(supplierURL, sup)
            .then(response => {
              sup.supplier_id = response.data.supplier_id;
            })
            .catch(error => {
              console.log(error);
            });
        } else {
          Axios.put(supplierURL + "/" + sup.supplier_id.toString(), sup).catch(
            error => {
              console.log(error);
            }
          );
        }
        sup.edit = false;
        sup.submitted = false;
      } else {
        sup.submitted = true;
      }
      this.setVKey(sup);
    },
    del(sup) {
      Axios.delete(supplierURL + "/" + sup.supplier_id.toString())
        .then(response => {
          var filtered = this.suppliers.filter(
            s => s.supplier_id != sup.supplier_id
          );
          this.suppliers = filtered;
        })
        .catch(error => {
          console.log(error);
        });
    },
    showMenu(sup) {
      this.$router.push({
        name: "Menu",
        params: { supplier: sup.supplier_id }
      });
    },
    setVKey(sup) {
      if (sup.edit != true) sup.edit = false;
      sup.vkey = sup.supplier_id.toString() + ":" + sup.edit.toString();
      if (sup.submitted === true || sup.submitted === false) {
        sup.vkey += ":" + sup.submitted.toString();
      }
    }
  },
  created: function() {
    Axios.get(supplierURL)
      .then(response => {
        var _suppliers = response.data.items;
        // opret vkey i hver supplier element - bruges til at kontrollere visning
        for (var i in _suppliers) {
          this.setVKey(_suppliers[i]);
        }
        _suppliers.sort((s1,s2) => (s1.supplier_name > s2.supplier_name) ? 1 : -1)
        this.suppliers = _suppliers;
      })
      .catch(error => {
        console.log(error);
      });
  }
};
</script>
