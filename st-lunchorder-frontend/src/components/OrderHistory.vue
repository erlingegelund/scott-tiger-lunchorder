<template>
  <div>
    <Navigation :showNavIcon="true"></Navigation>
    <div class="container-fluid">
      <div class="row" style="margin-top: 10px; margin-bottom: 10px;">
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
              <div class="col">{{order.orderedBy}}</div>
              <div class="col col-2">{{order.supplier}}</div>
              <div class="col col-4">{{order.description}}</div>
              <div class="col col-3">
                <table>
                  <tr v-for="opt in order.options" :key="opt.description" style="font-size: 0.8em;">
                    <td>{{opt.description}}:</td>
                    <td>
                      <span v-for="v in opt.value" :key="v" style="margin-right: 2px;">{{v}}</span>
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
export default {
  components: { Navigation },
  data() {
    return {
      orderdate: "",
      orders: [
        {
          orderid: 0,
          description: "Fiskefilet med remoulade",
          comment: "",
          price: 15,
          itemsOrdered: 1,
          orderedBy: "Hans",
          supplier: "Slagter Lise & John"
        },
        {
          orderid: 203,
          description: "Frikadelle med surt",
          comment: "",
          price: 15.0,
          options: [],
          itemsOrdered: 1,
          orderedBy: "Grete",
          supplier: "Slagter Lise & John"
        },
        {
          orderid: 204,
          description: "Kalkunbryst med karrydressing",
          comment:
            "Jamen, jeg vil meget gerne skrive en meget lang novelle om, hvorfor jeg gerne spiser kalkunbryst med karrydressing",
          price: 35.0,
          options: [],
          itemsOrdered: 1,
          orderedBy: "Tornerose",
          supplier: "Slagter Lise & John"
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
          itemsOrdered: 1,
          orderedBy: "Rødhætte",
          supplier: "Coffee & Sandwich"
        }]
    };
  },
  methods: {
    orderDateChange() {}
  },
  created() {
    var today = new Date();
    var fmt = today.toISOString();
    this.orderdate = fmt.substr(0, 10);
  }
};
</script>
