<template>
  <div>
    <Navigation :showNavIcon="true"></Navigation>
    <div class="container-fluid">
      <div class="row component-header">
        <div class="col">
          <h2>Brugeradministration</h2>
        </div>
      </div>
      <div class="row" style="margin-top: 20px;">
        <div class="col">
          <div class="container-fluid">
            <div class="row row-supplier align-items-center">
              <div class="col col-md-4">E-mail</div>
              <div class="col col-md-4">Navn</div>
              <div class="col col-md-2">Administrator</div>
              <div class="col" style="text-align: right;">
                <span @click="add()">
                  <octicon name="plus"></octicon>
                </span>
              </div>
            </div>
            <div class="row row-item align-items-center" v-for="user in users" :key="user.id">
              <div class="col col-md-4">
                <b-form-input
                  type="text"
                  size="sm"
                  v-model="user.mail"
                  v-if="user.edit == true"
                  required
                  :class="{ 'is-invalid': user.submitted && !validateMail(user) }"
                ></b-form-input>
                <span v-else>{{user.mail}}</span>
              </div>
              <div class="col col-md-4">
                <b-form-input
                  type="email"
                  size="sm"
                  v-model="user.name"
                  v-if="user.edit == true"
                  required
                  :class="{ 'is-invalid': user.submitted && !user.name }"
                ></b-form-input>
                <span v-else>{{user.name}}</span>
              </div>
              <div class="col col-md-2" style="text-align: center;">
                <b-form-checkbox
                  v-model="user.administrator"
                  value="true"
                  unchecked-value="false"
                  :disabled="user.edit != true"
                  switch
                />
              </div>
              <div class="col" style="text-align: right;">
                <span class="btn-check" v-if="user.edit" @click="submit(user)">
                  <octicon name="check"></octicon>
                </span>
                <span class="btn-edit" v-else @click="edit(user)">
                  <octicon name="pencil"></octicon>
                </span>
                <span class="btn-delete" @click="del(user)">
                  <octicon name="x"></octicon>
                </span>
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
import Octicon from "vue-octicon/components/Octicon.vue"
import { STLunchHelper } from '../_helpers/stlunch'
import "vue-octicon/icons";

export default {
  components: { Navigation, Octicon },
  data() {
    return {
      users: [
        {
          id: 1,
          mail: "helle.bohn@scott-tiger.dk",
          name: "Helle Bohn",
          administrator: "true"
        },
        {
          id: 2,
          mail: "maria.kragh@scott-tiger.dk",
          name: "Maria Kragh",
          administrator: "true"
        },
        {
          id: 3,
          mail: "lykke.luimes@scott-tiger.dk",
          name: "Lykke Luimes",
          administrator: "true"
        },
        {
          id: 4,
          mail: "torben.bolvig@scott-tiger.dk",
          name: "Torben Bolvig",
          administrator: "false"
        },
        {
          id: 5,
          mail: "ole.kramer@scott-tiger.dk",
          name: "Ole Kramer",
          administrator: "false"
        },
        {
          id: 6,
          mail: "tom.slivsgaard@scott-tiger.dk",
          name: "Tom Slivsgaard",
          administrator: "false"
        },
        {
          id: 7,
          mail: "maria.daugaard@scott-tiger.dk",
          name: "Maria Cecilie Daugaard",
          administrator: "false"
        }
      ]
    };
  },
  methods: {
    validateMail(user) {
      return STLunchHelper.validateMail(user.mail)
    },
    add() {
      var user = {
        id: -this.users.length,
        mail: "",
        name: "",
        administrator: false,
        edit: true
      };
      this.users.push(user);
    },
    edit(user) {
      user.edit = true;
      user.id += 0.0001;
      user.submitted = false;
    },
    submit(user) {
      user.id -= 0.0001;
      if (user.mail && user.name && this.validateMail(user)) {
        user.edit = false;
        user.id = parseInt(user.id.toFixed(0))
      } else {
        user.submitted = true;
      }
    },
    del(user) {
      var filtered = this.users.filter(u => u.id != user.id);
      this.users = filtered;
    }
  }
};
</script>