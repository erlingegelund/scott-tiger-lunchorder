<template>
  <div>
    <Navigation :showNavIcon="true"></Navigation>
    <div class="container-fluid">
      <div class="row" style="margin-top: 10px; margin-bottom: 10px;">
        <div class="col">
          <h2>Mine bestillinger</h2>
        </div>
      </div>
      <div class="row">
        <div class="col col-1">
          <span>Vælg dato:</span>
        </div>
        <div class="col">
          <b-form-input type="date" v-model="orderdate" @update="orderDateChange()" />
        </div>
      </div>
      <div class="row" style="margin-top: 20px;">
        <div class="col">
          <div class="container-fluid">
            <div class="row row-supplier">
              <div class="col col-4">Beskrivelse</div>
              <div class="col col-4">Valg</div>
              <div class="col col-2">Kommentar</div>
              <div class="col col-1" style="text-align: right;">Pris</div>
              <div class="col" style="text-align: right;">Antal</div>
            </div>
            <div
              v-for="order in orders"
              :key="order.orderid"
              class="row align-items-center row-item"
            >
              <div class="col col-4">{{order.description}}</div>
              <div class="col col-4">
                <table>
                  <tr v-for="opt in order.options" :key="opt.description" style="font-size: 0.8em;">
                    <td>{{opt.description}}:</td>
                    <td>
                      <span v-for="v in opt.value" :key="v" style="margin-right: 2px;">{{v}}</span>
                    </td>
                  </tr>
                </table>
              </div>
              <div class="col col-2">{{order.comment}}</div>
              <div class="col col-1" style="text-align: right;">
                <span>kr</span>
                {{order.price}}
              </div>
              <div class="col" style="text-align: right;">
                {{order.itemsOrdered}}
                <span v-show="showUpdateOrder()">
                  <b-button
                    size="sm"
                    :disabled="order.itemsOrdered === 0"
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
      <div class="row" style="margin-top: 20px;" v-show="showUpdateOrder()">
        <div class="col col-1">
          <b-button size="lg" variant="primary" :disabled="!orderUpdated">Opdater</b-button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import Navigation from "./Navigation";
export default {
  components: { Navigation },
  data() {
    return {
      orderdate: "",
      orderUpdated: false,
      deadline: "1000",
      orders: [
        {
          orderid: 0,
          description: "Fiskefilet med remoulade",
          comment: "",
          price: 15,
          itemsOrdered: 1
        },
        {
          orderid: 203,
          description: "Frikadelle med surt",
          comment: "",
          price: 15.0,
          options: [],
          itemsOrdered: 1
        },
        {
          orderid: 204,
          description: "Kalkunbryst med karrydressing",
          comment:
            "Jamen, jeg vil meget gerne skrive en meget lang novelle om, hvorfor jeg gerne spiser kalkunbryst med karrydressing",
          price: 35.0,
          options: [],
          itemsOrdered: 1
        },
        {
          orderid: 501,
          description: "Lille bland-selv salat",
          comment: "Fillidut og kager",
          price: 35.0,
          options: [
            {
              description: "Salat",
              value: [
                "Briccolisalat",
                "Couscous",
                "Pasta",
                "Hummus",
                "Revet gulerødder",
                "Tomater",
                "Agurker"
              ]
            },
            {
              description: "Dressing",
              value: ["Cremefraise"]
            },
            {
              description: "Kød",
              value: ["Kylling"]
            },
            {
              description: "Brød",
              value: ["Ja"]
            }
          ],
          itemsOrdered: 1
        }
      ]
    };
  },
  methods: {
    incrementOrder(item) {
      item.itemsOrdered++;
      this.orderUpdated = true;
    },
    decrementOrder(item) {
      if (item.itemsOrdered > 0) {
        item.itemsOrdered--;
        this.orderUpdated = true;
      }
    },
    showUpdateOrder() {
      var show = true;
      var now = new Date();
      var _orderDate = Date.parse(this.orderdate)
      if(_orderDate < now) {
        show = false
      } else {
        var hm = now.getHours() * 100 + now.getMinutes();
        show = (hm < this.deadline.valueOf())
      }

      return show;
    },
    orderDateChange() {}
  },
  created() {
    var today = new Date();
    var fmt = today.toISOString();
    this.orderdate = fmt.substr(0, 10);
  }
};
</script>
