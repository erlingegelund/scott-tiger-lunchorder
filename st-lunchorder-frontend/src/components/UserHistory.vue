<template>
  <div>
    <Navigation :showNavIcon="true"></Navigation>
    <div class="container-fluid">
      <div class="row component-header">
        <div class="col">
          <h2>Mine bestillinger</h2>
        </div>
      </div>
      <div class="row align-items-center">
        <div class="col col-1">
          <span>Dato:</span>
        </div>
        <div class="col">
          <b-form-input type="date" v-model="orderdate" @update="orderDateChange()" />
        </div>
      </div>
      <div class="row" style="margin-top: 20px;">
        <div class="col">
          <div class="container-fluid">
            <div class="row row-supplier">
              <div class="col col-md-3">Beskrivelse</div>
              <div class="col col-md-4">Valg</div>
              <div class="col">Kommentar</div>
              <div class="col col-md-1" style="text-align: right;">Pris</div>
              <div class="col col-md-1" style="text-align: right;">Antal</div>
            </div>
            <div
              v-for="order in orders"
              :key="order.order_id"
              class="row align-items-center row-item"
            >
              <div class="col col-md-3">{{order.menu_name}}</div>
              <div class="col col-md-4">
                <table>
                  <tr v-for="opt in order.options" :key="opt.description" style="font-size: 0.8em;">
                    <td>{{opt.description}}:</td>
                    <td>{{opt.selected}}</td>
                  </tr>
                </table>
              </div>
              <div class="col">{{order.user_comment}}</div>
              <div class="col col-md-1" style="text-align: right;">
                <span>kr</span>
                {{order.total_price}}
              </div>
              <div class="col col-md-1" style="text-align: right;">
                {{order.items_ordered}}
                <span v-show="showUpdateOrder">
                  <b-button
                    size="sm"
                    :disabled="order.items_ordered === 0"
                    @click="decrementOrder(order)"
                    style="margin-left: 2px; margin-right: 2px;"
                  >-</b-button>
                  <b-button size="sm" @click="incrementOrder(order)">+</b-button>
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="row" style="margin-top: 20px;" v-show="showUpdateOrder">
        <div class="col col-1">
          <b-button
            size="lg"
            variant="primary"
            :disabled="!orderUpdated"
            @click="updateOrder()"
          >Opdater</b-button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import Navigation from "./Navigation";
import { STLunchHelper } from "../_helpers/stlunch";
import Axios from "axios";

const stlunchOrderURL = "/ords/stlunch/orders/";

export default {
  name: "user-history",
  components: { Navigation },
  data() {
    return {
      userId: JSON.parse(sessionStorage.getItem(STLunchHelper.userStorage)).user_id, // Læs bruger info fra sessionStorage
      orderdate: "",
      orderUpdated: false,
      now: Date.now(),
      orders: []
    };
  },
  methods: {
    incrementOrder(item) {
      item.items_ordered++;
      item.total_price = item.items_ordered * item.price;
      this.orderUpdated = true;
    },
    decrementOrder(item) {
      if (item.items_ordered > 0) {
        item.items_ordered--;
        item.total_price = item.items_ordered * item.price;
        this.orderUpdated = true;
      }
    },
    orderDateChange() {      
      Axios.get(
        STLunchHelper.userHistoryURL + this.userId + "/" + this.orderdate
      ).then(response => {
        this.orders = response.data.orders;
        STLunchHelper.prepOrdersForReport(this.orders);
      });
      this.orderUpdated = false;
    },
    updateOrder() {
      if (this.orderUpdated) {
        for (let i in this.orders) {
          if (this.orders[i].items_ordered == 0) {
            Axios.delete(stlunchOrderURL + this.orders[i].order_id);
            let filtered = this.orders.filter(
              o => o.order_id != this.orders[i].order_id
            );
            this.orders = filtered;
          } else {
            Axios.put(
              stlunchOrderURL + this.orders[i].order_id,
              this.orders[i]
            );
          }
        }
      }
      this.orderUpdated = false;
    }
  },
  computed: {
    showUpdateOrder() {
      return (
        STLunchHelper.isBeforeDeadline(this.orderdate, this.now) ||
        Date.parse(this.orderdate) > this.now
      );
    }
  },
  created() {
    let _orderDate = new Date();
    this.orderdate = STLunchHelper.dateToString(_orderDate);

    let orderItemsJSON = this.$route.params.orderItems;
    if (orderItemsJSON) {
      this.orders = JSON.parse(orderItemsJSON).orders;
      STLunchHelper.prepOrdersForReport(this.orders);
      if (this.orders.length > 0) {
        let orderMillis = Date.parse(this.orders[0].order_date);
        _orderDate.setTime(orderMillis);
      }
      this.orderdate = STLunchHelper.dateToString(_orderDate);
    } else {
      this.orderDateChange();
    }

    // Timer til at sikre computed felt showUpdateOrder er retvisende ift tidspunkt
    var self = this;
    setInterval(function() {
      self.now = Date.now();
    }, 30000);
  }
};
</script>
