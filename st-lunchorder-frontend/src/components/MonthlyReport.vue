<template>
  <div>
    <Navigation :showNavIcon="true"></Navigation>
    <div class="container-fluid">
      <div class="row component-header">
        <div class="col">
          <h2>Månedsrapport</h2>
        </div>
      </div>
      <div class="row align-items-center">
        <div class="col col-1">
          <span>Fra dato:</span>
        </div>
        <div class="col">
          <b-form-input type="date" v-model="orderdateFrom" @update="orderDateChange()" />
        </div>
      </div>
      <div class="row align-items-center">
        <div class="col col-1">
          <span>Til dato:</span>
        </div>
        <div class="col">
          <b-form-input type="date" v-model="orderdateTo" @update="orderDateChange()" />
        </div>
      </div>
      <div class="row" style="margin-top: 20px;">
        <div class="col col-md-8">
          <div class="container">
            <div class="row row-supplier">
              <div class="col col-md-4">Bestilt af</div>
              <div class="col" style="text-align: right;">Antal bestillinger</div>
              <div class="col col-md-3" style="text-align: right;">Samlet pris</div>
              <div class="col col-md-1 no-print"></div>
            </div>
            <div
              class="row row-item"
              v-for="order in orders"
              :key="order.user"
              @dblclick="toUserHistory(order.user)"
            >
              <div class="col col-md-4">{{order.user}}</div>
              <div class="col" style="text-align: right;">{{order.itemsOrdered}}</div>
              <div class="col col-md-3" style="text-align: right;">{{order.priceTotal}}</div>
              <div class="col col-md-1 no-print">
                <Octicon name="ellipsis"></Octicon>
              </div>
            </div>
            <div class="row row-supplier">
              <div class="col col-md-4">Total</div>
              <div class="col" style="text-align: right;">{{allItemsOrdered}}</div>
              <div class="col col-md-3" style="text-align: right;">{{allPriceTotal}}</div>
              <div class="col col-md-1 no-print"></div>
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
import { STLunchHelper } from '../_helpers/stlunch'
import "vue-octicon/icons";

export default {
  components: { Navigation, Octicon },
  data() {
    return {
      orderdateFrom: "",
      orderdateTo: "",
      orders: [
        { user: "Hans", itemsOrdered: 22, priceTotal: 417 },
        { user: "Grete", itemsOrdered: 17, priceTotal: 329 },
        { user: "Tornerose", itemsOrdered: 2, priceTotal: 84 }
      ]
    };
  },
  computed: {
    allItemsOrdered() {
      var nitems = 0;
      for (var i in this.orders) {
        nitems += this.orders[i].itemsOrdered;
      }
      return nitems;
    },
    allPriceTotal() {
      var price = 0;
      for (var i in this.orders) {
        price += this.orders[i].priceTotal;
      }
      return price;
    }
  },
  methods: {
    orderDateChange() {},
    toUserHistory(user) {
      this.$router.push({
        name: "UserHistory",
        params: {
          userId: user,
          fromdate: this.orderdateFrom,
          todate: this.orderdateTo
        }
      });
    }
  },
  created() {
    var today = new Date();
    this.orderdateTo = STLunchHelper.dateToString(today);
    today.setMonth(today.getMonth() - 1);
    this.orderdateFrom = STLunchHelper.dateToString(today);
  }
};
</script>
<style scoped>
@media print {
  .no-print {
    display: none;
  }
}
</style>