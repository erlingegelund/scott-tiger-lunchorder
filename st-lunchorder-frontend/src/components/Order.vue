<template>
  <div>
    <Navigation :showNavIcon="true"></Navigation>
    <div class="container-fluid">
      <div class="row component-header">
        <div class="col">
          <h2>Bestil frokost</h2>
        </div>
      </div>
      <div class="row" v-show="isAfterDeadline">
        <div class="col">
          <div
            v-if="isAfterReopen"
            class="alert alert-warning"
            role="alert"
          >Din bestilling vil være til næste hverdag</div>
          <div
            v-else-if="isAfterDeadline"
            class="alert alert-warning"
            role="alert"
          >Det er kun muligt at bestille indtil kl {{deadlineFormatted}}</div>
        </div>
      </div>
      <div v-for="sup in suppliers" :key="sup.id" class="row">
        <div class="col">
          <div @click="toggleChildren(sup)" class="row-supplier">
            <span v-if="sup.display === 'Y'" style="margin-left: 5px;">
              <octicon name="chevron-down" />
            </span>
            <span v-else style="margin-left: 5px;">
              <octicon name="chevron-right" />
            </span>
            {{sup.name}}
          </div>
          <div class="container-fluid" v-show="sup.display === 'Y'">
            <div v-for="mcat in sup.menu" :key="mcat.vkey" class="row">
              <div class="col">
                <div @click="toggleChildren(mcat)" class="row-category">
                  <span v-if="mcat.display === 'Y'">
                    <octicon name="chevron-down" />
                  </span>
                  <span v-else>
                    <octicon name="chevron-right" />
                  </span>
                  {{mcat.category}}
                </div>
                <div class="container-fluid" v-show="mcat.display === 'Y'">
                  <div v-for="mitem in mcat.items" :key="mitem.vkey">
                    <div class="row row-item">
                      <div class="col col-md-3">{{mitem.name}}</div>
                      <div class="col col-md-7">{{mitem.description}}</div>
                      <div class="col col-md-2" style="text-align: right;">{{mitem.price}} kr</div>
                    </div>
                    <div class="row" v-show="mitem.options.length > 0">
                      <div class="col col-md-2">
                        <span>Vælg:</span>
                      </div>
                      <div class="col col-md-6">
                        <div>
                          <div
                            v-for="opt in mitem.options"
                            :key="opt.description"
                            class="row row-option"
                          >
                            <div class="col">
                              <div
                                class="option-description"
                                v-bind:class="{'option-mandatory': opt.mandatory_yn === 'Y'}"
                              >
                                <span v-show="opt.mandatory_yn === 'Y'">*</span>
                                {{opt.description}}
                                <span
                                  v-show="opt.additionalPrice"
                                >(+ {{opt.additionalPrice}} kr)</span>
                              </div>
                              <multiselect
                                v-model="opt.value"
                                :options="opt.selections"
                                v-bind:multiple="opt.multiple_yn === 'Y'"
                                v-bind:close-on-select="opt.multiple_yn !== 'Y'"
                                @close="optionAutoOrder(mitem)"
                              />
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="row align-items-center">
                      <div class="col col-md-1">
                        <span>Kommentar:</span>
                      </div>
                      <div class="col">
                        <b-form-input type="text" v-model="mitem.comment" size="sm" />
                      </div>
                      <div
                        class="col-md-2"
                        style="text-align: right;"
                      >Antal: {{mitem.items_ordered}}</div>
                      <div class="col-md-2" style="text-align: right;">
                        <span>
                          <b-button
                            size="sm"
                            v-bind:disabled="mitem.items_ordered === 0"
                            @click="decrementOrder(mitem)"
                            style="margin-right: 2px;"
                          >-</b-button>
                          <b-button
                            size="sm"
                            @click="incrementOrder(mitem)"
                            v-bind:disabled="isMandatoryMissing(mitem)"
                          >+</b-button>
                        </span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="row" style="margin-top: 20px;">
        <div class="col col-1">
          <button
            class="btn btn-primary btn-lg"
            v-bind:disabled="order.items.length === 0 "
            @click="submitOrder()"
          >Bestil</button><!-- || (isAfterDeadline && !isAfterReopen) -->
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import Multiselect from "vue-multiselect";
import Axios from "axios";
import Octicon from "vue-octicon/components/Octicon.vue";
import "vue-octicon/icons";
import Navigation from "./Navigation.vue";
import { STLunchHelper } from "../_helpers/stlunch";

const supplierCategoriesURL = "/ords/st_lunch/suppliers_categories/prep_order/";
const menusOptionsURL = "/ords/st_lunch/menus_options/prep_order/";
const createOrderURL = "/ords/st_lunch/order/create/";

const getSupplierCatMenu = function(supplier, category) {
  var supplierId = 0;
  if (supplier) {
    supplierId = supplier.id;
  } else {
    supplierId = category.vkey.split(":")[0];
  }
  Axios.get(menusOptionsURL + supplierId + "/" + category.id).then(response => {
    var menuItems = response.data.items;
    for (var i in menuItems) {
      if (menuItems[i].options) {
        for (var n in menuItems[i].options) {
          var _selections = [];
          if (menuItems[i].options[n].selectables) {
            _selections = menuItems[i].options[n].selectables.split("\n");
          }
          menuItems[i].options[n].selections = _selections;
          menuItems[i].options[n].value = [];
        }
      } else {
        menuItems[i].options = [];
      }
      menuItems[i].vkey = menuItems[i].id+":"+menuItems[i].items_ordered
    }
    category.items = menuItems;
    category.vkey = supplierId + ":" + category.id + ":" + menuItems.length;
  });
};

export default {
  name: "Order",
  components: { Multiselect, Navigation, Octicon },
  methods: {
    toggleChildren(obj) {
      if (obj) {
        if (obj.display === "Y") {
          obj.display = "N";
        } else {
          obj.display = "Y";
          if (obj["category"] && !obj["items"]) {
            getSupplierCatMenu(null, obj);
          }
        }
      }
    },
    incrementOrder(item) {
      item.items_ordered++;
      var filtered = this.order.items.filter(i => i.menu_id == item.id);
      if (filtered.length < 1) {
        this.order.items.push({ menu_id: item.id });
      }
      item.vkey = item.id +":"+item.items_ordered
    },
    decrementOrder(item) {
      if (item.items_ordered > 0) {
        item.items_ordered--;
      }
      if (item.items_ordered == 0) {
        var filtered = this.order.items.filter(i => i.menu_id !== item.id);
        this.order.items = filtered;
      }
      item.vkey = item.id +":"+item.items_ordered
    },
    optionAutoOrder(item) {
      var filtered = this.order.items.filter(i => i.menu_id === item.id);
      if (!this.isMandatoryMissing(item) && filtered.length === 0) {
        this.incrementOrder(item);
      }
    },
    isMandatoryMissing(item) {
      var allFilled = true;
      if (item.options) {
        var manOpts = item.options.filter(opt => opt.mandatory_yn === "Y");
        for (var i in manOpts) {
          if (manOpts[i].multiple_yn === "Y" && manOpts[i].value.length === 0)
            allFilled = allFilled && false;
          else if (manOpts[i].multiple_yn !== "Y" && manOpts[i].value === "")
            allFilled = allFilled && false;
          else allFilled = allFilled && true;
        }
      }
      return !allFilled;
    },
    submitOrder() {
      // Persist the order
      for (var i in this.suppliers) {
        for (var j in this.suppliers[i].menu) {
          for (var k in this.suppliers[i].menu[j].items) {
            if (this.suppliers[i].menu[j].items[k].items_ordered > 0) {
              var orderedMenu = this.suppliers[i].menu[j].items[k];
              var orderedItem = this.order.items.filter(
                i => i.menu_id == orderedMenu.id
              );
              orderedItem[0].items_ordered = orderedMenu.items_ordered;
              orderedItem[0].comment = orderedMenu.comment;
              orderedItem[0].options = [];
              for (var n in orderedMenu.options) {
                if (
                  orderedMenu.options[n].value &&
                  orderedMenu.options[n].value.length
                ) {
                  let option = {
                    option_id: orderedMenu.options[n].id,
                    selected: orderedMenu.options[n].value
                  };
                  let l = orderedItem[0].options.length;
                  orderedItem[0].options[l] = option;
                }
              }
            }
          }
        }
      }
      var _router = this.$router
      Axios.post(createOrderURL, this.order).then(response => {
        _router.push({ name: "UserHistory", query: {orderItems: JSON.stringify(response.data)} })
      })

      //this.$router.push({ name: "UserHistory" });
    }
  },
  computed: {
    isAfterDeadline() {
      return !STLunchHelper.isBeforeDeadline(null, this.now);
    },
    deadlineFormatted() {
      return STLunchHelper.deadline;
    },
    isAfterReopen() {
      return STLunchHelper.isAfterReopen(this.now);
    }
  },
  data() {
    return {
      now: Date.now(),
      order: {
        user_id: 63, // TODO: hent fra localStorage
        items: []
      },
      suppliers: []
    };
  },
  created: function() {
    // Timer til at sikre computed felt isAfterDeadline er retvisende ift tidspunkt
    var self = this;
    setInterval(function() {
      self.now = Date.now();
    }, 30000);

    // TODO: erstat med userId gemt i localStorage
    var userId = 0;
    Axios.get(supplierCategoriesURL + userId.toString()).then(response => {
      var suppliersCategories = response.data.suppliers;
      var suppDisplay = suppliersCategories.filter(s => s.display === "Y");
      if (suppDisplay && suppDisplay.length > 0) {
        var catDisplay = suppDisplay[0].menu.filter(m => m.display === "Y");
        if (catDisplay && catDisplay.length > 0) {
          getSupplierCatMenu(suppDisplay[0], catDisplay[0]);
        }
      }
      this.suppliers = suppliersCategories;
    });
  }
};
</script>
<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

<style scoped>
.row-option {
  padding-bottom: 2px;
}
.option-description {
  color: #aaaaaa;
  font-size: 0.8em;
}
.option-mandatory {
  color: #444444;
}
</style>