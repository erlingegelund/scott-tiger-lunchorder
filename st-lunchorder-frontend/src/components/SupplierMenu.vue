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
                        v-model="m.menu_name"
                        required
                        size="sm"
                        :class="{ 'is-invalid': m.submitted && !m.menu_name }"
                      ></b-form-input>
                    </span>
                    <span v-else>{{m.menu_name}}</span>
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
                    <span class="btn-delete" @click="confirmDelMenu(m)">
                      <octicon name="x"></octicon>
                    </span>
                  </div>
                </div>
                <div class="row compact-row" v-show="(m.display)|| m.edit">
                  <div class="col col-md-1"/>
                  <div class="col col-md-1">Beskrivelse</div>
                  <div class="col col-md-5">
                    <span v-if="m.edit">
                      <b-form-input
                        type="text"
                        v-model="m.description"
                        required
                        size="sm"
                      ></b-form-input>
                    </span>
                    <span v-else>{{m.description}}</span>
                  </div>
                </div>
                <div class="row row-category compact-row" v-show="(m.display && m.options.length > 0) || m.edit">
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
                    <b-input-group size="sm" prepend="Sortering: ">
                      <b-form-input
                        type="number"
                        size="sm"
                        :disabled="!m.edit"
                        v-model="opt.sort_order"
                      />
                    </b-input-group>
                    <b-input-group size="sm" prepend="Pristillæg: ">
                      <b-form-input
                        type="number"
                        size="sm"
                        :disabled="!m.edit"
                        v-model="opt.additional_price"
                      />
                    </b-input-group>
                  </div>
                  <div class="col col-md-3">
                    <b-form-textarea
                      rows="6"
                      placeholder="Muligheder"
                      size="sm"
                      :disabled="!m.edit"
                      v-model="opt.selectables"
                      :class="{ 'is-invalid': m.submitted && !opt.selectables }"
                    ></b-form-textarea>
                  </div>
                  <div class="col col-md-1" style="text-align: right;">
                    <span class="btn-delete" v-show="m.edit" @click="confirmDelOption(m,opt)">
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
      <b-modal id="d-confirm-menu" title="Bekræft slet" @ok="delMenuConfirmed">
        Er du sikker på, at vil slette menu 
        <i>
          <b>{{menuToDelete.menu_name}}</b>
        </i>?
      </b-modal>
      <b-modal id="d-confirm-option" title="Bekræft slet" @ok="delOptionConfirmed">
        Er du sikker på, at vil slette valgmuligheden 
        <i>
          <b>{{optionToDelete.description}}</b>
        </i>?
      </b-modal>
    </div>
  </div>
</template>
<script>
import Navigation from "./Navigation";
import axios from "axios";
import Octicon from "vue-octicon/components/Octicon.vue";
import { STLunchHelper } from "../_helpers/stlunch";

const supSupplierMenuURL =
  "/ords/stlunch/service-supplier/menus/";
const menuOptionsURL =
  "/ords/stlunch/service-menu/options/";

export default {
  name: "Menu",
  components: { Navigation, Octicon },
  data() {
    return {
      supplier: { supplier_id: "", supplier_name: "" },
      menu: [],
      categories: [],
      menuToDelete: {menu_name: ""},
      optionToDelete: {description: ""}
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
        supplier_menu_id: (this.menu.length+1) * -1,
        supplier_id: this.supplier.supplier_id,
        menu_name: "",
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
        mitem.category_id && mitem.menu_name && mitem.price;
      for (var i in mitem.options) {
        allMandatoryFilled =
          allMandatoryFilled &&
          mitem.options[i].description &&
          mitem.options[i].selectables;
      }
      if (allMandatoryFilled) {
        mitem.edit = false;
        mitem.display = true;
        mitem.price = Number.parseInt(mitem.price);
        this.insertUpdate(mitem)
      } else {
        mitem.submitted = true;
      }
      this.setVKey(mitem);
    },
    confirmDelMenu(mitem) {
      this.menuToDelete = mitem;
      this.$bvModal.show("d-confirm-menu");
    },
    delMenuConfirmed() {
      var mitem = this.menuToDelete;
      var filtered = this.menu.filter(
        m => m.supplier_menu_id != mitem.supplier_menu_id
      );
      this.menu = filtered;
      axios.delete(STLunchHelper.supplierMenuURL + mitem.supplier_menu_id).then(response => {
        mitem.menu_name = "";
        mitem.menud_id = 0;
      });
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
        additional_price: null,
        sort_order: (m.options.length + 1)
      };
      m.options.push(opt);
      this.setVKey(m);
    },
    confirmDelOption(m, opt) {
      this.menuToDelete = m;
      this.optionToDelete = opt;
      this.$bvModal.show("d-confirm-option");
    },
    delOptionConfirmed() {
      var m = this.menuToDelete;
      var opt = this.optionToDelete;
      var filtered = m.options.filter(
        o => o.menu_option_id != opt.menu_option_id
      );
      m.options = filtered;
      this.setVKey(m);
      axios.delete(STLunchHelper.menuOptionsURL + opt.menu_option_id).then(response => {
        opt.option_id = 0;
        opt.description = "";
      })
    },
    fetchCategories() {
      return axios.get(STLunchHelper.categoryURL);
    },
    fetchMenu(supplierId) {
      return axios.get(supSupplierMenuURL + supplierId);;
    },
    fetchMenuOptions(m, display, edit, submitted) {
      if (!m.options || m.options.length == 0) {
        axios.get(menuOptionsURL + m.supplier_menu_id).then(response => {
          let options = response.data.items;
          m.options = options.sort((o1,o2) => 
            ((o1.sort_order && o2.sort_order && o1.sort_order > o2.sort_order) ||
            ((!o1.sort_order || !o2.sort_order) && o1.description > o2.description))
            ? 1 : -1);
          m.display = display;
          m.edit = edit;
          m.submitted = submitted;
          this.setVKey(m);
        });
      }
    }, 
    insertUpdate(mitem) {
      // Do REST
      if (mitem.supplier_menu_id < 0) {
        axios.post(STLunchHelper.supplierMenuURL, mitem).then(response => {
          mitem.supplier_menu_id = response.data.supplier_menu_id;
          for (var i in mitem.options) {
            mitem.options[i].supplier_menu_id = mitem.supplier_menu_id;
            axios.post(STLunchHelper.menuOptionsURL, mitem.options[i]).then(
              optresponse => {
                mitem.options[i].menu_option_id =
                  optresponse.data.menu_option_id;
              }
            );
          }
          this.setVKey(mitem);
        });
      } else {
        axios.put(
          STLunchHelper.supplierMenuURL + mitem.supplier_menu_id,
          mitem
        );
        for (var i in mitem.options) {
          if (mitem.options[i].menu_option_id < 0) {
            axios.post(STLunchHelper.menuOptionsURL, mitem.options[i]).then(response => {
              mitem.options[i].menu_option_id = response.data.menu_option_id;
            });
          } else {
            axios.put(
              STLunchHelper.menuOptionsURL + mitem.options[i].menu_option_id,
              mitem.options[i]
            );
          }
        }
      }
    }
  },
  created: function() {
    var supplierId = this.$route.params.supplier;
    var _self = this;

    axios.get(STLunchHelper.supplierURL + supplierId)
      .then(response => {
        this.supplier.supplier_name = response.data.supplier_name;
        this.supplier.supplier_id = supplierId;
      })

    // samtidig kald af REST - nødvendig fordi menu manipuleres på baggrund af categories
    axios.all([this.fetchCategories(), this.fetchMenu(supplierId)]).then(
      axios.spread(function(fcat, fmenu) {
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
          menuItems[i].options = [];
          _self.setVKey(menuItems[i]);
          //_self.setCategoryName(menuItems[i]);
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