<template>
  <div>
    <Navigation :showNavIcon="true"></Navigation>
    <div class="container-fluid">
      <div class="row component-header">
        <div class="col">
          <h2>Menu: {{supplier.supplier_name}}</h2>
        </div>
      </div>
      <div class="row" style="margin-top: 20px;">
        <div class="col">
          <div class="container-fluid">
            <div class="row row-supplier">
              <div class="col col-md-2">
                <span style="padding-left: 14px;">Kategori</span>
              </div>
              <div class="col col-md-6">Beskrivelse</div>
              <div class="col col-md-2">Pris</div>
              <div class="col" style="text-align: right;">
                <span @click="add()">
                  <octicon name="plus"></octicon>
                </span>
              </div>
            </div>
            <div class="row" v-for="m in menu" :key="m.vkey">
              <div class="col">
                <div class="row row-item">
                  <div class="col col-md-2" @click="display(m)">
                    <span v-if="m.edit">
                      <b-input-group>
                        <span style="margin-top: 5px;">
                          <octicon name="chevron-down" />
                        </span>
                        <b-form-select
                          v-model="m.category_id"
                          size="sm"
                          :options="categories"
                          @change="setCategoryName(m)"
                          :class="{ 'is-invalid': m.submitted && !m.category_id }"
                        ></b-form-select>
                      </b-input-group>
                    </span>
                    <span v-else-if="m.display">
                      <span>
                        <octicon name="chevron-down" />
                      </span>
                      {{m.category_name}}
                    </span>
                    <span v-else>
                      <span style="margin-right: 2px;">
                        <octicon name="chevron-right" />
                      </span>
                      {{m.category_name}}
                    </span>
                  </div>
                  <div class="col col-md-6" @click="display(m)">
                    <span v-if="m.edit">
                      <b-form-input
                        type="text"
                        v-model="m.description"
                        required
                        size="sm"
                        :class="{ 'is-invalid': m.submitted && !m.description }"
                      ></b-form-input>
                    </span>
                    <span v-else>{{m.description}}</span>
                  </div>
                  <div class="col col-md-1" @click="display(m)">
                    <span v-if="m.edit">
                      <b-form-input
                        type="number"
                        v-model="m.price"
                        required
                        size="sm"
                        :class="{ 'is-invalid': m.submitted && !m.price}"
                      ></b-form-input>
                    </span>
                    <span v-else>kr {{m.price}}</span>
                  </div>
                  <div class="col" style="text-align: right;">
                    <span class="btn-check" v-if="m.edit == true" @click="submit(m)">
                      <octicon name="check"></octicon>
                    </span>
                    <span class="btn-edit" v-else @click="edit(m)">
                      <octicon name="pencil"></octicon>
                    </span>
                    <span class="btn-delete" @click="del(m)">
                      <octicon name="x"></octicon>
                    </span>
                  </div>
                </div>
                <div class="row row-category compact-row" v-show="m.display || m.edit">
                  <div class="col col-md-1" />
                  <div class="col col-md-6">Valg</div>
                  <div class="col" style="text-align: right;">
                    <span @click="addOption(m)" v-show="m.edit">
                      <octicon name="plus"></octicon>
                    </span>
                  </div>
                  <div class="col col-md-1" />
                </div>
                <div
                  class="row align-items-start compact-row"
                  v-for="opt in m.options"
                  :key="opt.menu_option_id"
                  v-show="m.display || m.edit"
                >
                  <div class="col col-md-1" />
                  <div class="col col-md-6">
                    <b-form-input
                      type="text"
                      placeholder="Beskrivelse"
                      required
                      size="sm"
                      :disabled="!m.edit"
                      v-model="opt.description"
                      :class="{ 'is-invalid': m.submitted && !opt.description }"
                    />
                    <b-form-checkbox
                      value="Y"
                      unchecked-value="N"
                      size="sm"
                      :disabled="!m.edit"
                      v-model="opt.mandatory_yn"
                    >Obligatorisk</b-form-checkbox>
                    <b-form-checkbox
                      value="Y"
                      unchecked-value="N"
                      size="sm"
                      :disabled="!m.edit"
                      v-model="opt.multiple_yn"
                    >Flere muligheder kan vælges</b-form-checkbox>
                    <b-input
                      type="number"
                      placeholder="Pristillæg"
                      size="sm"
                      :disabled="!m.edit"
                      v-model="opt.additionalPrice"
                    />
                  </div>
                  <div class="col col-md-3">
                    <b-form-textarea
                      rows="5"
                      placeholder="Muligheder"
                      size="sm"
                      :disabled="!m.edit"
                      v-model="opt.selectables"
                      :class="{ 'is-invalid': m.submitted && !opt.selectables }"
                    ></b-form-textarea>
                  </div>
                  <div class="col col-md-1" style="text-align: right;">
                    <span class="btn-delete" v-show="m.edit" @click="delOption(m,opt)">
                      <octicon name="x"></octicon>
                    </span>
                  </div>
                  <div class="col" />
                </div>
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

const supSupplierMenuURL =
  "/ords/st_lunch/stlunch_suppliers/stlunch_supplier_menus/";
const menuOptionsURL =
  "/ords/st_lunch/stlunch_supplier_menus/stlunch_menu_options/";

export default {
  name: "Menu",
  components: { Navigation, Octicon },
  data() {
    return {
      supplier: { supplier_id: "", supplier_name: "" },
      menu: [],
      categories: []
    };
  },
  methods: {
    setVKey(mitem) {
      var options = 0;
      if (mitem.options) options = mitem.options.length;
      if (mitem.edit != true) mitem.edit = false;
      if (mitem.display != true) mitem.display = false;
      mitem.vkey = mitem.supplier_menu_id.toString() + ":" + options;
      ":" + mitem.edit.toString() + ":" + mitem.display.toString();
      if (mitem.submitted === true || mitem.submitted === false) {
        mitem.vkey += ":" + mitem.submitted.toString();
      }
    },
    setCategoryName(mitem) {
      var categoryName = "Ukendt";
      var filtered = this.categories.filter(c => c.value == mitem.category_id);
      if (filtered && filtered.length > 0) categoryName = filtered[0].text;

      mitem.category_name = categoryName;
    },
    display(mitem) {
      if (mitem.edit !== true) {
        mitem.edit = false;
        if (mitem.display === true) {
          mitem.display = false;
        } else {
          mitem.display = true;
        }
      }
      this.setVKey(mitem);
      this.fetchMenuOptions(mitem, mitem.display, mitem.edit, null);
    },
    add() {
      var m = {
        supplier_menu_id: -this.menu.length,
        supplier_id: this.supplier.supplier_id,
        description: "",
        price: 0,
        options: [],
        category_id: null,
        category_name: null,
        edit: true
      };
      this.menu.push(m);
      this.setVKey(m);
    },
    edit(mitem) {
      if (mitem.edit === true || mitem.edit === false) {
        mitem.edit = !mitem.edit;
      } else {
        mitem.edit = true;
      }
      this.fetchMenuOptions(mitem, !mitem.edit, mitem.edit, false);
    },
    submit(mitem) {
      var allMandatoryFilled =
        mitem.category_id && mitem.description && mitem.price;
      for (var i in mitem.options) {
        allMandatoryFilled =
          allMandatoryFilled &&
          mitem.options[i].description &&
          mitem.options[i].selectables;
      }
      if (allMandatoryFilled) {
        mitem.edit = false;
        mitem.price = Number.parseInt(mitem.price);
      } else {
        mitem.submitted = true;
      }
      this.setVKey(mitem);
      // Do REST
      if (mitem.supplier_menu_id < 0) {
        Axios.post(STLunchHelper.supplierMenuURL, mitem).then(response => {
          mitem.supplier_menu_id = response.data.supplier_menu_id;
          for (var i in mitem.options) {
            mitem.options[i].supplier_menu_id = mitem.supplier_menu_id;
            Axios.post(STLunchHelper.menuOptionsURL, mitem.options[i]).then(
              optresponse => {
                mitem.options[i].menu_option_id =
                  optresponse.data.menu_option_id;
              }
            );
          }
        });
      } else {
        Axios.put(
          STLunchHelper.supplierMenuURL + mitem.supplier_menu_id,
          mitem
        );
        for (var i in mitem.options) {
          if (option.menu_option_id < 0) {
            Axios.post(STLunchHelper.menuOptionsURL, option).then(response => {
              option.menu_option_id = response.data.menu_option_id;
            });
          } else {
            Axios.put(
              STLunchHelper.menuOptionsURL + option.menu_option_id,
              option
            );
          }
        }
      }
    },
    del(mitem) {
      var filtered = this.menu.filter(
        m => m.supplier_menu_id != mitem.supplier_menu_id
      );
      this.menu = filtered;
      Axios.delete(STLunchHelper.supplierMenuURL + mitem.supplier_menu_id);
    },
    addOption(m) {
      var newId = -99;
      if (m.options) {
        newId = (m.options.length + 1) * -100;
      }
      var opt = {
        menu_option_id: newId,
        supplier_menu_id: m.supplier_menu_id,
        description: "",
        mandatory_yn: "N",
        multiple_yn: "N",
        selectables: "",
        additionalPrice: null
      };
      m.options.push(opt);
      this.setVKey(m);
    },
    delOption(m, opt) {
      var filtered = m.options.filter(
        o => o.menu_option_id != opt.menu_option_id
      );
      m.options = filtered;
      this.setVKey(m);
      Axios.delete(STLunchHelper.menuOptionsURL + option.menu_option_id);
    },
    fetchCategories() {
      return Axios.get(STLunchHelper.categoryURL);
    },
    fetchMenu(supplierId) {
      return Axios.get(supSupplierMenuURL + supplierId);
    },
    fetchMenuOptions(m, display, edit, submitted) {
      if (!m.options) {
        Axios.get(menuOptionsURL + m.supplier_menu_id).then(response => {
          m.options = response.data.items;
          m.display = display;
          m.edit = edit;
          m.submitted = submitted;
          this.setVKey(m);
        });
      }
      // else {
      //   m.display = display;
      //   m.edit = edit;
      //   m.submitted = submitted;
      //   this.setVKey(m);
      // }
    }
  },
  created: function() {
    var supplierId = this.$route.params.supplier;
    var _self = this;

    Axios.get(STLunchHelper.supplierURL + supplierId)
      .then(response => {
        this.supplier.supplier_name = response.data.supplier_name;
        this.supplier.supplier_id = supplierId;
      })
      .catch(error => console.log(error));

    // samtidig kald af REST - nødvendig fordi menu manipuleres på baggrund af categories
    Axios.all([this.fetchCategories(), this.fetchMenu(supplierId)]).then(
      Axios.spread(function(fcat, fmenu) {
        var dbCat = fcat.data.items;
        // Omdøb attributter i categories for at kunne anvendes i b-form-select
        var catJSON = JSON.stringify(dbCat).replace(
          /\"category_id\":/g,
          '"value":'
        );
        var catJSON = catJSON.replace(/\"category_name\":/g, '"text":');
        _self.categories = JSON.parse(catJSON);
        _self.categories.sort((c1, c2) => (c1.text > c2.text ? 1 : -1));

        var menuItems = fmenu.data.items;
        // Sæt vkey og category_name i menu
        for (var i in menuItems) {
          _self.setVKey(menuItems[i]);
          _self.setCategoryName(menuItems[i]);
        }
        _self.menu = menuItems;
      })
    );
  }
};
</script>

<style scoped>
.compact-row {
  line-height: 1;
  border-bottom: 1px solid lightgray;
  padding-bottom: 2px;
  margin-bottom: 2px;
}
</style>