<template>
  <div>
    <Navigation :showNavIcon="true"></Navigation>
    <div class="container-fluid">
      <div class="row" v-show="isBeforeDeadline()">
        <div class="col">
          <div
            v-show="isBeforeDeadline()"
            class="alert alert-warning"
            role="alert"
          >Det er kun muligt at bestille indtil kl {{deadlineFormatted()}}</div>
        </div>
      </div>
      <div v-for="sup in suppliers" :key="sup.id" class="row">
        <div class="col">
          <div @click="toggleChildren(sup)" class="row-supplier">
            <span v-if="sup.display">-</span>
            <span v-else>+</span>
            {{sup.name}}
          </div>
          <div class="container-fluid" v-show="sup.display">
            <div v-for="mcat in sup.menu" :key="mcat.catergory" class="row">
              <div class="col">
                <div @click="toggleChildren(mcat)" class="row-category">
                  <span v-if="mcat.display">-</span>
                  <span v-else>+</span>
                  {{mcat.category}}
                </div>
                <div class="container-fluid" v-show="mcat.display">
                  <div v-for="mitem in mcat.items" :key="mitem.id">
                    <div class="row row-item">
                      <div class="col-10">{{mitem.description}}</div>
                      <div class="col-2" style="text-align: right;">{{mitem.price}} kr</div>
                    </div>
                    <div class="row" v-show="mitem.options.length > 0">
                      <div class="col-2">
                        <span>Vælg:</span>
                      </div>
                      <div class="col-6">
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
                    <div class="row">
                      <div class="col-2">
                        <span>Kommentar:</span>
                      </div>
                      <div class="col-6">
                        <input type="text" class="form-control" size="50" v-model="mitem.comment" />
                      </div>
                      <div class="col-2" style="text-align: right;">Antal: {{mitem.itemsOrdered}}</div>
                      <div class="col-2" style="text-align: right;">
                        <button
                          class="btn btn-sm btn-secondary"
                          v-bind:disabled="mitem.itemsOrdered === 0"
                          @click="decrementOrder(mitem)"
                        >-</button>
                        <span>&nbsp;</span>
                        <button
                          class="btn btn-sm btn-secondary"
                          @click="incrementOrder(mitem)"
                          v-bind:disabled="isMandatoryMissing(mitem)"
                        >+</button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col col-1">
          <button
            class="btn btn-primary btn-lg"
            v-bind:disabled="order.items.length === 0 || isBeforeDeadline()"
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
import Navigation from "./Navigation.vue";
export default {
  components: { Multiselect, Navigation },
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
    isBeforeDeadline() {
      var rc = false;
      var now = new Date();
      var hm = now.getHours() * 100 + now.getMinutes();
      if (hm >= this.deadline.valueOf()) {
        rc = true;
      }
      return rc;
    },
    deadlineFormatted() {
      var fmtDeadline = this.deadline;
      if (this.deadline.length > 2) {
        fmtDeadline = this.deadline.substr(0, this.deadline.length - 2) + ":";
      } else {
        fmtDeadline = "0:";
      }
      fmtDeadline += this.deadline.substr(-2);
      return fmtDeadline;
    },
    submitOrder() {
      // Persist the order
      this.$router.push({name: 'UserHistory'})
    }
  },
  data() {
    return {
      deadline: "1000",
      order: {
        items: []
      },
      suppliers: []
    };
  },
  created: function() {
    Axios.get("/mocked/suppliers.json").then(response => {
      this.suppliers = response.data.suppliers;
    });
  }
};
</script>
<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

<style scoped>
.row-supplier {
  background-color: #444444;
  color: #aaaaaa;
  margin-top: 2px;
  margin-bottom: 2px;
  font-size: 1.4em;
}
.row-category {
  background-color: #ffffff;
  color: #444444;
  margin-top: 2px;
  margin-bottom: 2px;
  font-weight: bold;
}
.row-item {
  background-color: #aaaaaa;
  color: #222222;
  margin-top: 2px;
  margin-bottom: 2px;
}
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