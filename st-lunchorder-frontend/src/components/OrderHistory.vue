<template>
  <div>
    <Navigation :showNavIcon="true"></Navigation>
    <div class="container-fluid">
      <div class="row component-header">
        <div class="col">
          <h2>Dagens bestillinger</h2>
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
              <div class="col">Bestilt af</div>
              <div class="col col-2">Leverandør</div>
              <div class="col col-4">Beskrivelse</div>
              <div class="col col-3">Valg</div>
              <div class="col col-1" style="text-align: right;">Pris</div>
            </div>
            <div
              v-for="order in orders"
              :key="order.orderid"
              class="row align-items-center row-item"
            >
              <div class="col">{{order.user_name}}</div>
              <div class="col col-2">{{order.supplier_name}}</div>
              <div class="col col-4">{{order.menu_name}}</div>
              <div class="col col-3">
                <table>
                  <tr v-for="opt in order.options" :key="opt.description" style="font-size: 0.8em;">
                    <td>{{opt.description}}:</td>
                    <td>
                      {{opt.selected}}
<!--
                      <span v-for="v in opt.value" :key="v" style="margin-right: 2px;">{{v}}</span>
-->
                    </td>
                  </tr>
                </table>
              </div>
              <div class="col col-1" style="text-align: right;">
                <span>kr</span>
                {{order.price}}
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
import { STLunchHelper } from "../_helpers/stlunch";
import axios from "axios";

const orderHistoryURL = "/ords/stlunch/api/get-orders/";

export default {
  components: { Navigation },
  data() {
    return {
      orderdate: "",
      orders: []
    };
  },
  methods: {
    orderDateChange() {
      axios.get(orderHistoryURL + this.orderdate).then(
        response => {
          this.orders = response.data.orders;
          STLunchHelper.prepOrdersForReport(this.orders);
        }
      );
    }
  },
  created() {
    this.orderdate = STLunchHelper.dateToString(new Date());
    this.orderDateChange();
  }
};
</script>
