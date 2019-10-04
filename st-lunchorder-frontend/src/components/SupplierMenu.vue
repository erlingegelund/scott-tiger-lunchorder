<template>
  <div>
    <Navigation :showNavIcon="true"></Navigation>
    <div class="container-fluid">
      <div class="row component-header">
        <div class="col">
          <h2>Menu: {{supplier.name}}</h2>
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
                <div class="row row-item" @click="display(m)">
                  <div class="col col-md-2">
                    <span v-if="m.edit">
                      <b-input-group>
                        <span style="margin-top: 5px;">
                          <octicon name="chevron-down" />
                        </span>
                        <b-form-select
                          v-model="m.category"
                          size="sm"
                          :options="categories"
                          @change="setCategoryName(m)"
                          :class="{ 'is-invalid': m.submitted && !m.category }"
                        ></b-form-select>
                      </b-input-group>
                    </span>
                    <span v-else-if="m.display">
                      <span>
                        <octicon name="chevron-down" />
                      </span>
                      {{m.categoryName}}
                    </span>
                    <span v-else>
                      <span style="margin-right: 2px;">
                        <octicon name="chevron-right" />
                      </span>
                      {{m.categoryName}}
                    </span>
                  </div>
                  <div class="col col-md-6">
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
                  <div class="col col-md-1">
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
                  :key="opt.id"
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
                      value="true"
                      unchecked-value="false"
                      size="sm"
                      :disabled="!m.edit"
                      v-model="opt.mandatory"
                    >Obligatorisk</b-form-checkbox>
                    <b-form-checkbox
                      value="true"
                      unchecked-value="false"
                      size="sm"
                      :disabled="!m.edit"
                      v-model="opt.multiple"
                    >Vælg flere</b-form-checkbox>
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
import Octicon from "vue-octicon/components/Octicon.vue";

export default {
  name: "Menu",
  components: { Navigation, Octicon },
  data() {
    return {
      supplier: {
        id: 1,
        name: "Slagter Lise og John",
        mail: "slagterjohnoglise@live.dk",
        phone: "44332211"
      },
      menu: [
        {
          id: 201,
          description: "Fiskefilet med rejer",
          price: 35.0,
          options: [],
          category: 2,
          categoryName: "Smørrebrød",
          vkey: "201"
        },
        {
          id: 202,
          description: "Fiskefilet med remoulade",
          price: 15.0,
          options: [],
          category: 2,
          categoryName: "Smørrebrød",
          vkey: "202"
        },
        {
          id: 203,
          description: "Frikadelle med surt",
          price: 13.0,
          options: [],
          category: 2,
          categoryName: "Smørrebrød",
          vkey: "203"
        },
        {
          id: 204,
          description: "Kalkunbryst med karrydressing",
          price: 13.0,
          options: [],
          category: 2,
          categoryName: "Smørrebrød",
          vkey: "204"
        },
        {
          id: 205,
          description: "Salat med kød",
          price: 35.0,
          options: [
            {
              id: 499,
              description: "Kød",
              mandatory: true,
              multiple: false,
              selectables: "Kylling\nSkinke\nTun",
              additionalPrice: null
            }
          ],
          category: 1,
          categoryName: "Salater",
          vkey: "205"
        }
      ],
      categories: [
        { value: 1, text: "Salater" },
        { value: 2, text: "Smørrebrød" },
        { value: 3, text: "Bagels" },
        { value: 4, text: "Sandwich" },
        { value: 5, text: "Boller" }
      ]
    };
  },
  methods: {
    setVKey(mitem) {
      if (mitem.edit != true) mitem.edit = false;
      if (mitem.display != true) mitem.display = false;
      mitem.vkey =
        mitem.id.toString() +
        ":" +
        mitem.edit.toString() +
        ":" +
        mitem.display.toString();
      if (mitem.submitted === true || mitem.submitted === false) {
        mitem.vkey += ":" + mitem.submitted.toString();
      }
    },
    setCategoryName(mitem) {
      var categoryName = "Ukendt";
      var filtered = this.categories.filter(c => c.value == mitem.category);
      if (filtered) categoryName = filtered[0].text;

      mitem.categoryName = categoryName;
    },
    display(mitem) {
      if (mitem.edit !== true) {
        if (mitem.display === true) {
          mitem.display = false;
        } else {
          mitem.display = true;
        }
        this.setVKey(mitem);
      }
    },
    add() {
      var m = {
        id: -this.menu.length,
        description: "",
        price: 0,
        options: [],
        category: null,
        categoryName: null,
        edit: true
      };
      this.setVKey(m);
      this.menu.push(m);
    },
    edit(mitem) {
      mitem.edit = true;
      mitem.submitted = false;
      this.setVKey(mitem);
    },
    submit(mitem) {
      var allMandatoryFilled =
        mitem.category && mitem.description && mitem.price;
      for (var i in mitem.options) {
        allMandatoryFilled =
          allMandatoryFilled &&
          mitem.options[i].description &&
          mitem.options[i].selectables;
      }
      if (allMandatoryFilled) {
        mitem.edit = false;
        mitem.price = Number.parseInt(mitem.price)
      } else {
        mitem.submitted = true;
      }
      this.setVKey(mitem);
    },
    del(mitem) {
      var filtered = this.menu.filter(m => m.id != mitem.id);
      this.menu = filtered;
    },
    addOption(m) {
      var newId = -99;
      if (m.options) {
        newId = (m.options.length + 1) * -100;
      }
      var opt = {
        id: newId,
        description: "",
        mandatory: false,
        multiple: false,
        selectables: "",
        additionalPrice: null
      };
      m.options.push(opt);
    },
    delOption(m, opt) {
      var filtered = m.options.filter(o => o.id != opt.id);
      m.options = filtered;
    }
  },
  created: function() {
    // opret vkey i hver menu element - bruges til at kontrollere visning
    for (var i in this.menu) {
      this.setVKey(this.menu[i]);
    }
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