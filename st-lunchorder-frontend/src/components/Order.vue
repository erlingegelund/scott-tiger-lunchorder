<template>
  <div class="container-fluid">
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
                            </div>
                            <multiselect
                              v-model="opt.value"
                              :options="opt.selections"
                              v-bind:multiple="opt.multiple"
                              v-bind:close-on-select="!opt.multiple"
                              @select="optionAutoOrder(mitem)"
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
      <div class="col" style="text-align: right;">
        <button class="btn btn-primary btn-lg" v-bind:disabled="order.items.length === 0">Bestil</button>
      </div>
    </div>
  </div>
</template>
<script>
import Multiselect from "vue-multiselect";
export default {
  components: { Multiselect },
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
      if (filtered.length === 0) {
        this.incrementOrder(item);
      }
    },
    isMandatoryMissing(item) {
      if (item.options) {
        var manOpts = item.options.filter(opt => opt.mandatory);
        for (var i in manOpts) {
          if (manOpts[i].multiple && manOpts[i].value.length === 0) return true;
          else if (!manOpts[i].multiple && manOpts[i].value === "") return true;
          else return false;
        }
      }
      return false;
    }
  },
  data() {
    return {
      order: {
        items: []
      },
      suppliers: [
        {
          id: 1,
          display: true,
          name: "Slagter Lise og John",
          menu: [
            {
              category: "Salater",
              display: false,
              items: [
                {
                  id: 101,
                  description: "Stor salat med kød",
                  comment: "",
                  price: 35.0,
                  options: [
                    {
                      description: "Kød",
                      mandatory: true,
                      multiple: false,
                      value: "",
                      selections: ["Kylling", "Skinke", "Tun"]
                    }
                  ],
                  itemsOrdered: 0
                }
              ]
            },
            {
              category: "Smørrebrød",
              display: false,
              items: [
                {
                  id: 201,
                  description: "Fiskefilet med rejer",
                  comment: "",
                  price: 35.0,
                  options: [],
                  itemsOrdered: 0
                },
                {
                  id: 202,
                  description: "Fiskefilet med remoulade",
                  comment: "",
                  price: 15.0,
                  options: [],
                  itemsOrdered: 0
                },
                {
                  id: 203,
                  description: "Frikadelle med surt",
                  comment: "",
                  price: 15.0,
                  options: [],
                  itemsOrdered: 0
                },
                {
                  id: 204,
                  description: "Kalkunbryst med karrydressing",
                  comment: "",
                  price: 35.0,
                  options: [],
                  itemsOrdered: 0
                }
              ]
            }
          ]
        },
        {
          id: 2,
          display: false,
          name: "Bagels n' Cream",
          menu: [
            {
              category: "Salater",
              display: false,
              items: []
            },
            {
              category: "Bagels",
              display: false,
              items: []
            }
          ]
        },
        {
          id: 3,
          display: false,
          name: "Coffee & Sandwich",
          menu: [
            {
              category: "Salater",
              display: false,
              items: []
            },
            {
              category: "Sandwich",
              display: false,
              items: []
            }
          ]
        }
      ]
    };
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