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
            v-show="isAfterDeadline"
            class="alert alert-warning"
            role="alert"
          >Det er kun muligt at bestille indtil kl {{deadlineFormatted}}</div>
        </div>
      </div>
      <div v-for="sup in suppliers" :key="sup.id" class="row">
        <div class="col">
          <div @click="toggleChildren(sup)" class="row-supplier">
            <span v-if="sup.display" style="margin-left: 5px;">
              <octicon name="chevron-down" />
            </span>
            <span v-else style="margin-left: 5px;">
              <octicon name="chevron-right" />
            </span>
            {{sup.name}}
          </div>
          <div class="container-fluid" v-show="sup.display">
            <div v-for="mcat in sup.menu" :key="mcat.catergory" class="row">
              <div class="col">
                <div @click="toggleChildren(mcat)" class="row-category">
                  <span v-if="mcat.display">
                    <octicon name="chevron-down" />
                  </span>
                  <span v-else>
                    <octicon name="chevron-right" />
                  </span>
                  {{mcat.category}}
                </div>
                <div class="container-fluid" v-show="mcat.display">
                  <div v-for="mitem in mcat.items" :key="mitem.id">
                    <div class="row row-item">
                      <div class="col col-md-10">{{mitem.description}}</div>
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
                                v-bind:class="{'option-mandatory': opt.mandatory}"
                              >
                                <span v-show="opt.mandatory">*</span>
                                {{opt.description}}
                                <span
                                  v-show="opt.additionalPrice"
                                >(+ {{opt.additionalPrice}} kr)</span>
                              </div>
                              <multiselect
                                v-model="opt.value"
                                :options="opt.selections"
                                v-bind:multiple="opt.multiple"
                                v-bind:close-on-select="!opt.multiple"
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
                        <b-form-input type="text" v-model="mitem.comment" size="sm"/>
                      </div>
                      <div class="col-md-2" style="text-align: right;">Antal: {{mitem.itemsOrdered}}</div>
                      <div class="col-md-2" style="text-align: right;">
                        <span>
                          <b-button
                            size="sm"
                            v-bind:disabled="mitem.itemsOrdered === 0"
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
            v-bind:disabled="order.items.length === 0 || isAfterDeadline"
            @click="submitOrder()"
          >Bestil</button>
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
export default {
  name: "Order",
  components: { Multiselect, Navigation, Octicon },
  methods: {
    toggleChildren(obj) {
      if (obj) {
        if (obj.display) {
          obj.display = false;
        } else {
          obj.display = true;
        }
      }
    },
    incrementOrder(item) {
      item.itemsOrdered++;
      this.order.items.push(item.id);
    },
    decrementOrder(item) {
      if (item.itemsOrdered > 0) {
        item.itemsOrdered--;
      }
      var filtered = this.order.items.filter(id => id !== item.id);
      this.order.items = filtered;
    },
    optionAutoOrder(item) {
      var filtered = this.order.items.filter(id => id === item.id);
      if (!this.isMandatoryMissing(item) && filtered.length === 0) {
        this.incrementOrder(item);
      }
    },
    isMandatoryMissing(item) {
      var allFilled = true;
      if (item.options) {
        var manOpts = item.options.filter(opt => opt.mandatory);
        for (var i in manOpts) {
          if (manOpts[i].multiple && manOpts[i].value.length === 0)
            allFilled = allFilled && false;
          else if (!manOpts[i].multiple && manOpts[i].value === "")
            allFilled = allFilled && false;
          else allFilled = allFilled && true;
        }
      }
      return !allFilled;
    },
    submitOrder() {
      // Persist the order
      this.$router.push({ name: "UserHistory" });
    }
  },
  computed: {
    isAfterDeadline() {
      return !STLunchHelper.isBefore(null, this.now);
    },
    deadlineFormatted() {
      return STLunchHelper.getDeadline();
    }
  },
  data() {
    return {
      now: Date.now(),
      order: {
        items: []
      },
      suppliers: []
    };
  },
  created: function() {
    // Timer til at sikre computed felt isAfterDeadline er retvisende ift tidspunkt
    var self = this;
    setInterval(function() {self.now = Date.now()}, 30000);

    Axios.get("/mocked/suppliers.json").then(response => {
      this.suppliers = response.data.suppliers;
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